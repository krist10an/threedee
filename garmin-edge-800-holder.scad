
// outer body
outer_diameter = 33.4;
inner_diameter = 29;
height = 5;

// flange
flange_inner_diameter = 25.4;
flange_height = 1;

// flange opening
fo_diameter = inner_diameter;
fo_height = 1.6;
fo_width = 11.6;


// spring load
springload_dist_from_top = 3;

springload_height = 1.6;
springload_diameter = 24;
springload_width = fo_width;


// spring load slots
slot_width =  2;
slot_length = 10;

slot_pos_x = 6;
slot_pos_y = slot_length - 2;


module ring(outer_radius, inner_radius, height, center=false) {
	difference() {
		cylinder(r=outer_radius, h=height, center);
		cyilnder(r=inner_radius, h=height*1.1, center);
	}
}

module outerbody()
{
	difference() {
		// cylinder for outer diameter
		cylinder(r=outer_diameter/2, h=height, center=true);
		union() {
			// remove center below flange
			translate([0,0,flange_height]) cylinder(r=inner_diameter/2, h=height, center=true);
			// remove everything inside flange
			cylinder(r=flange_inner_diameter/2, h=height, center=true);
		}
	}

}

module flange_opening()
{

	// make cube with rounded ends which fits inside inner diameter
	intersection() {
			cylinder(r=fo_diameter/2, h=height, center=true);
			cube(size=[fo_diameter, fo_width, height], center=true);
	}

}

module springloading()
{

	// slot is cube which is curved in both ends
	module slot() {
		union () {
			cube(size=[slot_width, slot_length, springload_height], center=true);
			translate([0, slot_length/2, 0]) cylinder(r=slot_width/2, h=springload_height, center=true, $fn=30);
			translate([0, -slot_length/2, 0]) cylinder(r=slot_width/2, h=springload_height, center=true, $fn=30);
		}
	}

	module lock() {
		cube(size=[1,2,height], center=true);
	}

	module connection_to_outside_wall() {
		// connecting spring loading to outer walls
		difference() {
			intersection() {
				cylinder(r=outer_diameter/2, h=springload_height, center=true);
				cube(size=[outer_diameter, springload_width/2, springload_height], center=true);
			}
			// remove center, to allow slots to be anywhere
			cylinder(r=springload_diameter/2, h=height, center=true);
		}
	}

	module spring_tension() {
		union() {
		rotate([-2, 0, 0]) cube(size=[springload_diameter/4, springload_diameter, springload_height], center=true);
		rotate([2, 0, 0]) cube(size=[springload_diameter/4, springload_diameter, springload_height], center=true);
		}
	}


	translate([0,0,-(height/2 + springload_height/2 - springload_dist_from_top)])  union() {
		connection_to_outside_wall();

		// actual spring loading
		difference() {
			cylinder(r=springload_diameter/2, h=springload_height, center=true);
			translate([ slot_pos_x,  slot_pos_y, 0]) slot();
 			translate([-slot_pos_x,  slot_pos_y, 0]) slot();
			translate([ slot_pos_x, -slot_pos_y, 0]) slot();
			translate([-slot_pos_x, -slot_pos_y, 0]) slot();
		}
		// locks

		difference() {
			union()  {
				translate([0, springload_diameter/3, 0]) rotate([85,0,0]) lock();
				translate([0, -springload_diameter/3, 0]) rotate([-85,0,0]) lock();
				//spring_tension();
			}
			// burde være translate springload_height men jukser her:
			translate([0,0, springload_height/2]) cylinder(r=springload_diameter/2, h=springload_height,  center=true);
		}

	}

}

velcro_slot_height = 3;
velcro_slot_width = 20;
velcro_slot_offset = 1;

holder_height = 7;
handlebar_diameter =30;

module holder() {
	difference() { 
		// outer body 
		cylinder(r=outer_diameter/2, h=holder_height, center=true);
		cylinder(r=inner_diameter/2, h=holder_height, center=true);

		// velcro slots
		translate([0, 0, -(holder_height/2-velcro_slot_height/2-velcro_slot_offset)]) rotate([0, 0, 0]) cube(size=[outer_diameter, velcro_slot_width, velcro_slot_height], center=true);
//		translate([0, 0, -(holder_height/2-velcro_slot_height/2-velcro_slot_offset)]) rotate([0, 0, 90]) cube(size=[outer_diameter, velcro_slot_width, velcro_slot_height], center=true);

		// handlebar curves
		translate([0, 0, handlebar_diameter]) rotate([90, 0, 0]) cylinder(r=handlebar_diameter, h=outer_diameter, center=true, $fn=50);
//		translate([0, 0, handlebar_diameter]) rotate([90, 0, 90]) cylinder(r=handlebar_diameter, h=outer_diameter, center=true, $fn=50);
	}
}

module garminedgeholder()
{
	union() {
		difference() {
			outerbody();
			flange_opening();
		}
		translate([0, 0, height/2 - springload_height/2]) springloading();
		translate([0, 0, height/2 + holder_height/2]) holder ();
	}
}

//$fn=100;
garminedgeholder();
