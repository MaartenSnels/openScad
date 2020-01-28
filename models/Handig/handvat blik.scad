/////////////////// CONSTANTS //////////////////////////
BOTTOM    = "bottom";
TOP       = "top";
STICK     = "stick";
ALL       = "all";
ASSAMBLED = "assamble";

/////////////////// VARIABLES //////////////////////////
dCanTop       = 101.5;  // diameter top of the can
dCanBottom    = 100;    // diameter of bottom of the can
hCan          = 118.5;  // height of the can, only used if you print the stick
dBroomStick   = 25;     // diameter broomstick
hHandle       = 10;     // height of the handle
wall          = 3;      // wall
dScrew        = 3;      // diamter screws to secure broomstick
hScrew        = 30;     // depth of screwhole in stick
grip          = 110;    // distance between tin an broomstick
$fn           = 100;
withStick     = true;   // print the broomstick
stickSeperate = false;  // separate stick with two scrwholes of as part of
                        // the top
print         = ASSAMBLED;  // possible: "all", "bottom", "top", "stick", "assambled"


/////////////////// RENDER    //////////////////////////
print();

/////////////////// MODULES   //////////////////////////
module print() {
    if (print == ALL) {
        bottom();
        translate([grip - dCanTop / 4, max(dCanTop, dCanBottom), 0]) 
        rotate([0, 0, 180])
        top();
    } else if (print == BOTTOM) {
        bottom();
    } else if (print == TOP) {
        top();
    } else if (print == STICK) {
        stick();
    } else if (print == ASSAMBLED) {
        translate([0, 0, wall * 2 + hCan])
            rotate([180, 0, 0])
                top();
        bottom();
    }
}

module bottom() {
    handle(d = dCanBottom, screwHole = true);
}

module top() {
    handle(d = dCanTop, screwHole = screwHole());
    if (withStick) {
        if (stickSeperate && print != ASSAMBLED) {
            stick();
        } else {
            translate([grip, 0, wall])
                stick();
        }
    }

}

module handle(d = 100, screwHole = true) {
    dX = grip;
    difference() {
        linear_extrude(height=hHandle + wall) {
            hull() {
                circle(d = d + wall * 2);
                translate([dX, 0, 0])
                    circle(d = dBroomStick + wall * 2); 
            }
        }
        translate([0, 0, wall])
            cylinder(d = d, h=hHandle + wall);
        cylinder(d = d - wall * 2, h=hHandle, center = true);
        translate([dX, 0, wall])
            cylinder(d = dBroomStick, h=hHandle + wall);
        if (screwHole) {
            translate([dX, 0, 0])
                screw();
        }
    }
}

module screw() {
    translate([0, 0, wall / 2])
        cylinder(d = dScrew, h=hHandle, center = false);
    translate([0, 0, wall])
        mirror([0, 0, -1])
            linear_extrude(scale = 2.5, height = wall) circle(d=dScrew);
}

module screwHoleStick() {
    cylinder(d = dScrew / 1.5, h = hScrew * 2, center = true);
}

module stick() {
    difference() {
        cylinder(d=dBroomStick, h=hCan);
        if (screwHole() || print == STICK) {
            screwHoleStick();
        }
        translate([0, 0, hCan])
            screwHoleStick();
            
    }
}

/////////////////// FUNCTIONS //////////////////////////
function screwHole() = (withStick && stickSeperate) || !withStick; 