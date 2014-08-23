// Polea para tirolina
// Hay que imprimir 2 y pegarlas
// para tener la polea completa
//
// Diametro exterior del rodamiento
// Valor maximo: 9
Rod = 8;
// Factor de contracción del ABS al enfriar
Contr = 0.1;
//
Diametro = Rod + Contr ;

difference() {
union() {
  cylinder(h=1, r=15, $fn=180);
  translate([0,0,1]) {
    cylinder(h=2.5, r1=15, r2=11, $fn=180);
  }
  translate([0,0,3.5]) {
    cylinder(h=1.5, r=11, $fn=180);
  }
}
cylinder(h=10, r=Diametro, $fn=180);
}