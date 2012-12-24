from __future__ import division

from struct import unpack,calcsize
import Image
import numpy
import math
from latlon import *

"""
Script for processing elevation data from:
http://www.viewfinderpanoramas.org/

"""

def make_ply(pts, tris, outputfile):
	fd = open(outputfile, "w")
	fd.write("ply\n")
	fd.write("format ascii 1.0\n")
	fd.write("comment Awesome\n")

	fd.write("element vertex %d\n" % (len(pts)))
	fd.write("property float x\n")
	fd.write("property float y\n")
	fd.write("property float z\n")

	fd.write("element face %d\n" % (len(tris)))
	fd.write("property list uchar int vertex_index\n")
	fd.write("end_header\n")

	c = 0
	for pt in pts:
		c += 1
		fd.write(' '.join([str(x) for x in pt]) + "\n")

	for tri in tris:
		fd.write('3 '+' '.join([str(x) for x in tri]) + "\n")

	fd.close()
	print "Saved PLY %s (Vertices=%d Faces=%d)" % (outputfile, len(pts), len(tris))

def make_scad(pts, tris, outputfile):

	def prettyprint(stuff):
		#return str(stuff)
		s = "[ "
		for xx in stuff:
			s += str(xx) + ",\n"
		s += "]\n"
		return s

	fd = open(outputfile, "w")
	fd.write("scale([1,1,.1]) \n")
	fd.write("polyhedron( points = \n")
	fd.write(prettyprint(pts))
	fd.write(", triangles = \n")
	fd.write(prettyprint(tris))
	fd.write(");")
	fd.close()
	print "Saved scad %s" % (outputfile)

def heightmap(data, size, outputfile, aspect, target_size):
	"""
	Generate 3d model of heightmap

	Based on grid2scad.py: http://www.thingiverse.com/thing:12915
	"""
	pts  = []
	tris = []

	center = size / 2
	multiplier = 150 / size

	def mkpt(x,y,z):
		return [(x-center)*multiplier, (y-center)*multiplier*aspect, z*40]

	for i in xrange(0,size):
		for j in xrange(0,size):
			pts.append( mkpt(i,j,data[i][j]) )

	def tri(x,y):
		return x + y * size 

	for i in xrange(1,size):
		for j in xrange(1,size):
			tris.append([tri(i,j),tri(i-1,j-1),tri(i-1,j)])
			tris.append([tri(i,j),tri(i,j-1),tri(i-1,j-1)])

	offset = size * size

	for i in xrange(0,size):
		pts.append( mkpt(0,i,0) )
	for i in xrange(0,size):
		pts.append( mkpt(i,0,0) )
	for i in xrange(0,size):
		pts.append( mkpt(size-1,i,0) )
	for i in xrange(0,size):
		pts.append( mkpt(i,size-1,0) )

	for i in xrange(1,size):
		tris.append([offset+i, offset+i-1, i])
		tris.append([i-1,i,offset+i-1])
		tris.append([offset + size + i, i*size, offset + size + i-1])
		tris.append([(i-1)*size, offset + size + i-1, i*size])
		tris.append([offset + 2*size + i, size*(size-1)+i, offset + 2*size + i-1])
		tris.append([size*(size-1)+i-1  , offset + 2*size + i-1, size*(size-1)+i])

		tris.append([offset + 3*size + i, offset + 3*size + i-1, i*size + size-1])
		tris.append([(i-1)*size + size-1, i*size + size-1, offset + 3*size + i-1])

	off2 = offset + size*4
	pts.append( mkpt(size/2,size/2,0) )

	for i in xrange(1,size):
		tris.append([off2, offset+i-1, offset+i])
		tris.append([off2, offset+size+i, offset+size+i-1])
		tris.append([off2, offset+size*2+i, offset+size*2+i-1])
		tris.append([off2, offset+size*3+i-1, offset+size*3+i])

	#make_scad(pts, tris, outputfile+".scad")
	make_ply(pts, tris,outputfile+".ply")

