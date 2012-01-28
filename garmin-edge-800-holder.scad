/*
 * Garmin Edge 800 velcro holder
 *
 * (c) krist10an 2012
 *
 */

// ---- Configuration ----

// outer body
outer_radius = 33.4/2;
inner_radius = 29/2;
height = 5;

// flange
flange_inner_radius = 25.4/2;
flange_height = 1;

// flange opening
fo_radius = inner_radius;
fo_height = 1.6;
fo_width = 11.6;


// spring load
springload_dist_from_top = 3;

springload_height = 1.6;
springload_radius = 24/2;
springload_width = fo_width;


// spring load slots
slot_width =  2;
slot_length = 10;

slot_distance_x = 12;
slot_distance_y= 5;

// holder
velcro_slot_height = 3;
velcro_slot_width = 20;
velcro_slot_offset = 2;

holder_height = 7;
handlebar_radius = 30/2;

/* -----
 * Ring
 *
 * or=outer radius
 * ir=inner radius
 * h = height
 */
module ring(or, ir, h, center=false) {
	difference() {
		cylinder(h=h, r=or, center=center);
		cylinder(h=h+1, r=ir, center=center);
	}
}


module flange_opening()
{
	opening_height = height+1;
	// make cube with rounded ends which fits inside inner diameter
	translate( [0,0,opening_height/2]) intersection() {
			cylinder(r=fo_radius, h=opening_height, center=true);
			cube(size=[fo_radius*2, fo_width, opening_height], center=true);
	}

}

module outerbody()
{
	difference() {
		union() {
			// Main ring
			ring(or=outer_radius, ir=inner_radius, h=height, center=false);
			// Flange
			translate([0,0,height-flange_height]) color("red") ring(outer_radius, flange_inner_radius, h=flange_height, center=false) ;
		}
		flange_opening();
	}
}


module slot()  {
			// main springload slots
			translate([slot_width/2 + slot_distance_x/2, 
					slot_length/2 + slot_distance_y/2,
					0]) 
						cube(size=[slot_width, 
									slot_length, 
									springload_height+1], center=true);
}


module springloading()
{
	difference() {
		union() {
			// main springload plate
			intersection() {
				cylinder(r=outer_radius, h=springload_height);
				translate([0,0,springload_height/2]) cube(size=[outer_radius*2, springload_width, springload_height], center=true);
			}
			cylinder(r=springload_radius, h=springload_height);
		}
		translate([0,0,(springload_height+1)/2]) union() {
			rotate([0,0,0]) slot();
			rotate([0,180,0]) slot();
			rotate([0,0,180]) slot();
			rotate([0,180,180]) slot();
		}
	}
}


module holder() {
	difference() {
		// outer body 
		ring(or=outer_radius/2, ir=inner_radius, h=holder_height, center=false);

		// velcro slot
		translate([0, 0, holder_height - velcro_slot_height/2 - velcro_slot_offset]) rotate([0, 0, 0]) 
				cube(size=[outer_radius * 2, velcro_slot_width, velcro_slot_height], center=true);

		// handlebar curves
		translate([0, 0, -handlebar_radius * 2 + holder_height / 2]) rotate([90, 0, 0])
				cylinder(r=handlebar_radius, h=outer_radius*2, center=true, $fn=50);
	}
}

module garminedgeholder()
{
	union() {
		outerbody();
		color("green") springloading();
		translate([0, 0, -holder_height+0.01-1]) color("blue") holder();
	}
}

//$fn=100;
garminedgeholder();
