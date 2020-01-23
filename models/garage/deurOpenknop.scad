

dPlaat   = 80;
hPlaat   = 3;
dHole    = 22;
dSchroef = 4;


plaat();
nok();

module plaat() {
    
    difference() {
        minkowski(){
            cube([dPlaat - hPlaat * 2, dPlaat - hPlaat * 2, 0.01], true);
            sphere(d=hPlaat * 2, $fn =  60);
        }
        translate([0, 0, -hPlaat]) 
            cube([dPlaat, dPlaat, hPlaat * 2], true);
        cylinder(d=dHole, h = hPlaat * 3, center = true, $fn = 60);
        schroefGaten();
    }
    
}

module nok() {
    nokTerug = 1.5;
    nok = [2 + nokTerug, 3, 2 + hPlaat];
    translate([dHole / 2  - nokTerug, -nok.y / 2, 0])
    cube(nok);
}

module schroefGaten(aantal = 4) {
    l = sqrt(2 * pow(dPlaat / 2, 2)) - dSchroef * 3;
    for(i=[0:aantal - 1]) {
        echo(l, i);
        hoek = 360 / aantal * i + 45;
        x = l * cos(hoek);
        y = l * sin(hoek);
        translate([x, y, 0]) schroef();
    }
}

module schroef() {
    d1 = dSchroef;
    d2 = dSchroef * 1.5;
    h = hPlaat;
    
    cylinder(d1 = d1, d2 = d2, h  = h, $fn = 60);
    translate([0, 0, h])
        cylinder(d = d2, h  = hPlaat, $fn = 60);    
    translate([0, 0, -hPlaat])
        cylinder(d = d1, h  = hPlaat, $fn = 60);    
}