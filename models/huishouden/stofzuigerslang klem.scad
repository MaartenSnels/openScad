/*
    ronde buisklem waarmee een buis vanst gezet kan worden
    in dit geval de borstelhouder van de stofziuger.
    voor het vastzetten moet je een tieRip gebruiken
*/

$fn = 120;          // in hoeveel segmenten wordt een circel tetekend

dIn = 40;           // binnendiameter van de ring
wall = 2;           // dikte van de ring
height = 17;        // hoogte van de ring
gapAngle = 20;      // openingshoek van de ring

cutOut = 6;         // opening aan de achterkant waar de tierip in past

hubbHeight = 12;    // hoogte van nub aan binnenkant, excl. bolling
hubbWidth = 4;      // breedte van nub, tevens diameter van afronding
hubbThickness = 3;  // hoever steekt nub uit
bubbAngle = 55;     //TODO hoek nog niet goed,

tieRip = 6;         // breedte van tieRip
tieRipHeight = 2;   // dikte van tieRip


fixIt();

module fixIt() {
    union() {
        difference() {
            rotate([0, 0, gapAngle / 2])
            hollewBand();
            translate(-[(dIn) / 2 + wall * 3, 0, 0])
            cube([wall * 4, cutOut,height * 2], center = true);
            tieRip();
        }
        rotate([0, 0, 180 + bubbAngle]) 
        translate([dIn / 2 - hubbThickness + .5, 0, 0])
        hubb();
        rotate([0, 0, 180 - bubbAngle]) 
        translate([dIn / 2 - hubbThickness + .5, 0, 0])
        hubb();
    }
}

module hubb() {
    translate([0, 0, hubbHeight / 2])
    rotate(([0, 90, 0]))
    linear_extrude(height = hubbThickness)
    hull() {
        circle(d=hubbWidth, center = true);
        translate([hubbHeight, 0, 0])
        circle(d=hubbWidth, center = true);
    }
}

//!hollewBand();
module hollewBand() {
    d=tieRipHeight * 4;
    l = tieRip + d * 2;
    
    rotate_extrude(angle = 360 - gapAngle) {
       translate([dIn/2 + wall, 0, 0])
        rotate([0, 0, 90])
        union() {
            difference() {
                hull() {
                    translate([-l / 2 + d, 0, 0])
                    circle(d=d, center = true);
                    translate([l / 2 - d, 0, 0])
                    circle(d=d, center = true);
                }
                translate ([-l, 0, 0])
                square([l*3, d]);
                //square([tieRip, tieRipHeight * 2], center=true);
            }
            translate (-[height/2, 0, 0])
            square([height, wall]);
        }
    }
}

module tieRip() {
    inSide  = dIn + wall * 2;
    outSide = dIn + (wall  + tieRipHeight) * 2;
    difference() {
        cylinder(d = outSide, h = tieRip, center = true);
        cylinder(d = inSide , h = tieRip, center = true);
    }
 }