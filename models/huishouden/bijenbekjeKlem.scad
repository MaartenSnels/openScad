/*

    bijenbekje die zichzelf vastklemt. Vorige versie had
    wat te weinig speling, hierdoor was het bekje volledig dicht. 
    kan nu uiteraard helemaal geparametriseerd worden

*/

l           = 70;    // lengte bijenbekje
breedte     = 25;    // breedte bijenbekje
spouw       = 20;    // hoe breedt is de spouw
hoogte      = 2;     // hoogte grondplaat bijenbekje

pootje      = 2;     // breedte van een pootje 
marge       = 0.2;   // marge tussen twee pootjes (voorkomen schuren)
top         = 30;    // hoogte van de klem
bekBreedte  = 20;    // breedte van de klem
diameter    = 4;     // diamter van verbindingsgat
enkel       = false; // een exemplaar of meerdere
aantalX     = 3;     // in combinatie met NOT enkel
aantalY     = 7;     // in combinatie met NOT enkel
print       = "plaat";  // "preview, plaat, klem , all"
                       // werkt in combinaie met NOT enkel alleen
                       // met plaat en klem en all

///////////berekende waarden
diameterKlem = spouw / 2; // bonvenste afronding van de klem
aantalGaten = ceil((l - pootje) / (pootje * 2)); // aantal gaten in grondplaat
lengte = aantalGaten *pootje * 2 + pootje;  // actuele lengte van klem
hoek = atan(((spouw - diameterKlem)/ 2) / 
            (top - diameterKlem / 2));  // hoek die klem maakt


/**
    TODO
    -   maak lengte leidend, niet l
    -   variabelenamen aanpassen
    -   

**/

echo(lengte = lengte);
if (enkel) {
    print();
} else {
    aantal(aantalX, aantalY);
}

module aantal(x = 3, y = 7) {
    for(i=[0:x - 1]) {
        for(j=[0:y - 1]) {
                if (print == "plaat") {
                    translate([(lengte + hoogte) * i
                             , (breedte + hoogte) * j
                             , 0])
                        grondPlaat();
                } else if (print == "klem") {
                    translate([(top + hoogte) * i
                             , (spouw + hoogte) * j
                             , 0])
                        printKlem();
                } else if (print == "all") {
                    translate([(top + lengte + hoogte) * i
                             , (breedte + hoogte) * j
                             , 0])
                        all();
                }
        }
    }
}

module print() {
    
    if (print == "all") {
        all();
    } else if (print == "plaat") {
        grondPlaat();
    } else if (print == "klem") {
        printKlem();
    } else { // asume preview
        translate([-l/2, - breedte / 2, 0]) 
        grondPlaat();
        translate([0, 0, hoogte + 0.1]) klemUitsparing();
    } 
}

module all() {
    translate([top + hoogte, 0, 0])
        grondPlaat();
    translate([0, breedte / 2, bekBreedte  / 2])
        rotate([0, 90 , 0])
                klemUitsparing();
}

module printKlem() {
    translate([0, 0, bekBreedte / 2])
        rotate([0, 90 , 0])
            klemUitsparing();
}

module grondPlaat() {
    gat = [pootje, breedte - 2 * pootje,  2 * hoogte];
    m1 = (lengte - bekBreedte) / 2 + diameter;
    m2 = (lengte + bekBreedte) / 2 - diameter;
    function t(i) = [  (i * 2 + 1) * pootje
                     , pootje
                     , -hoogte / 2];
    union() {
        difference() {
            cube([lengte, breedte, hoogte]);
            for(i = [0 : aantalGaten - 1]) {
                translate(t(i)) {
                    cube(gat);
                }
            }
        }
        verbinding();
        translate([m1, breedte / 2, 0]) male();
        translate([m2, breedte / 2, 0]) male();
    }
}

module male() {
    cylinder(  d = diameter - marge
             , h = hoogte * 3
             , $fn=30);
}

module verbinding() {
    verbindingBreedte = breedte / 3;
    shift = [  (lengte - bekBreedte) / 2
             , (breedte - verbindingBreedte) / 2
             , 0];
    translate(shift) {
        cube([bekBreedte, verbindingBreedte, hoogte]);
    }
}

//!klemUitsparing();
module klemUitsparing() {
    shift = bekBreedte / 2 - diameter;
    difference() {
        klem();
        translate([-shift, 0, 0])
            cylinder(d=diameter, h = top , $fn=30, center = true);
        translate([shift, 0, 0])
            cylinder(d=diameter, h = top, $fn=30, center = true);
    }
}


module klem() {
    translate([-bekBreedte / 2, -spouw / 2, top]) {
        rotate([0, 90, 0]) {
            linear_extrude(height = bekBreedte) {
                klem2d();
            }
        }
    }
}

//!klem();
module klem2d() {
    sizeSchuurplaat = [spouw / 2, pootje];
    grondplaatBreedte = spouw / 3;
    grondplaatTrans = [top - pootje
                     , (spouw - grondplaatBreedte) / 2];
    difference() {
        klemBasis();
        offset(r = -pootje) {
            klemBasis();
        }
        uitsparing();
    }
    translate(grondplaatTrans) {
        square([pootje, grondplaatBreedte]);
    }
    square(sizeSchuurplaat);
    translate([0, spouw - pootje])
        square(sizeSchuurplaat);
}

//!uitsparing();
module uitsparing() {
    echo(hoek=hoek);
    delta = pootje * sin(hoek) / cos(hoek);
    echo (delta = delta);
    p0 = [0, pootje];
    p1 = [pootje, pootje + delta];
    p2 = [pootje, spouw - pootje - delta];
    p3 = [0, spouw - pootje];
    polygon(points = [p0, p1, p2, p3]);
    //square([pootje, breedte]);
}
//!klemBasis();
module klemBasis(){
    top = [top, diameterKlem];
    hull() {
        translate([top.x - diameterKlem / 2   , top.y]) {
            circle(d = diameterKlem, true, $fn=30);
        }
        polygon(points = [[0, 0], [0, spouw], top]);
    }
    
}