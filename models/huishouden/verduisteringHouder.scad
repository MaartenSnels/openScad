use <rcube.scad>


clipDiameter = 15;   // inner diameter of tube you want to hold
clipWidth    = 12;   // width of the clip
clipSpacing  = 50;   // distance between two clips
clipCount    = 2;    // number of clips
wall         = 3;    // thickness of the wall
angle        = 140;  // openingsangle of clip 0 = no opening 360 = no clip
screwHoles   = true; // holes to fasten clip to wall (i prefere tape)
$fn=100;




    clip();


module clip(clips = clipCount) {
    length = clipSpacing * (clips - 1) + clipWidth;
    width  = clipDiameter + 2 * wall;
    echo(length=length, width=width);
    
    difference() {
        union() {
            frcube([width, length, wall], center = false);
            for(i=[0:clips-1]) {
                translate([0, clipSpacing * i, wall])
                openCylinder();
            }
        }
        for(i=[0:clips-1]) {
            translate([width / 2, clipSpacing * i + clipWidth / 2, wall/2])
            if (screwHoles)
                screwHole();
        }
    }
}

module screwHole() {

    d=3; // screw hole diameter
    union() {
        linear_extrude(height=wall, scale = 2)
        circle(d=d, center=true, $fn=60);
        translate([0, 0, -clipDiameter / 2 + wall])
        cylinder(d=d, center=true, h = clipDiameter);
        translate([0, 0, clipDiameter / 2 + wall])
        cylinder(d=2*d, center=true, h = clipDiameter);
    }
}



module openCylinder() {
    D = clipDiameter + wall * 2;
    
    translate([D, clipWidth, D] / 2)
    rotate([0, -90, 90])
    union() {
        
        rotate([0, 0, angle / 2])
        translate([0, 0, -clipWidth / 2])
        rotate_extrude(angle = 360 - angle, center=true)
        translate([clipDiameter/2, 0, 0] )
        square([wall, clipWidth]);


        rotate([0, 0, angle / 2])
        translate([(clipDiameter + wall) / 2, 0, 0])
        cylinder(d = wall, h = clipWidth, center=true);
        rotate([0, 0, -angle / 2])
        translate([(clipDiameter + wall) / 2, 0, 0])
        cylinder(d = wall, h = clipWidth, center=true);
        block();  
    }
}

module block() {
    angle = acos((clipDiameter / 2) / (clipDiameter / 2 + wall));
    w = sin(angle) * (clipDiameter /2 + wall) * 2;
    
    translate([-(clipDiameter + wall)/2, 0, 0])
    rotate([90, 0, 90])
    cube([w, clipWidth, wall], true);
}

module cutOut() {
    
    D = clipDiameter + wall * 2;
    x = D / 2 * sin((180 - angle) / 2);
    y = abs(D / 2 * (cos((180-angle)/2)));
    points = [ [ 0,  0]
             , [ x,  y]
             , [ D,  y]
             , [ D, -y]
             , [ x, -y] ];
    
    translate([0, 0, -clipWidth])
    linear_extrude(clipWidth * 2)
    polygon(points);
}