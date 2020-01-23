use <maarten.scad>

wall = 2;             // standaard wanddikte
thinWall = 1;         // doorschijnende wanden
//gap = 20;             // gat tussen leds en doorschijning
hoogteKlok = 35;      // totale hoogte van de klok
aantalSegmenten = 1 ; // wat moet geprint worden

// gegeven led strip
dStrip  = 1.5;      // dikte van de ledstrip
hStrip  = 11;       // hoogte van de ledstrip
kStrip = 2;         // klem hoogte
uurLPM = 144;        // leds per meter uur ring
secLPM = 96;        // lerd per meter seconde ring

// constanten
PI = 3.1415;

// berekend
hoek = 360 / aantalSegmenten;
dSec = straal(secLPM);
dUur = straal(uurLPM);
//dMin1 = (78.74 + 72.39) / 2; // aliexpress ring 1
//dMin2 = 170 / 2;             // aliexpress ring 2
//echo (dMin1 = dMin1, dMin2 = dMin2);
echo(dUur = dUur, dSec = dSec, hoek = hoek);
gap = abs(dSec - dUur) /4 - wall  / 2;             // gat tussen leds en doorschijning


///////////////////////////////////////
/////////// TEKEN /////////////////////
///////////////////////////////////////
ledStripRing(d = dSec, angle = hoek, fn = 120, outer = false);
ledStripRing(d = dUur, angle = hoek, fn = 120, outer = true);
//minRing();

//tube2D();
//ledStripMount();
//drieHoek2D([dStrip + wall, dStrip + wall]);

////////////////////////////////////////
/////// ELEMENTEN //////////////////////
////////////////////////////////////////

module ledStripRing(d, angle = hoek, outer, fn = 120) {
    rotatePart(d = d, angle = angle, fn = fn) tube2D(outer);
}

module rotatePart(d = 100, angle = 360, fn = 60) {
    echo(d=d,angle=angle);
    rotate_extrude(angle = angle, $fn = fn ) {
        translate([d / 2, 0, 0]) {
            children();
        }
    }

}

//!tube2D();
module tube2D(outer = true) {
    
    b = wall * 2 + gap;
    h = hoogteKlok - wall;
    t = (hoogteKlok - 2 * wall - hStrip) / 2;
    mirror([outer ? 0 : -1, 0, 0]) {
        translate([-wall, 0, 0]) {
            difference() {
                roundedSquare([b,h], wall);
                translate([wall, wall, 0])
                    square([b - wall * 2, h]);
            }
            translate([wall, wall + t, 0])
                ledStripMount(); 
            }
    }
}

module ledStripMount() {
    square([dStrip + wall, wall]);
    translate([dStrip, 0, 0])
        square([wall, wall + kStrip]);
    mirror([0, -1, 0]) drieHoek2D([dStrip + wall, dStrip + wall]);
}

module roundedSquare(size = [10, 5], d = 1, fn = 60) {
    translate([d, d, 0] / 2)
        circle(d=d, $fn = fn);
    translate([size.x, 0, 0] + [-d, d, 0] / 2)
        circle(d=d, $fn = fn);
    translate([d/2, 0, 0])
        square([size.x - d, d]);
    translate([0, d/2, 0])
        square([size.x, size.y - d]);
}

module drieHoek2D(size) {

    angle = atan(size.y / size.x);
    f = sqrt(size.x * size.x + size.y * size.y) / max(size);
    echo (angle=angle, f = f);
    difference() {
        square(size);
        translate([0, size.y, 0])
        rotate([0, 0, -angle])
            square(size * f);
    }

}

module minRing() {
    up(hoogteKlok / 2 - wall)
        difference() {
            rotatePart(d = dUur, angle = hoek)
                square([(dSec - dUur) / 2, wall]);
            ledGaten();
        }

}

module ledGaten() {
    // 60 leds
    
    for (i = [0 : 6 : hoek]) {
        rotate([0, 0, i])
        translate([dMin, 0, 0]) 
            cylinder(d=10, h=3 * wall, center = true, $fn = 4);
    }
}

/////////////////////////
//// FUNCTIONS///////////
/////////////////////////
function straal(lpm) = 60000 / lpm / PI; 