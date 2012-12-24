import os.path
import math

def deg2rad(deg):
	return deg * math.pi / 180.0

def calc_lon_len(deg):
	"""
	Calculate the length in meters for a longnitudal degree
	"""
	Mr = 6367449.0
	phi = deg2rad(deg)
	return math.pi / 180.0 * Mr * math.cos(phi)

def calc_lat_len(deg):
	"""
	Calculate length in meters of a degree at lattitude deg
	"""
	aa = 111132.954
	bb = 559.822
	cc = 1.175
	phi = deg2rad(deg)
	return aa - bb * math.cos(2*phi) + cc * math.cos(4*phi)



def findInSubdirectory(filename, subdirectory=''):
	if subdirectory:
		path = subdirectory
	else:
		path = os.getcwd()

	if not os.path.isdir(path):
		print "No path", path

	for root, dirs, names in os.walk(path):
		if filename in names:
			return os.path.join(root, filename)

	return None


def get_val(deg, min, sec, min_only=False):
	if min_only:
		return min/60.0 + sec/3600.0
	else:
		return deg + min/60.0 + sec/3600.0

class LatLon(object):
	"""
	Latitude = x
	Longitude = y
	"""
	def __init__(self, lat, lon):
		if len(lat) != 3 or len(lon) != 3:
			raise Exception("Unsupported lat/lon")

		self._lat = lat
		self._lon = lon

	def get_lat(self):
		return self._lat[0]

	def get_lon(self):
		return self._lon[0]

	def lat_val(self, min_only=False):
		return get_val(*self._lat, min_only=min_only)

	def lon_val(self, min_only=False):
		return get_val(*self._lon, min_only=min_only)

	def filename(self, searchpath):
		filename = "N%02dE%03d.hgt" % (self._lat[0], self._lon[0])
		path = findInSubdirectory(filename, searchpath)
		if path is None:
			print "Cannot find", filename

		return path

	def get_ratio(self):
		#print "calc ration for", self.lon[0], self.lat[0]
		lonl = calc_lon_len(self.lon[0])
		latl = calc_lat_len(self.lat[0])
		ratio = lonl/latl
		#print "  Lengde lat=%d, lon=%d, forhold=%f" % (lonl, latl, ratio)
		return ratio
