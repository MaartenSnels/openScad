$fn = 60;

hor2Gleuf       =    9;  // afstand van hor tot de inkeping in het profiel
bGleuf          =    4;  // breedte van inkeping in het profiel
dGleuf          =    8;  // diepte van inkeping in het profiel
gleuf2Rand      =    3;  // vanaf inkeping tot rand van het profiel
dMax            =    5;  // maximaal uitsteken vanaf het profiel
rand2Profiel    =   17;
dStang          = 10.2; // diameter verstovingingsstangen

dMagneet        = 20;   // diameter magneet
hMagneet        = 1.2;  // hoogte magneet

wall = 2.2;
plaat = 2.8;

/////////// berekend //////////////////
hProfiel = hor2Gleuf + bGleuf + gleuf2Rand + wall;

translate([dMagneet, 0, 0] * 0) plaatClip();
//translate([dMagneet, 0, 0] * 3) magneetClip();
//translate([dMagneet, 0, 0] * 6) stangClipMagneet();


module plaatClip() {
    h = dMagneet * 2 + wall * 2;
    cube = [wall * 4 , wall + plaat, h];
    profiel(h);
    translate([cube.x, hProfiel, 0]) {
        steun(h = h, b = cube.y);
    }
    
    translate([0, hProfiel , 0]) {
        difference() {
            cube(cube);
            translate([-wall, 0, -h]) {
                cube([wall * 4, plaat, h * 3]);
            }
        }
    }
}

module steun(h=100, b = 10) {
    
    cube = [b / cos(45), b / cos(45), h];
    translate([0, 0, h / 2]) {
        difference() {
            rotate([0, 0, 45])
                cube (cube, center = true);
            translate([-cube.x, -cube.y * 2, -cube.z])
                cube(cube * 2, center = false);
            translate([-cube.x * 2, -cube.y, -cube.z])
                cube(cube * 2, center = false);
        }
    }
}

module stangClipMagneet() {
    h = dMagneet + wall * 2;
    dOut = dStang + wall * 2;
    dx = (dStang + wall) / 2;
    y = h * 2 ;
    dM = y/2 - wall -dMagneet / 2;
    
    translate([0, 0, h/2]) {
        difference() {
            union() {
                rotate([0, 0, 180])
                klem(dIn = dStang, dOut = dOut, h = h, hoek = 60);
                translate([dx, 0, 0]) {
                    cube([wall, y, h], center = true);  
                }
                translate([dOut / 4, 0, 0]) {
                    cube([dOut / 2, dOut, h], center = true);
                }
            }
            cylinder(d = dStang, h = h * 2, center = true);
            for (i = [-1, 1]) {
                translate([dx + wall / 2 - hMagneet, dM * i, 0])
                    rotate([0, 90, 0])
                        cylinder(d = dMagneet, h = h); 
            }
        }
    }
}

module klem(dIn = 100, dOut = 150, h = 100, hoek = 20) {
    rotate([0, 0, -90]) {
        difference() {
            cylinder(d = dOut, h = h, center = true); 
            cylinder(d = dIn, h = h * 2, center = true);
            translate([0, 0, -h])
            driehoek(hoek = hoek, l = h, h = h * 2); 
        }
        
        hk = hoek / 2;
        dC = (dOut - dIn) / 2;
        l = (dIn + dC) / 2;
        for(i = [1, -1]) {
            translate(l * [i * cos(hk), sin(hk)]) {
                cylinder(d = dC, h = h, center = true);
            }
        }
    }
}

/*
    gelijkbenige driehoek
    met de opgegeven hoek en hoogte
 */
module driehoek(hoek, l, h) {
    
    hk = hoek / 2;
    x = l / sin(hk);
    linear_extrude(h) {
        polygon([[0, 0], x * [cos(hk), sin(hk)], x * [-cos(hk), sin(hk)]]); 
    }
}

module hoek() {
}

module magneetClip() {
    h = dMagneet + wall * 2;
    cube = [wall * 2 + dMagneet, wall * 2, h];
    dY = hProfiel - cube.y;
    difference() {
        union() {
            profiel(h);
            translate([-cube.x, dY, 0]) {
                cube(cube);
            }
            translate([0, dY, h / 2])
            rotate([0, 0, 45]) {
                cube([wall, wall, h], center = true);
            }
        }
        translate([-cube.x / 2, dY + cube.y -hMagneet, h / 2])
            rotate([0, 90, 90])
                cylinder(d = dMagneet, h = h);

    }
}

module profiel(h, magneet = false) {
    cube([wall, hor2Gleuf, h]);
    translate([0, hor2Gleuf, 0]) {
        cube([dGleuf + wall, bGleuf, h]);
        translate([0, bGleuf, 0]) {
            cube([wall, gleuf2Rand, h]);
            translate([0, gleuf2Rand, 0]) {
                difference() {
                    cube([wall + rand2Profiel, wall, h]);
                    if(magneet) {
                        translate([wall + rand2Profiel / 2,  -h + hMagneet, h / 2]) {
                            rotate([0, 90, 90]) {
                                cylinder( d = dMagneet, h = h);
                            }
                        }
                    }
                }
            }
        }
    }
}