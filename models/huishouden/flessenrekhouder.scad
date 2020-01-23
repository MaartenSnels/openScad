/*
    flessenhouder voor in de koelkast. Flessenhouder is er al, er moet alleen een 
    verhogingkje komen van 2 cm
*/

include <reinforce.scad>

diepte = 115;  // hart op hart afstand van flessenrek
draad  = 5;     // doorsnede van de draad
verhoging = 20; // goe schuin moet i staan
breedte = 15;
rekBreedte = 190;

// berekend
hoek = asin(verhoging / diepte);
lengte = cos(hoek) * diepte;
echo(lengte=lengte, hoek=hoek);

//////  RENDER ////////
poten();
poten(rekBreedte);
verbinding();

module verbinding() {
    d = [lengte + draad * 3, rekBreedte + breedte, draad] / 2;
    punten = [
                [0,   0,   0]
              , [d.x, 0,   0]
              , [0,   d.y, 0]
              , [d.x, d.y, 0]
             ];
    
    for (i=punten) {
        translate(i)
        reinforceX(d=d, width=draad / 2);
    }
    
}

module poten(shiftLeft=0) {
    translate([0, shiftLeft, 0]) {
        poot(0);
        translate([lengte, 0, 0]) poot(verhoging);
    }
}

module poot(h=5) {
    difference() {
        cube([draad * 3, breedte, h + draad * 2]);
        translate([draad * 1.5, 0, h + draad])
        rotate([0, -hoek, 0])
        #cutOut();
    }
}

module cutOut() {
        union() {
            translate([-draad / 2, -breedte / 2, 0])
            cube([draad, breedte * 2, draad * 2]);
            translate([0, breedte / 2, 0])
            rotate([90, 0, 0])
            cylinder(d = draad, h = breedte * 2, $fn=60, center = true);
        }
}




