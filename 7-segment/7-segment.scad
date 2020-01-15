

segment = [20, 55, 15];

 cijfer();;
//less(segment);

module cijfer() {
   margin = 2.5;
   segment(segment);
   translate([segment.y + margin, 0, 0]) segment(segment);
   translate([segment.y + margin, segment.y + margin, 0]) segment(segment);
   translate([0, segment.y + margin, 0]) segment(segment); 
   translate ([segment.y + margin, segment.y + margin, 0] / 2) rotate([0, 0, 90]) segment(segment);
   translate ([segment.y + margin, -segment.y - margin, 0] / 2) rotate([0, 0, 90]) segment(segment);
   translate ([segment.y + margin, (segment.y + margin) * 3, 0] / 2) rotate([0, 0, 90]) segment(segment);
}


module segment(cube = [10, 30, 10], center = true) {

    
    x = cube.x / cos(45) / 2;
    hull() {
//        less(cube - [10, 10, 0]);
        for(i = [-1, 1])
            translate([0, cube.y - sqrt(2) * x, 0] / 2 * i)
                rotate([0, 0, 45])
                    less ([x, x, cube.z]);
    }
}

module less(cube = [10, 10, 10]) {
    kant(cube);
    mirror([-1, 0,  0]) kant(cube);
    mirror([ 0, 0, -1]) kant(cube);
    rotate([ 0, 180, 0]) kant(cube);
    mirror([0, 1, 0]) kant(cube);
    mirror([-1, 0, 0]) mirror([0, -1, -0]) kant(cube);
    mirror([0, 0, -1]) mirror([0, -1, -0]) kant(cube);
    rotate([0, 180, 0]) mirror([0, -1, -0]) kant(cube);
}


module kant(cube = [10, 30, 20], hoek = 45) {
    marge = 1;
    mirror([1,0,0])
    translate([0, -cube.y / 2, 0])
        difference() {
            cube([cube.x, cube.y, cube.z] / 2, center = false);
            translate([ -cube.x / cos(hoek) / 4 + cube.x / 2 - marge,
                         0,
                         cube.x / sin(hoek) / 4 + cube.z / 2 - marge])
                rotate([0, hoek, 0])
                    cube(cube, center = false);
            translate([ 0, 
                        -cube.z / cos(hoek) / 4  + marge,
                       -cube.z / sin(hoek) / 4  + cube.z / 2 - marge])
                rotate([hoek, 0, 0])
                    translate([-1, 0, 0])
                        cube(cube + [2, 0, 0], center = false);

        }
}