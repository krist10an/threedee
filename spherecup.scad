
// My sphere cup

//cup size radius
cupsize_total = 65;

cupsize= cupsize_total /2;
wall_thickness = 6;

bottom_raise = 10;

handle_radius = 6;
handle_raise = 5;

too_large=cupsize*4;


$fn=50;


module outside() {
	difference() {
		// Main body
		sphere(r=cupsize);
		// Top
		translate([0, 0, 1.5*cupsize]) sphere(r=cupsize);
		// Bottom
		translate([0,0,-cupsize-too_large+bottom_raise])
			cylinder(r=too_large, h=too_large);

		// Sides
		for(i=[0,1,2,3]) {
			rotate([0,0,90*i])  translate([-cupsize*1.5, 0, 0])
				sphere(r=cupsize);
		}
	}
}

module inside()  {
intersection() {
	difference()  {
		// Main body
		sphere(r=cupsize-wall_thickness);
		// Bottom
		translate([0,0,-cupsize-too_large+bottom_raise+wall_thickness]) 
			cylinder(r=too_large, h=too_large);

		for(i=[0,1,2,3]) {
			rotate([0,0,90*i])  translate([-cupsize*1.5+wall_thickness, 0, 0])
				sphere(r=cupsize);
		}

	}

	cylinder(r=cupsize-2.0*wall_thickness, h=too_large, center=true);
  }
}

difference() {
	difference() {
		// Add outside
		outside();
		// Add cylinder for the handle
		//translate([5,5,1]) rotate([90,0,45]) cylinder(r=2, h=20, center=true);
	
		translate([cupsize/2,cupsize/2,handle_raise]) 
			rotate([90,0,45]) 
			cylinder(r=handle_radius , h=too_large, center=true);
	}
	difference() {
		// Remove inside
		inside();
		// Add extra wall for handle 
		translate([cupsize, cupsize, 0]) sphere(r=cupsize);
	}
}