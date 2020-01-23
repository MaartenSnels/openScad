
bezelDepth = 20;
bezelHeight = 30;
width = 50;
angle = 90;
wall = 3;

wig = true;

outer = [  bezelDepth + wall * 2
         , width
         , bezelHeight + wall];
         
inner = [  bezelDepth
         , width
         , bezelHeight];
b = max(outer.x, outer.y, outer.z);
big = [b, b, b];
         
uShapeAngle();
mirror([0, -1, 0]) uShapeAngle();

module uShapeAngle() {
    difference() {
        rotate([0, 0, angle / 2]) 
        translate([-wall, 0, 0])  {
            uShape();
            translate([0, -outer.y, 0])
                if (wig) {
                    cube(outer);
                } else {
                    uShape();
                }
        }
        translate([0, -big.y, 0])
            cube(big * 2, center = true);
    }
}

module uShape() {
    difference() {
        cube(outer);
        translate([wall, 0, wall])
            cube(inner);
    }
}