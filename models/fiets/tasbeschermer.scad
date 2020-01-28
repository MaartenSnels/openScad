

blok = [30, 23, 31]; // diepte, breedte, hoogte  
dikte = 4;           // dikte van de wanden
afstand = 65;        // afstand tussen de twee blokken (lege ruimte
maxKromming = 20;     // middelste stuk naar achter
schoefGat = 6;

buitenBlok = blok + [dikte / 2, dikte, dikte] * 2;
verbinding = [maxKromming * 2, buitenBlok.y * 2 + afstand, buitenBlok.z];

blok();
translate([0, buitenBlok.y + afstand, 0])
blok();
verbinding();


module verbinding() {
    dIn  = afstand  * 1.1;
    dOut = afstand * 2.2;
    translate([-verbinding.x, 0, 0])
    difference() {
        cube(verbinding);
        translate([dIn / 2 + maxKromming, verbinding.y / 2, 0])
        #cylinder(d = dIn, h=verbinding.z, $fn = 60);
        #difference() {
            cube([verbinding.y, verbinding.y, verbinding.z]);
            translate([dOut / 2, verbinding.y / 2, 0])
                cylinder(d=dOut, h=verbinding.z, $fn=60);
        }
    }
}

module blok() {
    difference() {
        cube(buitenBlok);
        translate([dikte, dikte, dikte])
        cube(blok);
        schroefGat();
    }
}

module schroefGat() {
    translate([buitenBlok.x, buitenBlok.y] / 2)
    linear_extrude(height=dikte, scale= .5)
    circle(d=schoefGat, $fn=60);
}