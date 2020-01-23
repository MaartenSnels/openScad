


/*
    ophangen van hondenrekje
    
*/

tussen = 30;
hoogte = 20;
draad = 10;
hangDraad = 5.5;
aantal = 6;
wall = 2;
naam = "Dexter";
$fn = 60;

rotate([0, -90, 0])
haken();

module haken() {
    for(i=[0:aantal - 1]) {
        translate([0, tussen * i, 0]) haak();
    } 
}

module haak() {
    d = hangDraad + 2 * wall;
    h = tussen - draad;    
    difference() {
        union() {
            rotate([-90, 0, 0])
                cylinder(d = d, h = h);
            translate([-d / 2, 0, 0]) 
                cube([d, h, d]);
            translate([-d / 2, -draad / 2, 0])
                cube([wall, tussen, hoogte]); 
        }
        translate([wall - d / 2 , -draad / 2, 0])
            cube([hangDraad, tussen * 1.1, d * 1.1]); 
        translate([0, -draad / 2, 0])
            rotate([-90, 0, 0])
                cylinder(d = hangDraad, h = tussen);
    }
}
