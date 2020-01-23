

dOuter = 25;
wall = 1;
dInner = 19;
dGrooves = 17;
hInner = 6;
hOuter = 1;
hHook = 20;
hook = 5;
hTieRip = 1.8;
bTieRip = 5.5;
$fn = 90;

////// BRERKENDE WAARDES ///////////////
dTotaal = dOuter + wall * 2;
hBase = hInner + wall;

/////// RENDER //////////////////////

rotate([0, 180, 0])
    haak();

module haak() {
    base();
    translate([0, 0, hBase])
        hookBase();
    translate([0, 0, hBase + hHook - hook])
        hook();
}

module base() {
    translate([0, 0, hInner])
        cylinder(d=dTotaal, h = wall);
    difference() {
        cylinder(d=dInner, h=hInner);
        translate([dGrooves / 2, -dInner / 2, -wall])
            cube([dInner, dInner, hInner + wall]);
        translate([-dInner - dGrooves / 2, -dInner / 2, -wall])
            cube([dInner, dInner, hInner + wall]);
    }
    translate([0, 0, hInner - hOuter])
        difference() {
            cylinder(d=dTotaal, h = hOuter);
            translate([0, 0, - hOuter])
            cylinder(d=dOuter, h = hOuter * 2);
        }
}

module hookBase() {
    shift = dTotaal / 4;
    up = hHook  - hook;
    difference() {
        cylinder(d = dTotaal, h = up);
        translate([0, shift, 0])
            tieRip();
        translate([0, -shift, 0])
            tieRip();
    }
}


module tieRip() {
    translate([0, 0, hTieRip] / 2)
    cube([dTotaal * 2, bTieRip, hTieRip], center = true);
}

module hook() {

    minkowski() {
        linear_extrude(height=wall)
        hull() {
            circle(d=dTotaal);
            translate([0, 50, 0])
                circle(d=dTotaal / 3);
        }
        sphere(d=hook);
    }
}
//difference() {
//    cylinder(d=dOuter + wall * 2, h = hInner + wall);
//    difference() {
//        cylinder(d=dOuter, h = hInner);
//        cylinder(d = dInner, h = hInner);
//    }
//}