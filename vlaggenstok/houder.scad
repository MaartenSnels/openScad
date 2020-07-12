use </home/maarten/Documents/openScad/maarten.scad>

dPole = 30;
wall = 4;
hPijp = 100;
hoek = 45;
grondPlaat = [120, 80, wall + 1]; 
ringD = 27;
ringH = 1.75;
ringGat =5;



vlaggenHouder();

module vlaggenHouder() {
    difference() {
        union() {
            grondPlaat();
            pijp(hoek);
            steunen();
        }
        schroefGaten();
        afwateringsGat();
    }
}

module pijp(hoek = 60, masief = false) {
    d = dPole + wall * 2;
    dTube = 5;
    difference() {
        rotate([0, hoek, 0]) {
            difference() {
                union() {
                    up(hPijp)
                        tubularRing(dTube = dTube, dRing = d + dTube/2, fn = 60, angle = 360);
                    cylinder(d = d, h = hPijp * 2, $fn = 60, center = true);
                    zijSteun();
                }
                if (!masief) {
                    cylinder(d = d - wall * 2, h = hPijp * 3, $fn = 60, center = true);
                }
            }
        }
        up(-hPijp * 2)
            cube([1, 1, 1] * hPijp * 4, center = true);
        rotate([0, -90, 0])
            cylinder(r = wall, h = dPole, center = false, $fn = 10);
    }
}

module grondPlaat() {
    up(grondPlaat.z / 2)
        roundedCube(grondPlaat, center = true, radius = 10 / 2);
}

module steunen() {
    r   = dPole / 2 + wall;
    difference() {
        union() {
            onderSteun();
            bovenSteun();
        }
        rotate([0, hoek, 0]) cylinder(r = r, h = hPijp * 2, center = true);
        tr([0, 0, hPijp], [0, hoek, 0]) cylinder(r = r * 2, h = hPijp, center = false);
        up(-hPijp * 2)
            cube([1,1,1] * hPijp * 4, center = true);
    }
        
}

module bovenSteun() {
    hk1 = hoek;
    r   = dPole / 2 + wall;
    x1  = r  / cos(hk1);
    h1  = hPijp  - x1 * sin(hk1);
    
    x2 = grondPlaat.x / 2 - wall;
    dx = h1 * sin(hk1) - x2 + x1; // vershuiving bovenste punt t.o.v. x2
    hk2 = atan(( dx) / (h1 * cos(hk1)));
    h2 = hPijp - x2 * sin(hk2);
    
    hull() {
        rt([0, hk2, 0], [x2, 0, 0])
            cylinder(d = wall, center = false, h = h2 * 2, $fn = 60, center = true);
        rt([0, hk1, 0], [x1, 0, 0])
            cylinder(d = wall, center = false, h = h1 * 2, $fn = 60, center = true);
    }

}


module onderSteun() {
    hk1 = hoek;
    r   = dPole / 2 + wall;
    x1  = r  / cos(hk1);
    h1  = hPijp  + x1 * sin(hk1);
    
    x2 = grondPlaat.x / 2 ;
    dx = h1 * sin(hk1) + x2 - x1; // vershuiving bovenste punt t.o.v. x2
    hk2 = atan(( dx) / (h1 * cos(hk1)));
    h2 = hPijp + x2 * sin(hk2);
    difference() {
        hull() {
            rt([0, hk2, 0], [-x2, 0, 0])
                cylinder(d = wall, center = false, h = h2 * 2, $fn = 60, center = true);
            rt([0, hk1, 0], [-x1, 0, 0])
                cylinder(d = wall, center = false, h = h1 * 2, $fn = 60, center = true);
        }
        translate([-grondPlaat.x, 0, 0] * 1.5)
            cube(grondPlaat * 2, center = true);
    }
    
}

module zijSteun() {
    y = (grondPlaat.y - wall)/ 2;
    d = dPole / 2 + wall;
    hoek = atan((y - d) / hPijp);
    h = hPijp / cos(hoek);
    hull() {
        for(i = [-1,1]) {
            rt([i * hoek, 0, 0], [0, i * y, 0])
                    cylinder(d = wall, center = false, h = h, $fn = 60);
        }
        
    }
}

module afwateringsGat() {
    r = dPole / 2 - wall;
    d = wall;
    for(i = [1,-1])
        rt([0,-90, 0], [-dPole/3, i * wall, grondPlaat.z])
            cylinder(d = d, h = dPole / 2, center = false, $fn = 60);
}

module schroefGaten() {
    marge = 6;
    x = (grondPlaat.x - ringGat)/ 2 - marge;
    y = (grondPlaat.y - ringGat)/ 2 - marge;
    z = grondPlaat.z - 2;
    for(i = [-1, 1]) {
        for (j = [-1,1]) {
            translate([x * i, y * j, 0]) {
                cylinder(center = true, h = grondPlaat.z * 4, d = ringGat, $fn = 60); 
                up(z * 1.25)
                    cylinder(center = false, h = 2.1, d1 = ringGat, d2 = ringGat * 2, $fn = 60); 
            }
        }
    }
    
    
}