/*

    bijenbekje die zichzelf vastklemt. Vorige versie had
    wat te weinig speling, hierdoor was het bekje volledig dicht. 
    kan nu uiteraard helemaal geparametriseerd worden

*/

lengte      = 50;   // lengte bijenbekje
breedte     = 16;   // breedte bijenbekje
hoogte      = 1.5;    // hoogte grondplaat bijenbekje

pootje      = 1.5;  // breedte van een pootje 
marge       = 0.1;  // marge tussen twee pootjes (voorkomen schuren)
gap         = 1;    // ruimte tussen de twee bekjes
top         = 30;   // hoogte van de klem
bekBreedte  = 20;

/**
    TODO
    -   bij eerste en laatste steekt nog een stuk uit

**/


grondPlaat();
klem();
module grondPlaat() {
    aantal = ceil(lengte / pootje / 2);
    echo(aantal = aantal);
    union() {
        for(i=[0 : aantal]) {
            translate([pootje * 2 * i, 0,  0]) {
                single(first = i==0, last = i == aantal);
            }
        }
    }
}

//!single(last = true);
module single(first = false, last = false) {
    lengtePootje = breedte / 2 - gap / 2;
    sizePoot = [pootje - marge, lengtePootje];
    sizeVerbinding = [pootje * 2+marge, pootje];

    linear_extrude(height = hoogte) {
        translate([marge /2 , 0, 0]) {
            square(sizePoot);
        }
        translate([pootje + marge /2 , lengtePootje + gap, 0]) {
            square(sizePoot);
        }
        translate([-marge / 2, 0, 0]) {
            if (!last) {
                square(sizeVerbinding);
            }
            if (!first) {
                translate([0, breedte - pootje, 0]) {
                    square(sizeVerbinding);
                }
            }
        }
    }
}

//!klem();
module klem() {
    translate([(lengte + bekBreedte) / 2, 0, 0]) {
        rotate([0, -90, 0]) {
            linear_extrude(height = bekBreedte) {
                difference() {
                    klemBasis();
                    //translate([-pootje, 0, 0]) {
                    offset(r = -pootje) {
                        klemBasis();
                    }
                    square([pootje, breedte]);
                }
            }
        }
    }
}
module klemBasis(){
    diameter = breedte / 2;
    top = [top, breedte / 2];
    hull() {
        translate([top.x - diameter / 2   , top.y, 0]) {
            circle(d = diameter, true, $fn=30);
        }
        polygon(points = [[0, 0], [0, breedte], top]);
    }
    
}