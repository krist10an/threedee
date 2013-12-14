include <MCAD/nuts_and_bolts.scad>

// Bolt/skrue M6
total_height=20;
handle_height=12;
inner_diameter = 6.7;
outer_diameter = 14.7 + 3;
insert_diameter = 8.8;
handle_diameter = 30;

difference() {

	union() {
		translate([0,0,total_height-handle_height]) cylinder(r=handle_diameter/2, h=handle_height, center=false);
		cylinder(r=outer_diameter/2, h=total_height, center=false);
	}
	union() {
		for (i=[0:3]) {
			rotate(i*120, [0,0,1])
			translate([handle_diameter/2,0,0])
			cylinder(r=handle_diameter/5,h=total_height);
		}
		translate([0,0,10]) cylinder(r=insert_diameter/2+0.3, h=total_height, center=false);
		// should be larger than 6 to have loose fit on bolt
		scale(1.03, [1,1,0]) boltHole(6, length=total_height, $fn=20);
		scale(1.02, [1, 1, 0]) nutHole(6);
	}
}
