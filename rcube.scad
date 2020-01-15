/*
    rounded cubes
    
    module rcube with parmas 
        shape []    = format of cube
        pos []      = translation of cube
        d           = diameter rounding
        fn          = number of segments default 60
*/

module rcube(shape=[20,20,20], pos=[0,0,0], d=5, fn=60, center=true) {

    translate(pos + (center ? [0,0,0] : ([d, d, d] / 2)))
    minkowski() {
        cube(shape - [d,d,d], center=center);
        sphere(d=d, $fn = fn);
    }
}

/*
    flat rounde cube
*/
module frcube(shape=[20,20,20], pos=[0,0,0], d=5, fn=60, center=true) {

    x = (shape.x - d) / 2;
    y = (shape.y - d) / 2;
    translate(pos + (center ? [0,0,-shape.z / 2] : ([shape.x, shape.y, 0] / 2)))
    linear_extrude(shape.z)
    hull() {
        square([shape.x -d, shape.y - d], center=true);
        for (i=
            [ [ x,  y]
            , [-x,  y]
            , [-x, -y]
            , [ x, -y]]) {
            translate(i)
            circle(d=d, $fn = fn);
        }
    }
}

rcube();
translate([30,0, 0])
frcube();
translate([60,0, 0])
cube([20,20,20], true);


