
include <MCAD/boxes.scad>
//include <MCAD/involute_gears.scad>
include <MCAD/gears.scad>


module cylinderhole(outrad, inrad, hh, center=true) {
	difference() {
		cylinder(h=hh, r=outrad, center=center);
		cylinder(h=hh, r=inrad, center=center);
	}
}

module halfk(ww, dd, hh) {
	translate([0,0,-hh/2]) difference() {
		cylinderhole(ww,dd,hh, center=false);
		translate([-ww, 0, 0]) cube(size=[ww*2,ww*2,hh], center=false);
	}
}

module logo(ww, dd, hh) {

	union() {
		difference() {
			roundedBox([ww, dd, hh], hh, true);
			roundedBox([ww*0.9, dd*0.9, hh], hh, true);
		}

		translate([0,-5, 0]) rotate([  0,0,0]) halfk(10, 8, hh);
		translate([0, 5, 0]) rotate([180,0,0]) halfk(10, 8, hh);
		translate([0, -15, 0]) cube(size=[20,2,hh], center=true);

		rotate([0, 0, -90]) cube(size=[20,2,hh], center=true);
		//linear_extrude(height=hh, center=true) gear(number_of_teeth=12,circular_pitch=200);
	}
}

logo(30, 40, 5); 
