from generate import *
import re

name_match = re.compile("N([0-9][0-9])E([0-9][0-9][0-9])\.hgt")

def gen_tile(filename):
	out = os.path.join("output",filename+".jpg")
	print filename, out

	tilesize, mydata = readhgt(os.path.join(dir,filename))
	print "  Height min=%f, max=%f" % (mydata.min(), mydata.max())

	data = mydata.astype(numpy.float64)
	# Flip to make sure North is up
	data = numpy.flipud(data)
	data = data * 255 / 2600.0
	print "  AdjustedHeight min=%f, max=%f" % (data.min(), data.max())

	make_jpg(data, tilesize, out)


if __name__ == "__main__":

	dir = "input/Q33"
	#dir = "input-hi/"
	files = []
	for filename in os.listdir(dir):
		if name_match.match(filename):
			files.append(filename)
		else:
			print "nomatch", filename

	files.sort()

	for filename in files:
		gen_tile(filename)
