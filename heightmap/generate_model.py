"""
Script for parsing elevation data and generating output for a given lattitude/longitude

Supported input:
- STRM DEM (.hgt)

Supported output:
- Image (.jpg)
- Model (.scad)

Elevation data can be downloaded from:
http://www.viewfinderpanoramas.org/dem3.html
"""
from __future__ import division
import csv
import argparse
import sys
from latlon import *
from elevation import *
import debug

def generate(latlon, distance, target_size, minimum_height, remove_base_ele, input, outfile):
	filename = latlon.filename(input)
	if filename is None:
		# Unable to find height data
		return

	tilesize, hgt_2darray = readhgt(filename)

	lat = int(latlon.lat_val(min_only=True) * tilesize)
	lon = int(latlon.lon_val(min_only=True) * tilesize)

	debug.write("  Height for loaded file: min=%f, max=%f" % (hgt_2darray.min(), hgt_2darray.max()))

	lon_length = calc_lon_len(latlon.get_lat())
	lat_length = calc_lat_len(latlon.get_lon())

	elements_to_use_x = distance / (lat_length / tilesize)
	elements_to_use_y = distance / (lon_length / tilesize)
	size_x = int(elements_to_use_x)
	size_y = int(elements_to_use_y)
	debug.write("Length of 1\" longitude=%f meter" % (lon_length))
	debug.write("Length of 1\" lattitude=%f meter" % (lat_length))
	debug.write("Using %dx%d array elements" % (size_x, size_y))

	data = numpy.zeros(size_x*size_y, dtype=numpy.float64).reshape((size_x, size_y))
	for y in xrange(size_y):
		for x in xrange(size_x):
			ylon = (lon - size_y / 2) + y
			xlat = (lat + size_x / 2) - x
			zzz = gethgt(hgt_2darray, xlat, ylon)

			data[x,y] = zzz

	zmin = data.min()
	zmax = data.max()
	debug.write("  Height for selected data: min=%f max=%f" % (zmin, zmax))

	lowest_ele = 0
	highest_ele = zmax

	if remove_base_ele:
		print "Removing base ele of %d meters" % (zmin)
		lowest_ele = zmin
		data = data - zmin

	# Scale data from 0.0 to 1.0
	data = data / data.max()

	# Calculate model height based on scale
	target_height = target_size / distance * (highest_ele - lowest_ele)

	# Calculate model scale
	the_scale = distance / (target_size / 1000)

	print "Model scale data:"
	print " Model length=%.1f mm (Real life=%d meter)" % (target_size, distance)
	print " Model height=%.1f mm (Real life=%d-%d meter)" % (target_height, lowest_ele, highest_ele)
	print " Model scale=1:%d" % (the_scale)

	make_jpg(data*255, outfile+".jpg")

	# Scale data to target height
	data = data * target_height

	if data.min() < minimum_height:
		print " Adding minimum height of %.1f mm" % (minimum_height)
		data = data + minimum_height

	debug.write("  Height output data: min=%f max=%f" % (data.min(), data.max()))

	xscale = target_size / size_x
	sx = xscale
	sy = xscale * (size_x / size_y)
	sz = 1
	debug.write("   Scale x=%f y=%f z=%f" % (sx, sy, sz))
	make_scad(data, outfile+".scad", sx, sy, sz)

def read_places_from_csv(placesfile):
	places = {}
	csvfile = open(placesfile, "r")
	reader = csv.reader(csvfile, delimiter=";")
	for row in reader:
		# Strip away whitespace
		row = [item.strip() for item in row]
		try:
			key = row[0]
			name = row[1]
			latn = row[2]
			lat = [int(item) for item in row[3:6]]
			lone = row[6]
			lon = [int(item) for item in row[7:10]]
			radius = int(row[10])
			#print key, name, lat, lon, radius
			places[key] = (name, LatLon(lat, lon), radius)
		except:
			print "Invalid line", row
			#raise
	#print "Read %d places from %s" %(len(places),  placesfile)

	return places


if __name__ == "__main__":
	placesfile = "places.csv"

	places = read_places_from_csv(placesfile)
	targets = ["%s (%s)" % (item, places[item][0]) for item in places.keys()]

	import argparse
	parser = argparse.ArgumentParser(description="Generate heightmap from elevation data")
	parser.add_argument('target',
		nargs=1,
		help='The target to generate. Targets available from '+placesfile+' : ' + ' '.join(targets))
	parser.add_argument('-d', '--debug',dest='debug', action='store_const',
		const=True, default=False, help='Enable debug output')
	parser.add_argument('-i', '--input', dest='input', default="input/",
		help='Folder to read elevation data')
	parser.add_argument('-o', '--output', dest='output', default="output/heightmap",
		help='Folder and filename for output')
	parser.add_argument('-s', '--size', dest='size', type=float, default=80,
		help='Output size (in millimeter). Default: 80')
	parser.add_argument('-m', '--minheight', dest='minheight', type=float, default=0.6,
		help='Minimum height for elevation data (in millimeter). Default: 0.6')
	parser.add_argument('-b', '--base', dest='base', action="store_const", const=True, default=False,
		help='Remove base elevation')

	args = parser.parse_args()

	debug.enabled = args.debug
	target = args.target[0]
	infolder = args.input
	outfolder = args.output
	target_size = args.size
	min_height = args.minheight
	remove_base_ele = args.base

	try:
		name, latlon, radius = places[target]
	except KeyError:
		parser.print_help()
		print "\nError: '%s' is not a valid key" % (target)
		sys.exit(1)

	print "== Generating %s ==" % (name)
	generate(latlon, radius, target_size, min_height, remove_base_ele, infolder, outfolder)
