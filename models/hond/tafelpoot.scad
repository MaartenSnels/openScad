


wall         = 5;       // wall thickness
hPoot        = 80;      // hight the table has to rise
hOversteek   = 30;      // how much of the leg must be coverd
bPoot        = 36.3;    // with of leg
lPoot        = 162;     // length of leg
schroefGaten = true;    // screw legs together?

// berekend
dSchroefgat = bPoot - wall * 2;

// teken
pootBoven();
pootOnder();

module pootBoven() {
    dBinnen = [lPoot, bPoot, hOversteek  * 2];
    dBuiten = [lPoot + wall * 2, bPoot + wall * 2, hOversteek];
    
    translate([0, 0, hOversteek / 2 + hPoot])
    difference() {
        cube(dBuiten, center = true);
        cube(dBinnen, center = true);
    }
}

module pootOnder() {
    difference() {
        union() {
            onder();
            mirror([1,0,0]) onder();
            mirror([0,1,0]) onder();
            mirror([1,0,0]) mirror([0,1,0]) onder();
        }
        if (schroefGaten) {
            l = lPoot / 2 - wall - dSchroefgat;
            schroefGat();
            translate([-l, 0, 0]) schroefGat();
            translate([l, 0, 0]) schroefGat();
        }
    }
}

module schroefGat() {
    h = hPoot - dSchroefgat / 2;
    
    translate([0, 0, -wall]) {
        cylinder(d = dSchroefgat, h=h);
        translate([0, 0, h]) 
            sphere(d=dSchroefgat, center = true);
    }
    translate([0, 0, hPoot - wall * 2])
    cylinder(d = 4, h=wall * 4, $fn = 60);
}

module onder() {
    d = [lPoot, bPoot] / 2;
    scale = [  (lPoot / 2 + wall) / (lPoot / 2)
             , (bPoot / 2 + wall) / (bPoot / 2)];
    linear_extrude(   height=hPoot
                    , scale=scale
                    , slices=20
                    , twist=0
                    , center = false
                  )
        square(d);
}