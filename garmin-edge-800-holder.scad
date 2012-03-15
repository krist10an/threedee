/*
 * Garmin Edge 800 velcro holder
 *
 * (c) krist10an 2012
 *
 */

use <logo.scad>

// ---- Configuration ----

// outer body
outer_radius = 33.4/2;
inner_radius = 29/2;

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
springload_radius = 23/2;
springload_width = 10;

// spring load slots
slot_width =  2;
slot_length = 10;

slot_distance_x = 12;
slot_distance_y= 5;

// holder
velcro_slot_height = 3;
velcro_slot_width = 22;
velcro_slot_offset = 1;

holder_height = 8;
handlebar_radius = 30/2;


// outer body
top_to_springload = 3;
height = springload_height+top_to_springload;


// Used to ensure overlap between objects
overlap = 0.01;
overlapmul = 1.1;


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
		if (center == true) {
			echo("centered");
			cylinder(h=h*overlapmul, r=ir, center=center);
		} else {
			translate([0,0,-(h*overlapmul-h)/2]) cylinder(h=h*overlapmul, r=ir, center=center);
		}
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
			translate([0,0,height-flange_height]) /*color("red")*/ ring(outer_radius-overlap, flange_inner_radius, h=flange_height, center=false) ;
		}
		flange_opening();
	}
}


module slot()  {
	// main springload slots
	translate([0,slot_width/2,0]) union() {
		translate([slot_width/2 + slot_distance_x/2,
				slot_length/2 + slot_distance_y/2,
				0])
			cube(size=[slot_width, slot_length,
				springload_height+overlap], center=true);

		translate([slot_width/2 + slot_distance_x/2,
				slot_distance_y/2,
				0])
			cylinder(r=slot_width/2,
				h=springload_height+overlap,
				center=true, $fn=50);
	}
}

module triangle2(w, h, b) {
	rotate(a=[90,-90,0])
	linear_extrude(height = w, center = true, convexity = 10, twist = 0)
	polygon(points=[[0,0],[h,0],[0,b]], paths=[[0,1,2]]);
}

module spring() {
	intersection() {
		union() {
			translate([0,springload_radius,0]) rotate([0, 0, 90]) triangle2(slot_distance_x-overlap, 1, springload_radius);
			translate([0,springload_radius,0]) rotate([0, 0, 90]) triangle2(2, 2, springload_radius/2);
		}
		cylinder(r=springload_radius, h=springload_height*100);
	}
}

module springloading()
{
	difference() {
		union() {
			// main springload plate
			intersection() {
				cylinder(r=outer_radius-overlap, h=springload_height);
				translate([0,0,springload_height/2]) cube(size=[outer_radius*2, springload_width, springload_height], center=true);
			}
			cylinder(r=springload_radius, h=springload_height);
			translate([0,0,springload_height-0.3]) rotate([0,0,0]) spring();
			translate([0,0,springload_height-0.3]) rotate([0,0,180]) spring();
		}
		translate([0,0,springload_height/2]) union() {
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
		ring(or=outer_radius, ir=inner_radius, h=holder_height, center=false);

		// velcro slot
		translate([0, 0, holder_height - velcro_slot_height/2 - velcro_slot_offset]) rotate([0, 0, 0]) 
				cube(size=[outer_radius*2+overlap, velcro_slot_width, velcro_slot_height], center=true);

		// handlebar curves
		translate([0, 0, -handlebar_radius*2 + holder_height / 2]) rotate([90, 0, 0])
				cylinder(r=handlebar_radius*2, h=outer_radius*2*overlapmul, center=true, $fn=50);
	}
}

module garminedgeholder()
{
	union() {
		outerbody();
		//cylinder(h=0.01, r=outer_radius*2);
		difference() {
			/*color("green")*/ springloading();
			rotate([0,0,90]) translate([0,0,0.25-0.01]) logo(15, 0.5);
		}

		translate([0, 0, -holder_height+overlap]) /*color("blue")*/ holder();
	}
}

$fn=100;
echo("Body height");
echo(height);
echo(height+holder_height);

garminedgeholder();
