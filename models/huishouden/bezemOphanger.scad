/*
    broom hanger
*/

dStick       = 30;  // diameter of the stick
lengthBeam   = 50;  // from back of broom to end of hanger
fromWall     = 20;  // minimal distance from wall
wall         = 10;  // thickness of the wall
upperAngle   = 10;  // angle of upper beam
lowerAngle   = 45;  // angle of lower beam
$fn          = 100; // how fine will the print be 
clearance    = 3;   // minimal distance between screwhole and walls
dHole        = 4;   // diameter of screwhole
dAccess      = 12;  // diameter of the access hole to the screw hole

openBeams = true;

//////////// calculated
yUpper = dY(l = lengthBeam, angle = upperAngle); 
yLower = dY(l = lengthBeam, angle = lowerAngle); 
h = abs(yUpper - yLower);

////////// RENDER //////////////////
    hanger();

module hanger() {
    union() {
        translate([fromWall + wall / 2, 0, 0])
            leg();
        translate([fromWall + wall / 2, dStick + wall, 0]) 
            leg();
        block();
    }
}

module block() {
    c = [fromWall + dStick / 2, dStick + wall,  h];
    difference() {
        union() {
            cube(c);
            corners();
        }
        translate([0, c.y / 2, 0])
            holes();
        translate([c.x, c.y / 2, 0])
                cylinder(d=dStick, h = h * 3, center = true);
        translate([fromWall + wall, -c.y / 2, -c.z / 2])
            cube(c * 2);
    }
}

module holes() {
    translate([0, 0, clearance + dAccess / 2])
        hole();
    translate([0, 0, h - clearance - dAccess / 2])
        hole();
    // add cube to connect the outside of the holes!
    translate([clearance + dHole,  -dAccess / 2, clearance + dAccess / 2])
        cube([fromWall, dAccess, h - clearance * 2 - dAccess]);
}

module hole() {
    tr(t = [0, 0, clearance + dHole], r = [0, 90, 0]) 
        {
            cylinder(d = dAccess, h = fromWall );
            translate([0, 0, -fromWall])
                cylinder(d = dHole, h = fromWall );
            rotate([180, 0, 0]) 
                linear_extrude(height = dHole, scale = dHole / dAccess)
                    circle(d = dAccess);
        }
}

module corners() {
    translate([fromWall - wall / 2, -wall / 2, 0])
        corner(left = false);
    translate([fromWall - wall / 2, dStick + wall, 0]) 
        corner(left = true);
}

module corner(left = true) {
    c = [wall / 2, wall / 2, h];
    t = [0, left ? 0 : wall / 2, 0];
    m = [0, left ? 0 : 1       , 0];
    translate(t)
        mirror(m)
            difference() {
                cube(c);
                rt(r = [0, 0, 45], t = [0, 0, -h / 2]) cube(c * 2);
            }
}

module leg() {
    rt(t = [0, 0, h], r = [90, 0, 0]) {
        translate([0, 0, -wall / 2])
            linear_extrude(height=wall) 
                triAngeBeams2D();
        if (!openBeams) {
            translate([0, 0, -wall / 10])
                linear_extrude(height=wall / 5) 
                    triAngle2D();
        }
    }
}
module triAngeBeams2D() {
    t0 = [0, 0, 0];
    t1 = [lengthBeam, yUpper, 0];
    t2 = [0, yUpper - yLower, 0];
 
    hull() {
        translate(t0) circle(d=wall);
        translate(t1) circle(d=wall);
    }
    hull() {
        translate(t1) circle(d=wall);
        translate(t2) circle(d=wall);
    }
    hull() {
        translate(t0) circle(d=wall);
        translate(t2) circle(d=wall);
    }
}

module triAngle2D() {
    hull() {
        triAngeBeams2D();    
    }
}

/* First rotate then translate */
module rt(t=[0, 0, 0], r=[0, 0, 0]) {
    translate(t)
        rotate(r)
            children();
}

/* First translate then rotate */
module tr(r=[0, 0, 0], t=[0, 0, 0]) {
    rotate(r)
        translate(t)
            children();
}

function length(l= 40, angle = 0) = l / cos(angle);
function dY(l = 40, angle = 0) = sin(angle) * length(l = l, angle = angle);
