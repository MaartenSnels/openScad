/*
bevestiging van lamp aan weggehaalde transport fies
meteen wat veiliger voor bij valpartijden e.d.

*/

use <maarten.scad>

dikte = 3;
steun = [115, dikte, 22];
dHole = 5;
lHoles = 100;  //afstand tussen gaten, symetrisch t.o.v. steun
bevestiging = [28, 20, dikte];
hBevestiging = 26;
dBar = 30;

%steunCompleet();
//scale([1, 1, 1] * 1.1)
//    #steunCompleet();
 
 
//rotate_extrude()
//    translate([dikte * 2 / 2, 0]) square([dikte, hBevestiging], $fn=60);

rotate([0, -90, 0]) 
    halve();

module halve() {
    difference() {
        rotate([0, 90, 0])
            pil();
        scale([1, 1, 1] * 1.1)
        steunCompleet();
        translate([0, -bevestiging.y + dikte,  hBevestiging] / 2)
            cube([bevestiging.x + dikte, bevestiging.y, 10], center = true);
    }
}


module pil(d = dBar, fn = 60) {
    pos = [0, 0, lHoles / 2];
    posNut = pos + [0, -dBar / 4, 0];
    posHead = pos + [0, dBar * 5 / 4, 0];
    difference() {
        union() {
            cylinder(d = d, h = steun.x / 2, $fn = fn);
            up(steun.x / 2)
                scale([1, 1, 1.5])
                    sphere(d =d, $fn = fn);
        }
        hole(d = dHole + 1, h = dBar + 2, pos = pos);
        #hole(d = dHole * 2, h = dBar, pos = posNut, fn = 6, center = false);
        #hole(d = dHole * 2, h = dBar, pos = posHead, fn = 60, center = false);
    }
    
}

















////////////// DIT IS DE UITSNEDE UIT HET MODEL
module steunCompleet() {
    steun();
    bevestiging();
}

module steun() {
    pos = [lHoles / 2, 0, 0];
    difference() {
        cube(steun, center = true);
        //hole(dHole, pos = pos);
        //hole(dHole, pos = -pos);
    }
}
module bevestiging() {
    h=hBevestiging / 2;
    translate([0, -bevestiging.y + dikte, hBevestiging] / 2)
        cube(bevestiging, center = true);
    up(h / 2)
        cube([bevestiging.x, dikte, h], center = true);
    
} 

module hole(d=10, h = 10, pos = [0, 0, 0], fn = 60, center = true) {
    rt(t = pos, r= [90, 0, 0])
        cylinder(d = d, h = h, $fn = fn, center = center);
} 