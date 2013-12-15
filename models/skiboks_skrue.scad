include <MCAD/nuts_and_bolts.scad>

// Bolt/skrue M6
total_height=20;
handle_height=6;
outer_diameter = 14.7 + 1;
handle_diameter = 30;

bottom_height = 4;

difference() {

	union() {
		translate([0,0,total_height-handle_height]) cylinder(r=handle_diameter/2, h=handle_height, center=false);
		cylinder(r1=outer_diameter/2, r2=handle_diameter/2, h=total_height-handle_height, center=false);
	}
	union() {
		for (i=[0:4]) {
			rotate(i*90, [0,0,1])
			translate([handle_diameter/2,0,0])
			cylinder(r=handle_diameter/5,h=total_height+0.1);
		}
		// should be larger than M6 to have loose fit on bolt
		translate([0,0,-1]) scale(1.05, [1,1,0]) boltHole(6, length=total_height, $fn=20);
		translate([0,0,bottom_height]) scale([1.03, 1.03, 10]) nutHole(6);
	}
}
