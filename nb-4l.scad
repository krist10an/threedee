/*
 * Canon NB-4L battery eliminator design
 *
 * Based on http://www.thingiverse.com/thing:17437
 *
 * (c) krist10an 2012
 *
 */

hh = 6;
ll = 35;
ww = 40;

innerh = 3.6;

// overlap
oo = 0.01;

wall = (hh-innerh)/2;
echo ("Top and bottom wall size=",wall);

 difference() {
	cube(size=[ll,ww,hh],center=true);
	//Corners
	translate(v=[-ll/2+1,ww/2-1,1.5]) cube(size=[2+oo,2+oo,3+oo],center=true);
	translate(v=[ll/2-0.5,ww/2-1,1.5]) cube(size=[1+oo,2+oo,3+oo],center=true);

	//+ and GND pins
	//- Pin
	translate(v=[ll/2-2.5/2-3.5,ww/2-3/2+0.5,0]) #cube(size=[2.5,3,innerh],center=true);
	//Data/Not used
	translate(v=[ll/2-2.5/2-7,ww/2-0.5/2,0]) #cube(size=[2.5,0.5,innerh],center=true);
	//+ Pin
	translate(v=[ll/2-2.5/2-10.5,ww/2-3/2+0.5,0]) #cube(size=[2.5,3,innerh],center=true);

	//Room for desoldering wick
	//GND Part
	translate(v=[ll/2-1/2-3/2-1,ww/2-20/2-1.5,0]) cube(size=[1.5,20,innerh],center=true);
	translate(v=[ll/2-1/2-3/2-1-3.5,ww/2-20/2-1.5,0]) cube(size=[1.5,20,innerh],center=true);

	translate(v=[ll/2-1/2-3/2-2.5,0,0]) cube(size=[3.5,3,innerh],center=true);
	translate(v=[ll/2-1/2-3/2-2.75,-4,0]) cube(size=[1,5,innerh],center=true);
	translate(v=[7.75,-6,0]) cube(size=[11,1,innerh],center=true);
	//translate(v=[2,-19,0]) cube(size=[1,5,innerh],center=true);

	//+ Part
	translate(v=[ll/2-1/2-3/2-1-7,ww/2-20/2-1.5,0]) cube(size=[1.5,20,innerh],center=true);
	translate(v=[ll/2-1/2-3/2-1-3.5-7,ww/2-20/2-1.5,0]) cube(size=[1.5,20,innerh],center=true);
	translate(v=[ll/2-1/2-3/2-10,0,0]) cube(size=[3.5,3,innerh],center=true);
	translate(v=[3,0,0]) cube(size=[5,1,innerh],center=true);
	translate(v=[0,-2.5,0]) cube(size=[1,6,innerh],center=true);

	//Room for female servo connector
	translate(v=[0,-12.5,0]) cube(size=[8,15+oo,innerh],center=true);

	// Remove top to get convertible edition
	translate(v=[5.28,0,hh-wall-oo]) cube(size=[20,ww+oo,hh],center=true);
}
