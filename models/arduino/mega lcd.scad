include <arduino.scad>

    height = 2;
    minIn = 5;
    inner = 14.5;
    wall = 2;


//Board mockups
    %translate([0, 0, -19])
        arduino(MEGA);


translate([0, 0, -26.7]) {
    union() {
        color("blue")enclosure(MEGA, , heightExtension = 6, mountType = 0);
//        translate([0, 113.6 - 4.25, 13])
//        rotate([0, -90, -90])
//        vastzettenMeter();
    }
//    translate([48, 113.6 - 4.25, 13])
//    rotate([90, 0, 0])
//        cylinder(h=20, d=5, center = true, $fn=60);
    // nu twee uitsnedes
}

%translate([0, 0, 0]) {
    difference() {
        enclosureLid(boardType = MEGA);
        translate([5, 6, -5])
        cube([43, 62, 10]);
    }

}


module vastzettenMeter() {
    outer = inner + wall * 2;
    rotate([90, 90, 180])
        difference() {
            halvePil(outer, minIn);
            halvePil(inner, minIn);
            translate([0, -outer / 2,  -(outer + minIn) / 2])
            cube([outer, outer, outer + minIn] * 2);
        }
    translate([0, 0, -height])
        difference() {
            huls(outer, minIn, height);
            huls(inner, minIn, height);
        }
    
}
module huls(d = 16, h = 5, height = 5) {
    $fn=60;
    linear_extrude(height=height) {
        difference() {
            circle(d=d);
            translate([-d/2, 0, 0])
                square([d, d]);
        }
        translate([-d/2,0,0])
            square([d, h]);
    }
}

module halvePil(d = 16, h = 5) {
    $fn=60;
    difference() {
        union() {
            sphere(d=d, center = true);
            cylinder(d = d, h=h, center = false);
        }
        translate([0, 0, h + d / 2])
        cube ([d, d, d], center = true);
    }
    
}
