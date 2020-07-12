$fn = 60;           // nauwkeurigheid van het tekenen van cirkels
wall = 3;           // dikte van de wand
dBuis = 120;        // doorsnede van de invoer buis
dOutlet = 53;       // dikte van de outlet
h1 = 40;            // hoogte van breede gedeelte toeter
h2 = 50;            // hoogte van smalle gedeelte toeter   
radius = 40;        // hoek die outlet moet maken rond kozijn
klemrand = 25;      // rand om slang in vast te klemmen



/////////// BEREKENDE WAARDEN ////////////////////
lOutlet = opp(dBuis) / dOutlet;
hoogte = klemrand + h1 + h2;
echo("breedte de buis", lOutlet + wall * 2);
echo("totale hoogte is", hoogte);

///////////// controleer de boel (een beetje) ///////////////////////////
assert(hoogte < 200, "maximale print hoogte is 20 cm");
echo("breedte van de duct", lOutlet + wall * 2);
assert(lOutlet + wall * 2 < 220, "maximale print breedte is 22 cm");
echo("raamopening is",  + dOutlet + wall * 2);
assert(dOutlet + wall * 2 < 60, "maximale raamopening is 6 cm");


translate([0, 0, h1 + klemrand]) {
    rotate([180, 0, 0]) {
        hollowToeter(dBuis = dBuis, h1 = h1, h2 = h2, dOutlet = dOutlet, lOutlet = lOutlet, klemrand = klemrand);
    }
}
//translate([0, 0, hoogte]) {
//    rotate([180, 0, 0]) {
//        versteviging();
//    }
//}


module versteviging() {
    intersection() {
        translate([0, 0, hoogte / 2 - klemrand]) {
            union() {
//                cube([wall, lOutlet, hoogte], center = true);
//                translate([dBuis - dOutlet, 0, 0] / 2)
//                    cube([wall, lOutlet, hoogte], center = true);
                cube([dBuis, wall, hoogte], center = true);
            }
        }
        translate([0, 0, h2]) {
            toeter( // binnen
                  dBuis = dBuis
                , h1 = h1 
                , h2 = h2
                , dOutlet = dOutlet
                , lOutlet = lOutlet
                , klemrand = klemrand);
        }
    }
}


module randje() {
    rotate([-90, 0, 0])
        linear_extrude(wall) {
            difference() {
                offset(r = 10) {
                    doorsnede();
                }
                doorsnede();
            }
        }
}

module doorsnede() {
    projection() {
        rotate([90, 0, 0]) {
            hollowToeter(dBuis = dBuis, h1 = h1, h2 = h2, dOutlet = dOutlet, lOutlet = lOutlet);
        }
    }

}



module hollowBocht(dBuis = 120, dOutlet = 40, radius = 40) {
    difference() {
        bocht(dBuis = dBuis, dOutlet = dOutlet, angle = 90, radius = radius);
        bocht(dBuis = dBuis - wall * 2, dOutlet = dOutlet - wall * 2, angle = 360, radius = radius + wall);
    }
}


module bocht(dBuis = 120, dOutlet = 40, angle = 90, radius = 40) {
    rotate_extrude(angle = angle, convexity = 20) {
        translate([dOutlet / 2 + radius, 0, 0]) {
            outletPlat(d = dBuis, b = dOutlet);
        }
    }
}

module hollowToeter(dBuis = 120, h1 = 50, h2 = 50, dOutlet = 40, lOutlet = 120, klemrand = 10) {
    difference() {
        toeter( // buiten
              dBuis = dBuis + wall * 2
            , h1 = h1
            , h2 = h2
            , dOutlet = dOutlet + 2 * wall
            , lOutlet = lOutlet + 2 * wall
            , klemrand = klemrand
        );
        toeter( // binnen
              dBuis = dBuis
            , h1 = h1 
            , h2 = h2 + wall
            , dOutlet = dOutlet
            , lOutlet = lOutlet
            , klemrand = klemrand + wall);
    }
}


module toeter(dBuis = 120, h1 = 50, h2 = 50, dOutlet = 40, lOutlet = 120, klemrand = 10) {
    translate = (dBuis - dOutlet) / 2;
    hull() {
        translate([translate, 0, 0]) { 
            outlet(lOutlet = lOutlet, dOutlet = dOutlet);
        }
        translate([0, 0, h1])
        cylinder (d = dBuis);
    }
    translate([translate, 0, -h2]) {
        outlet(lOutlet = lOutlet, dOutlet = dOutlet, h = h2);
    }
    translate([0, 0, h1]) {
        cylinder(d = dBuis, h = klemrand, center = false);
    }
}

module outlet(lOutlet = 120, dOutlet = 40, h = 1) {
    linear_extrude(height = h) {
        outletPlat(lOutlet = lOutlet, dOutlet = dOutlet);
    }
}

module outletPlat(lOutlet = 120, dOutlet = 40) {
    translate = (lOutlet - dOutlet) / 2;
    rotate([0, 0, 90]) {
        for(i = [-1,1]) {
            translate([translate * i, 0, 0]) {
                circle(d = dOutlet);
            }
        }
        translate([translate, dOutlet / 2, 0] * -1) {
            square([translate * 2, dOutlet]);
        }
    }

}


function opp(d = 10) = PI * d * d / 4;