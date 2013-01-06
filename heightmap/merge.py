"""
Merge the tiles generated by generate_tiles.py into one image

"""
import Image
import os
import re
import numpy

name_match = re.compile("N([0-9][0-9])E([0-9][0-9][0-9])\.hgt")

def main():

	files = []

	fn_min = 999
	fn_max = 0
	fe_min = 999
	fe_max = 0
	for filename in os.listdir("output"):
		result = name_match.match(filename)
		if result:
			n = int(result.group(1))
			e = int(result.group(2))
			fn_min = min(fn_min, n)
			fn_max = max(fn_max, n)
			fe_min = min(fe_min, e)
			fe_max = max(fe_max, e)
			files.append(filename)

	files.sort()
	num_n = fn_max - fn_min
	num_e = fe_max - fe_min

	filearray = [[0 for col in range(num_e+1)] for row in range(num_n+1)]

	part_size_w = 0
	part_size_h = 0
	for filename in files:
		result = name_match.match(filename)
		n = fn_max - int(result.group(1))
		e = int(result.group(2)) - fe_min
		i = Image.open("output/%s" % filename)
		w, h = i.size
		filearray[n][e] = (filename, i, w, h)
		if w > 0 and h > 0:
			part_size_w = w
			part_size_h = h

	for row in filearray:
		for column in row:
			if column == 0:
				print "       ",
			else:
				print column[0][:7],
		print ""

	print "Total of %d files" % (len(files))

	w = part_size_w * num_e
	h = part_size_h * num_n

	final = Image.new("RGB", (w, h))
	print "Creating image of dimentions",final.size
	posy = 0
	for row in filearray:
		posx = 0
		for iii in row:
			if iii != 0:
				filebane, i, w, h  = iii
				final.paste(i, (posx*w,posy*h))
			posx += 1
		posy += 1

	resultfile = "output/merged.jpg"
	final.save(resultfile)
	print "Saved output to", resultfile


if __name__ == "__main__":
	main()