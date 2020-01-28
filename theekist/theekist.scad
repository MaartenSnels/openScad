$fn = 60;
wall = 1.5;
theFloor = 1;
floorLength = 30;
height = 62;
width = 65;
middle = true;
rounded = 8;

//T_shape();
//rounded();
roundedEdges();

module roundedEdges() {
    T_shape();
    for(i = [0, 1])
        mirror([i, 0, 0])
            translate([wall / 2, 0, theFloor])
                rounded();
}


module T_shape() {
    translate([0, 0, theFloor / 2])
        cube([floorLength, width, theFloor], center = true);
    translate([0, 0, height / 2])
    cube([wall, width, height], center = true);
}

module rounded() {
    cube = [rounded, rounded, width];
    rotate([90, 0, 0])
        translate([cube.x, cube.y, 0] / 2)
        difference() {
            cube(cube, center = true);
            cylinder(d = rounded, h = width * 2, center = true);
            translate([0, -cube.y, -cube.z])
                cube(cube * 2); 
            translate([-cube.x, 0, -cube.z])
                cube(cube * 2); 
        }
}

