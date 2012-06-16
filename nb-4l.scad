difference() {
	cube(size=[35,40,6],center=true);
	//Corners
	translate(v=[-35/2+1,40/2-1,1.5]) cube(size=[2,2,3],center=true);
	translate(v=[35/2-0.5,40/2-1,1.5]) cube(size=[1,2,3],center=true);

	//+ and GND pins
	//- Pin
	translate(v=[35/2-2.5/2-3.5,40/2-3/2+0.5,0]) #cube(size=[2.5,3,3.6],center=true);
	//Data/Not used
	translate(v=[35/2-2.5/2-7,40/2-0.5/2,0]) #cube(size=[2.5,0.5,3.6],center=true);
	//+ Pin
	translate(v=[35/2-2.5/2-10.5,40/2-3/2+0.5,0]) #cube(size=[2.5,3,3.6],center=true);	

	//Room for desoldering wick
	//GND Part
	translate(v=[35/2-1/2-3/2-1,40/2-20/2-1.5,0]) cube(size=[1.5,20,3.6],center=true);
	translate(v=[35/2-1/2-3/2-1-3.5,40/2-20/2-1.5,0]) cube(size=[1.5,20,3.6],center=true);

	translate(v=[35/2-1/2-3/2-2.5,0,0]) cube(size=[3.5,3,3.6],center=true);
	translate(v=[35/2-1/2-3/2-2.75,-4,0]) cube(size=[1,5,3.6],center=true);
	translate(v=[7.75,-6,0]) cube(size=[11,1,3.6],center=true);
	//translate(v=[2,-19,0]) cube(size=[1,5,3.6],center=true);

	//+ Part
	translate(v=[35/2-1/2-3/2-1-7,40/2-20/2-1.5,0]) cube(size=[1.5,20,3.6],center=true);
	translate(v=[35/2-1/2-3/2-1-3.5-7,40/2-20/2-1.5,0]) cube(size=[1.5,20,3.6],center=true);
	translate(v=[35/2-1/2-3/2-10,0,0]) cube(size=[3.5,3,3.6],center=true);
	translate(v=[3,0,0]) cube(size=[5,1,3.6],center=true);
	translate(v=[0,-2.5,0]) cube(size=[1,6,3.6],center=true);

	//Room for female servo connector
	translate(v=[0,-12.5,0]) cube(size=[8,15,3.6],center=true);

}
