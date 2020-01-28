// hoekbeschermer voor hout zodat je hoofd niet zo zeer doet als je je stoot
// Ik ga uit van lange schrroven die meteen zorgen voor het
// bevestigen van het hout
//


b = 40;
h = 60;
wall = 1;

metal();

module metalCorner() {
    difference() {
        metal();
        holes();
    }
}

module metal() {
    l = 30;
    b = 12;
    h = 2;
    r = 5;
    
    c = [l - r, b, h];
    translate([r, 0, -r]) {
        corner(r, b, h);
        translate([0, 0, r - h])
            cube(c);
        translate([-r, 0, 0])
            rotate([0, 90, 0])
                cube(c);
    }
}

module corner(r, b, wall) {
    l = max(r,b);
    translate([0, b/2, 0])
    rotate([90, 0, 0])
    difference() {
        cylinder(r = r, h = b, $fn = 30, center = true);
        cylinder(r = r - wall, h = b * 2, $fn = 30, center = true);
        translate([0, -l , -l /2])
            cube([l, l * 2, l] * 1.1);
        translate([-l, -l , -l /2])
            cube([l * 1.1, l , l]);
    }

}

module holes() {
    
}


