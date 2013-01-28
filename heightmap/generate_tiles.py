"""
Render HGT tiles to JPEG images

usage: <script> inputfolder1 inputfolder2 ..
"""
from generate import *
import sys
import re

name_match = re.compile("N([0-9][0-9])E([0-9][0-9][0-9])\.hgt")

def gen_tile(inputfile, outputfile):
	print "  Rendering %s to %s" %(inputfile, outputfile)
	tilesize, mydata = readhgt(inputfile)
	print "  Height min=%f, max=%f" % (mydata.min(), mydata.max())

	data = mydata.astype(numpy.float64)
	# Flip to make sure North is up
	data = numpy.flipud(data)
	data = data * 255 / 2600.0
	print "  AdjustedHeight min=%f, max=%f" % (data.min(), data.max())

	make_jpg(data, outputfile)

def generate(infolder, outfolder):
	files = []
	if not os.path.isdir(infolder):
		return 0

	for filename in os.listdir(infolder):
		if name_match.match(filename):
			files.append(filename)
		else:
			print "Ignoring file", filename

	files.sort()

	count = 0
	for filename in files:
		count += 1
		inp  = os.path.join(infolder, filename)
		outp = os.path.join(outfolder,filename+".jpg")
		gen_tile(inp, outp)

	return count

if __name__ == "__main__":
	if len(sys.argv) < 2:
		print __doc__
		sys.exit(1)

	infolders = sys.argv[1:]

	outfolder = "output"
	count = 0
	for folder in infolders:
		print "Processing", folder
		count += generate(folder, outfolder)

	print "Processed %d files and stored result in '%s'" % (count, outfolder)