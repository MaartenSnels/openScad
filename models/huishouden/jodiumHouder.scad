use <maarten.scad>

width    = 112; // with of jodum medication box
depth    = 31;  // depth of jodium dedication box
height   = 60;   // height of the holder
wall     = 2.5;    // wall thickness
backOut  = 70;
frontOut = 90;
dScrew   = 4;
$fn      = 60;

////////////// calculated ////////////////////
box = [width + wall * 2, depth + wall * 2, height];

///////////////// render /////////////////////
theBox();

//////////// modules ////////////////////// 
module theBox() {
    difference() {
        box(size = box, w = wall, bottom = true);
        cutOut(d = frontOut, front = true);
        cutOut(d = backOut, front = false);
        screwHoles();
    }
}

module screwHoles() {
    shift = dScrew * 2;
    translate([(box.x + backOut) / 2 + shift, 0, box.z - shift])
        screw();
    translate([(box.x - backOut) / 2 - shift, 0, box.z - shift])
        screw();
}

module screw() {
    rotate([90, 0, 180])
        screwHole (  dScrew = dScrew
                    , dHead = dScrew * 2
                    , hScrew = wall
                    , hHead = wall);
}

module cutOut(d=10, front = true) {
    up = 15;
    x = box.x / 2;
    y = front ? box.y : 0;
    z = d / 2 + up;
    rt(t=[x, y, z], r=[90, 0, 0])
        cylinder(d=d, h = wall * 3, center = true);
    translate([x - d/2, y - wall * 3 / 2, z])
        cube([d, wall * 3, box.z]);
}