// Gopro Cable cam dolly
//
// Derivative of: http://www.thingiverse.com/thing:391146
tol = 0.01;

pulley_bolt_diameter = 8;
pulley_depth = 7+0.2;
pulley_outer_radius = 10;

body_length = 120;
body_height = 20;

wall_thicknes = 3;

camera_bolt_diameter = 3;

remove = wall_thicknes + 6;

// calculations
slot_width = pulley_depth + 2*wall_thicknes;
remove_center = body_length/2 - 2*pulley_outer_radius;
//remove_radius = body_length/2 - 2*pulley_outer_radius;
remove_radius = body_length/2;

echo("Slot width", slot_width);

module pulley_outer()  {
	rotate([0,90,0]) cylinder(r=pulley_outer_radius, h=slot_width);
}

module pulley_bolt_hole() {
   rotate([0,90,0]) translate([0,0,-1]) cylinder(r=pulley_bolt_diameter/2, h=slot_width+2);
}

rotate([0,0,-90]) difference() {
	union() {
		// Main body
		cube([slot_width,body_length,body_height]);
		// Pulley outer
		translate([0, pulley_outer_radius, body_height]) pulley_outer();
		translate([0, body_length-pulley_outer_radius, body_height]) pulley_outer();
	}
	// Slot in main body
	translate([wall_thicknes,-tol,wall_thicknes]) cube([pulley_depth,body_length+2*tol,body_height+100]);

	// Remove center of body
	translate([-1,body_length/2,remove_radius+remove]) rotate([0,90,0]) cylinder(r=remove_radius, h=slot_width+2*wall_thicknes);

	// Hole for bolts
	translate([0, pulley_outer_radius, body_height]) pulley_bolt_hole();
	translate([0, body_length-pulley_outer_radius, body_height]) pulley_bolt_hole();

	// Hole for camera
	translate([slot_width/2,body_length/2,-tol/2]) cylinder(r=camera_bolt_diameter/2, h=wall_thicknes+tol);

}