/*

    afdakplaatje voor deksel in plafond centraaldoos met haak
    http://www.abbconnect.nl/pdf/product.aspx?ordercode=7161.160
    
    te bevestingen met tiewrap

*/


use <maarten.scad>

dCap        = 85;     // inner diameter of the cap
hCap        = 30;     // innen height of the cap
holes       = 2;      // number of holes
wall        = 2;      // thickness of the wall
bTiewrap    = 7;      // width of tiewrap hole
hTiewrap    = wall;   // thickness of tiewrap hole
fn          = 60;     // how fine is art the circles printed


////// render ////////////////////
rt(r=[180, 0, 0], t=[0, 0, hCap + wall])
    cap();
    
////////// modules ////////////////////
module cap() {
    up (hCap) top();
    difference() {
        ring(d = dCap, h = hCap, fn = fn, w = wall);
        holes();
    }
}

module top() {
    difference() {
        union() {
            cylinder(r = dCap / 2 + wall, h = wall, $fn = fn);
            tieWrapReinforcement();
        }
        tieWrapHoles();
    }
}

module tieWrapReinforcement() {
    size = [bTiewrap, dCap, hTiewrap] * 2;
    up(-wall) {
        intersection() {
            union() {
                cube(size, center = true);
                rotate([0,0,90])
                    cube(size, center = true);
            }
            cylinder(d = dCap, h = hCap, center = true, $fn = fn); 
        }
    }
}

module tieWrapHoles() {
    tie = [hTiewrap, bTiewrap, hTiewrap * 5];
    t = [bTiewrap / 2, 0, 0];
    translate(t)
        cube(tie, center = true);
    translate(-t)
        cube(tie, center = true);
    up(wall / 2)
        cube([bTiewrap, bTiewrap, wall * 1.1], center = true);
}

module holes() {
    for(i=[0:holes - 1]) {
        tr(r=[0, 0, 360 / holes * i], t = [0, dCap / 2, 0])
            hole();
    }
}

module hole() {
    d = 5;
    up(d)
        rotate([90, 0, 0])
            cylinder(d = d, center = true, h = wall * 3, $fn = fn);
    up((d - wall) / 2)
        cube([d, wall * 3, d + wall], center = true);
}

