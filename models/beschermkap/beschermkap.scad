use <maarten.scad>


dOuter      = 120;
height      = 40;
wallOuter   = 5;
screws      = 5;
dScrew      = 5;
$fn         = 60;
flat        = true;


outerRing();
screws();
translate([0, 0, height]) cap();

module outerRing() {
    ring(d=dOuter, h = height, w = wallOuter);
}

module screws() {
    for(i=[0:screws]) {
        rotate([0, 0, i * 360 / screws])
            translate([dOuter / 2 + wallOuter, 0, 0])
                screw();
    }
}

module screw() {
    d = dScrew;
    h = height;
    difference() {
        driehoek();
        translate([d, 0, wallOuter + height / 2])
            cube([2 * d, 2 * d, height], center = true);
        translate([d, 0, h / 2])
            cylinder(d = d,h = h * 2, center = true);
    }
}

module cap() {
    if (flat) {
        flat();
    } else {
        dome();
    }
}

module flat() {
    for (i=[dOuter : -wallOuter * 8 : 0]) {
        ring(i, wallOuter, wallOuter);
    }
    n = screws * 2;
    w = wallOuter;
    for(i = [0 : n]) {
        rotate([0, 0, i * 360 / n])
            translate([0, -w / 2, 0])
                cube([dOuter / 2 + w, w, w]);
    }
        
}

//!dome();
module dome() {
    
    d = dOuter + 2 * wallOuter;
    dDome = d * 1.5;
    angle = 180 - acos(d/dDome) * 2;
    hDome = heightDome(dDome, angle);
   
    echo(angle, hDome);
   
    difference() {
        union() {
            ring(dOuter , wallOuter, wallOuter);
            n = screws;
            rotate([90, -90, 0])
            for (i=[0 : n])
                rotate([i * 180 / n, 0, 0])
                    arc(dDome - wallOuter * 2, angle);
        }
//        translate([0, 0, hDome - dDome / 2 ])
//        #union() {
//            difference() {
//                cube([dDome, dDome, dDome] * 2 , center = true);
//                sphere(d=dDome );
//            }
//            
//        }
    }
}

module driehoek() {
    d = dScrew * 2;
    w = wallOuter;
    h = height - w;
    t = [dOuter / 2 + wallOuter, 0, 0];
    c = [d, d,w + h]; 
    angle = asin((d + w * 2) / t.x);
    
    points = [
                [0, 0]
              , [d, 0]
              , [d, w]
              , [0, w + h]
    ];
    
    difference() {
    translate(-t)
        rotate([0, 0, -angle / 2])
            rotate_extrude(angle = angle)
                translate(t)
                    polygon(points);
        translate([-c.x / 2, d/2 + w,-c.z / 2])
            cube(c*2);
        translate([-c.x / 2, -(c.y * 2 + d / 2 + w),-c.z / 2])
            cube(c*2);
    }
}


//!arc(100, 90);
module arc(d, angle = 360) {
    w = wallOuter;
    h = heightDome(d, angle);
    translate([-d/2 + h, 0, -w/2])
        rotate([0, 0, -angle/2])
            rotate_extrude(angle = angle) 
                translate([d/2, 0, 0])
                    square([w,w]);
}

function heightDome(d, angle) = d / 2 * (1 - cos(angle  / 2)); 