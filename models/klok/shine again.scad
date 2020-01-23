
use <maarten.scad>

hRing  = 30;
vrijeRuimte = 7;
hStrip = 11;
lStrip    = 10;
dStrip    = 1.5;
giude     = 2;
wall      = 2;
pi          = 3.1415;

lpmBinnen = 144;
lpmBuiten = 60;


singleStrip(100);

//ledRing(lpmBinnen, true);
//ledRing(lpmBuiten, false);
//fill();

module singleStrip(h) {
    linear_extrude(height=h) stripGuide2D(reflector=true); 
}

module fill() {
    up(hStrip / 2 )
        ring(d = straal(lpmBinnen)*2
           , w = straal(lpmBuiten) - straal(lpmBinnen)
           , h = wall);
}

module ledRing(ledsPerMeter = 60, binnen = true) {
    rotate_extrude($fn=60)
        translate([straal(ledsPerMeter), 0, 0])
            rotate([0, 0, 90])
                stripGuide2D(binnen = binnen, reflector = true);
}

module stripGuide2D(binnen = false, refelctor = false) {
    bovenrand = true;
    mirror([0, binnen ? -1 : 0, 0]) {
        difference() {
            union() {
                difference() {
                    square([hStrip + 2* wall, dStrip + 2 * wall], center = true);
                    square([hStrip          , dStrip           ], center = true);
                    translate([0, wall, 0])
                        square([hStrip - 2 * giude, dStrip + wall], center = true);
                }
                if (reflector) {
                    translate([hStrip/2, 0, 0])
                        square([wall, vrijeRuimte]);
                    translate([hStrip / 2 - hRing + wall,vrijeRuimte, 0])
                        square([hRing, wall]);
                }
            }
            if (!bovenrand) {
                translate([-hStrip / 2, dStrip / 2.1, 0]) 
                    square([hStrip - giude * 2, wall*1.1]); 
            }
        }
    }

}

function straal(ledsPerMeter) = 60 / ledsPerMeter * 1000 / 2 / pi;