def make_jpg(data, size, outfile):
	im = Image.new("RGB",(size, size))
	pix = im.load()

	for x in xrange(size):
		for y in xrange(size):
			pix[x,y] = (0, int(data[x,y]), 0)

	im.save(outfile)
	print "Saved JPG %s (Size=%dx%d)" % (outfile, size, size)

def readhgt(filename):
	print "Opening",filename,
	f = open(filename, "rb")
	hgt_string = f.read()

	tilesize = int(math.sqrt(len(hgt_string)/2))
	if tilesize == 1201:
		resolution = 3
	elif tilesize == 3601:
		resolution = 1
	else:
		raise Exception('Error: Can only support 3" and 1" data')

	print " Tile size %d Resolution %d\"" % (tilesize, resolution)

	hgt_2darray = numpy.flipud(((numpy.fromstring(string=hgt_string, dtype='int16')).byteswap()).reshape(tilesize,tilesize))
	return tilesize, hgt_2darray


def generate(latlon, distance, input, outfile):
	filename = latlon.filename(input)
	if filename is None:
		# Unable to find height data
		return

	tilesize, hgt_2darray = readhgt(filename)

	lat = int(latlon.lat_val(min_only=True) * tilesize)
	lon = int(latlon.lon_val(min_only=True) * tilesize)

	b_min = hgt_2darray.min()
	b_max = hgt_2darray.max()
	print "  Height for loaded file: min=%f, max=%f" % (b_min, b_max)

	def gethgt(lat, lon):
		try:
			data = hgt_2darray[lat, lon]
			return data
		except:
			print "No height for %d,%d" % (lat, lon)
			return 0

	lon_length = calc_lon_len(latlon.get_lat())
	lat_length = calc_lat_len(latlon.get_lon())
	aspect = lon_length / lat_length
	print "   Aspect lon/lat=%f (lat=%f, lon=%f)" % (aspect, lat_length, lon_length)

	tile_length = lon_length
	print "    Meters pr tile=", tile_length
	print "    Meters pr array item=", tile_length / tilesize
	meters = distance
	elements_to_use = meters / (tile_length / tilesize)
	size = int(elements_to_use)

	print "      Number of array items to use=", size

	data = numpy.zeros(size*size, dtype=numpy.float64).reshape((size,size))
	for y in xrange(size):
		for x in xrange(size):
			ylon = (lon - size / 2) + y
			xlat = (lat + size / 2) - x
			zzz = gethgt(xlat, ylon)

			data[x,y] = zzz

	zmin = data.min()
	zmax = data.max()
	print "  Height for selected data: min=%f max=%f" % (zmin, zmax)

	# Scale down to max possible elevation
	padding = 10
	max_ele = 2600
	#base_ele = (zmin + padding) # remove base elevation
	base_ele = -padding # add minimum for sea level

	if zmax > max_ele:
		print "WARNING: Height data larger than scale factor"

	data = (data - base_ele) / max_ele

	make_jpg(data*255, size, outfile+".jpg")
	heightmap(data, size, outfile, aspect, 150)



if __name__ == "__main__":

	places = {
		'GT' : ("Gaustatoppen", LatLon((59, 51, 14), (8, 39, 0)), 8000),
		'AB' : ("Austabotntind", LatLon((61, 26, 30), ( 7, 48,  3)), 4000),
		'STOR' : ("Storen", LatLon((61, 27, 41), ( 7, 52, 26)), 8000),
		'SNO' : ("Snohetta", LatLon((62, 19, 11), ( 9, 16,  3)), 4000),
		'GP' : ("Galdhoepiggen", LatLon((61, 38,  7), ( 8, 18, 46)), 6000),
		'ST' : ("Stetind", LatLon((68,  9, 55),(16, 35, 16)), 3000),
	}

	target = "GT"
	name, latlon, radius = places[target]

	print "== Generating %s ==" % (name)
	generate(latlon, radius, "input/", "output/heightmap")
