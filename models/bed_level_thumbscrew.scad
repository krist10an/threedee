include <MCAD/nuts_and_bolts.scad>
include <MCAD/boxes.scad>

fit = 1.05;

rotate([0, 180, 0]) difference() {
	union() {
		roundedBox([30,10, 4], 5, true, $fn=50);
	}

	translate([0,0,-2.01]) scale([fit, fit, fit]) nutHole(4);
	translate([0,0,-5]) scale([fit, fit, fit]) boltHole(4, MM, 10, $fn=50);
}
