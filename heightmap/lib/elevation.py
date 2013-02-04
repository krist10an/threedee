from __future__ import division
import math
import numpy
import debug

def readhgt(filename):
	debug.write("Opening %s" % (filename))
	f = open(filename, "rb")
	hgt_string = f.read()

	tilesize = int(math.sqrt(len(hgt_string) / 2))
	if tilesize == 1201:
		resolution = 3
	elif tilesize == 3601:
		resolution = 1
	else:
		raise Exception('Error: Can only support 3" and 1" data')

	debug.write(" Tile size %d Resolution %d\"" % (tilesize, resolution))

	hgt_2darray = numpy.flipud(((numpy.fromstring(string=hgt_string, dtype='int16')).byteswap()).reshape(tilesize, tilesize))
	return tilesize, hgt_2darray

def gethgt(hgt_2darray, lat, lon):
	try:
		data = hgt_2darray[lat, lon]
		return data
	except:
		print "No height for %d,%d" % (lat, lon)
		return 0
