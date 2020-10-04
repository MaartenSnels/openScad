$fn = 120;

rows = 8;
cols = 32;
outer = [10, 10];
inner = [8.5, 8.5, 2.5];
wall = 1.5;
delta = wall + 1;


height = rows * outer.x + delta * 2;
diameter = outer.x * cols / PI + 3;


echo( "diameter", diameter, "height", height);

echo(outer);

outerRim();
bottom();


module outerRim() {
    translate([0, 0, height] / 2)
    difference() {
        cylinder(d = diameter + inner.z * 2 + wall * 2, center = true, h = height);
        cylinder(d = diameter, center = true, $fn = 120, h = height * 2);
        translate([0, 0, -height / 2])
            leds();
    }    
}


module leds() {
    translate([0, 0, delta * 2 + outer.x] / 2) {
        for(j=[0:rows - 1]) {
            for (i=[0:cols / 2 - 1]) {
                translate([0, 0, j * outer.x])
                    rotate([0, 0, i * 360 / cols])
                        cube([inner.x, diameter + 2 * inner.z, inner.y], center = true);
            }
        }
    }
}


module bottom() {
    cylinder(d = diameter, h = wall, center = false);
}