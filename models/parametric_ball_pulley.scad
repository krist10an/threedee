// Parametric ball chain pulley http://www.thingiverse.com/thing:12403
// Based on "Parametric Ball Pulley" by zignig (http://www.thingiverse.com/thing:1322)

// Quality of cylinders/spheres
$fa = 10;
$fs = 0.4;

// 0 = use grub screws and captive nut
// 1 = use a hose clamp
// 2 = use two "flat spots" on the shaft
// 3 = use one "flat spot" on the shaft
fastening_method = 0;

// General options
shaft_diameter = 5.3;
ball_diameter = 5.0;
ball_count = 24;
ball_spacing = 5.1; // The distance from the centre of one ball to the next
link_diameter = 0.9;

// Screw options
screw_diameter = 3.05;
screw_count = 1;
nut_diameter = 6.3; // correct?
nut_height = 2.3; // correct?

// Hose clamp options
clamp_inner_diameter = 13;
clamp_width = 8;

// Flat spot options
flat_spot_diameter = 4;

// Calculate dimensions
PI = 3.1415927;
wheel_diameter = ball_count*ball_spacing / PI;
wheel_height = ball_diameter*1.5;
boss_diameter = ( fastening_method == 0 ? shaft_diameter + (nut_height*2)*2 : ( fastening_method == 1 ? clamp_inner_diameter : shaft_diameter*2 ) );
boss_height = ( fastening_method == 0 ? nut_diameter : ( fastening_method == 1 ? clamp_width : wheel_height ) );
pulley_height = wheel_height + boss_height;

module pulley () {
	difference()
	{
		cylinder (pulley_height, r = wheel_diameter/2, center=true, $fn = ball_count);
		
		// Boss cutout
		translate ([0, 0, pulley_height/2])
		difference () {
			cylinder (boss_height * 2, r = wheel_diameter, center=true);
			cylinder (boss_height * 4, r = boss_diameter/2, center=true);
		}
		
		// Balls
		translate ([0, 0, pulley_height/-2 + wheel_height/2])
		for (i = [1:ball_count])
		{	
			rotate ([0, 0, (360/ball_count) * i])		
			translate ([wheel_diameter/2,0,0])
			sphere (r = ball_diameter/2);
		}
		
		// Flat spot shaft
		if (fastening_method == 2 || fastening_method == 3) {
			intersection () {
				cylinder ( pulley_height*2, r = shaft_diameter/2, center = true);
				
				translate ([ (fastening_method == 3 ? shaft_diameter/2 - flat_spot_diameter/2 : 0) , 0, 0])
				cube ([flat_spot_diameter, shaft_diameter*2,  pulley_height*3], center = true);
			}
		}
		// Normal shaft
		else {
			cylinder (pulley_height*2, r = shaft_diameter/2, center=true);
		}
		
		// Holes for links between balls
		translate ([0, 0, pulley_height/-2 + wheel_height/2])
		rotate ([0, 0, -90]) // Rotate -90 to match face direction of cylinder
		rotate_extrude (convexity = 5, $fn = ball_count)
		translate ([wheel_diameter/2, 0, 0])
		circle (r = link_diameter/2, center = true);
		
		// Screw and nut holes
		if (fastening_method == 0) {
			translate ([0, 0, pulley_height/2 - boss_height/2])
			for (i = [1: screw_count]) {
				rotate ([0, 0, 360/screw_count * i]) {
					translate ([boss_diameter/2, 0, 0])
					rotate ([0 ,90 , 0])
					cylinder (boss_diameter, r = screw_diameter/2, center = true);
					
					translate ([shaft_diameter/2 + (boss_diameter/2 - shaft_diameter/2)/2 - nut_height/4, 0, 0]) {
						rotate ([0 , 90, 0])
						cylinder (nut_height, r = nut_diameter/2, center = true, $fn = 6);
						
						translate ([0, 0, boss_height / 2])
						cube ([nut_height, sin(60) * nut_diameter, boss_height], center = true);
					}
				}
			}
		}
		// Hose clamp "splines"
		else if (fastening_method == 1) {
			translate ([0, 0, pulley_height/2])
			for (i = [0:1]) {
				rotate ([0, 0, i * 90])
				cube ([0.7, boss_diameter*2 , boss_height * 2], center = true);
			}
		}
	}
}

translate ([0, 0, pulley_height/2])
pulley();

echo ( str ("Pulley height: ", pulley_height) );
echo ( str ("Pulley diameter: ", wheel_diameter ) );