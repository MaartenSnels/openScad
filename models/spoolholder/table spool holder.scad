include <polyScrewThread.scad>
include <knurledFinishLib.scad>

/////// SETTINGS ///////////////////////

overhangOnder = 55;        // overhang of bottom
overhangBoven = 35;        // overhang of top 
table         = 34.5;      // thickness of tabletop
dSpool        = 220;       // diameter of spool, to determine clearence from table
hSpool        = 70;        // height of the spool (not used for holder
wall          = .75;       // thickness of the wall
dBeam         = 09;        // thickness of the beams   
dOutHolder    = 25;        // diamter of spool holder
dInHolder     = 10;        // hole in spoolholder
fill          = false;     // fill space between beams
center        = false;     // Center part to middle of the beams,print with support
mirror        = false;     // if center is false, mirror the print
hClamp        = 21;        // height of the clamp
dScrew        = 14;        // diameter of clamping screw
surrounding   = false;     // show surrounding
hKnob         = 25;        // height of the knob on the clamp bolt
doPrint       = "endStop"; // [bolt, clamp, holder, endStop,  all]
color         = "color1";  //[color1, color2, all]
nut           = [16, 9.5, 6.5];  // M8, [dOut, dIn, h], nut in endStop
hEndStop      = 15;        // height of endstop    
dEndStop      = 55;        // diameter of endStop

/*******************************
**    position of the points  ** 
********************************
**            _p2
**        __/   |\
**      p1------p0\
**              |  \
**              |   \     
**      p4------p5   \
**        \____       \
**             \____   \
**                  \__ \
**                      p3
*******************************/
p0 = [0, dBeam / 2, 0];
p1 = [-overhangBoven, dBeam / 2, 0];
p2 = [0, table + dBeam / 2];
p3 = [dSpool + dBeam, -(dSpool + dBeam), 0] * .50;  
p4 = [-overhangOnder, -table - dBeam / 2, 0];
p5 = -p2;

///// calculated //////////

/////// paths /////////////////////////
pathOut = [p0, p1, p2, p3, p4, p5];
pathCutOut = [p0, p1, p4, p5];

///////// render ///////////////////

doPrint();

//////////// modules //////////////////

module doPrint() {
    if (doPrint == "bolt") {
        bolt();
    } else 
    if (doPrint == "endStop") {
        endStop();
    } else 
    if (doPrint == "clamp") {
        print(clampOnly = true);
        translate(middle(p0, p4)) bolt();
    } else 
    if (doPrint == "holder") {
        color("yellow") print(clampOnly = false);
    } else {
        print(clampOnly = false);
        echo(middle(p0, p5));
        translate([p5.x + p0.x
                 , p5.y + p0.y
                 , 0] / (mirror ? -2 : 2) - [dBeam + dScrew, 0, 0]) 
            bolt();
    }
    if (surrounding) {
        %spool();
        %table();
    }
}



module print(clampOnly = false) {
    shift = center ? -(hClamp - dBeam) / 2 : 0;
    mirror([0, mirror ? -1 : 0,  0])
    difference() {
        union() {
            if(!clampOnly) {
                grip(fill);
                holder();
            }
            up(shift)
                clamp();
        }
        translate(p3)
            cylinder(d=dInHolder, h = hClamp * 3, center = true);
        up(shift) {
            screwHole();
        }
    }
}

module screwHole() {
    marge = 0.6;
    l = length(p0, p1);
    translate(middle(p0, p1) + [0, -dBeam, hClamp / 2])
        rotate([-90,0,0])
            mirror([0, mirror ? -1 : 0,  0])
                screw_thread(dScrew + marge, 4, 55, l, PI / 2,2);
    translate(middle(p0, p1) + [0, dBeam, hClamp / 2])
        rotate([-90,0,0])
            cylinder(d = dScrew + 2, h = l);
}

module clamp() {
    
    inside([p0, p1, p2], wall = hClamp, center = false);
    beam(p0, p5, hClamp);
    beam(p4, p5, hClamp);
}

module table() {
    x = hSpool * 4;
    y = table;
    z = x;
    translate([-x, -y, -z/2])
        cube([x, table, z]);
}
module spool() {
    start = dBeam * 1.2;
    hs = dBeam / 2;
    translate([p3.x, p3.y, start])
        cylinder(d=dSpool, hs);
    translate([p3.x, p3.y, start + hSpool])
        cylinder(d=dSpool, h = hs);
    translate([p3.x, p3.y, start])
        cylinder(d=dSpool / 3, h = hs + hSpool);
}
module holder() {
    up(center ? -(hClamp - dBeam) / 2 : 0)
        translate(p3)
            cylinder(d=dOutHolder, h = hClamp);
}

module grip(filled = true) {
    if (filled) {
        difference() {
            inside(pathOut, center = center);
            up(center ? 0 : -wall * .1)
                inside(pathCutOut, wall * 1.2, center = center);
        }
    }
    outside(pathOut);
    versteviging();
}

module versteviging() {
    hoek = atan(abs(p3.y - p2.y)/abs(p3.x - p2.x));
    y = p2.y - p5.y;
    x = y / tan(hoek); 
    beam(p0, p2);
    beam(p5, [p5.x + x, p5.y, 0]); //TODO nog te bepalen a.h.v. hoek
}

module outside(path) {
    for(i=[0:len(path) - 1]) {
        beam(path[i], path[i +1>= len(path) ? 0 : i+1]);
    }
}

module inside(path, wall = wall, center = true) {
    up(center ? (dBeam - wall) / 2 : 0)
    linear_extrude(height = wall)
        hull()  
            for(p=path) {
                translate(p) 
                    circle(d=dBeam);
            }
}

module beam(p1=[0, 0, 0], p2=[50, 50, 0], h = dBeam) {
    linear_extrude(height=h)
        hull() {
            translate(p1) 
                circle(d=dBeam);
            translate(p2) 
                circle(d=dBeam);
        }
}

module bolt(){
    length = length(p0, p1) + dBeam;

    up(center ? -(hClamp - dBeam) / 2 : 0) {
        knurled_cyl(hKnob, dScrew + 4, 2.5, 2.5, 1, 2, 10);
        up(hKnob)
            screw_thread(dScrew, 4, 55, length, PI/2,2);
        up(hKnob + length)
            cylinder(h = 1, d = dScrew - 4, $fn=30);
    }
}

module endStop() {
    a = 5;
    
    up = hEndStop / 2;
    up(up) {
        intersection() {
            up(-up)
                difference() {
                    knurled_cyl(hEndStop, dEndStop, a, a, 1, 2, 10);
                    up(hEndStop - nut.z)
                        cylinder(h=dEndStop, center = false, $fn=6, d = nut.x);
                    cylinder(h=dEndStop * 3, center = true, $fn=60, d = nut.y);
                }
            sphere(d = dEndStop * 1.015, $fn = 60);
        }
    }
}

module up(up=0) {
    translate([0, 0, up]) {
         children();
    }
}

///// FUNCTIONA
function middle(p0, p1) = (p0 + p1) / 2;
function length(p0, p1) = sqrt(pow(p0.x - p1.x, 2) + pow(p0.y - p1.y, 2)) + dBeam;