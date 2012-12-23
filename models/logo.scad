
include <MCAD/boxes.scad>
//include <MCAD/involute_gears.scad>
include <MCAD/gears.scad>


module cylinderhole(outrad, inrad, hh, center=true) {
	difference() {
		cylinder(h=hh, r=outrad, center=center);
		if (center==true) {
			cylinder(h=hh+1, r=inrad, center=center);
		} else {
			translate([0,0,-0.5]) cylinder(h=hh+1, r=inrad, center=center);
		}
	}
}

module halfk(ro, ri, hh) {
	translate([0,0,-hh/2]) difference() {
		cylinderhole(ro,ri,hh, center=false);
		translate([-ro, 0, -0.5]) cube(size=[ro*2,ri*2,hh+1], center=false);
	}
}

module logo(size, hh) {

	ww=size;
	dd=size/1.5;

	union() {
		difference() {
			roundedBox([ww, dd, hh], hh, true);
			roundedBox([ww*0.9, dd*0.9, hh+1], hh, true);
		}

		translate([-ww*0.1-ww*0.5/2, 0, 0]) rotate([0, 0, 0]) cube(size=[ww*0.1/2,ww/2,hh], center=true);
		translate([ ww*0.1, 0, 0]) rotate([   0,0,90]) halfk(ww*0.5/2, ww*0.4/2, hh);
		translate([-ww*0.1, 0, 0]) rotate([180,0,90]) halfk(ww*0.5/2, ww*0.4/2, hh);

		rotate([0, 0, 0]) cube(size=[ww*0.3,dd*0.1,hh], center=true);

		//linear_extrude(height=hh, center=true) gear(number_of_teeth=12,circular_pitch=200);
	}
}

//	cube(size=[10,10/1.6, 1], center=true);
