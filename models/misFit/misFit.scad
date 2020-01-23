

d = 27.5;       // outer diameter of misfit
dS = 2;         // small diameter (inner ORing)
dL = 5.0;       // large diameter (outer ORing)
angleCut = 3;   // opening to allaw palstic to open and close around object
$fn = 120;      // how acurarate are round objects drawn
h = 4.0;        // overall height of beezle


ring();

module ring() {
    c = [d, d, dL] * 2;
    t = [0, 0, (c.z + h) / 2];
    difference() {
        union() {
            halfORing(D=dL, cut = true);
            oRing(D=dS, cut = true);
        }
        if (h < dL) {
            translate(t)
                cube(c, center = true);
            translate(-t)
                cube(c, center = true);
        }
    }
}

module oRing(d=d, D=2, cut=true) {
    angle = cut ? 360 - angleCut : 360;
    rotate([0, 0, angleCut / 2])
    rotate_extrude(angle = angle) {
        translate([d / 2, 0, 0])
            circle(d=D);
    }

}
 
module halfORing(d=d, D=2, cut = true) {
    difference() {
        oRing(d, D, cut);
        cylinder(d=d, h=d*2, center = true);
    }
}

