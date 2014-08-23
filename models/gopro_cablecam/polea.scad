// Pulley zip line
//
// Derivative of: http://www.thingiverse.com/thing:391146
//
// Have to print 2 for complete pulley
// Designed to fit a 7mm wide bearing
//
// Outer diameter of the bearing
// Maximum Value: 26
Rod = 22;
// ABS shrinkage factor upon cooling
Contr = 0.1;

Diametro = Rod / 2 + Contr ;

$fn=180;
difference() {
union() {
  cylinder(h=1, r=17);
  translate([0,0,1]) {
    cylinder(h=2, r1=17, r2=13);
  }
  translate([0,0,3]) {
    cylinder(h=0.5, r=13);
  }
}
translate([0,0,-0.01]) cylinder(h=10, r=Diametro);
}
