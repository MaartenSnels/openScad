/*
    ideaa: https://www.thingiverse.com/thing:595481
    maze code: (i hope) http://burningsmell.org/maze.html

*/

use <maarten.scad>;

sides  = 8;   // number of sides of the box
hNut   = 10;  // height of the nut (lower part of the container)
dNut   = 25;  // width of the outside of the contaier
wall   = 3;   // thickness of the walls
height = 60;  // overall height of the container
margin = 0.2; // margin between inner en outer shell



$fn = 100;

fnGroove = 12;  // segments of groove
dGroove  = 2;  // diameter of groove
vGrooves = 18; // number of vertical grooves
hGrooves = 10; // number of horizontal grooves

//////// CALCULATED CONSTANTS ///////////
grooveAngle  = 360 / vGrooves;
grooveHeight = (height - hNut - wall * 2) / hGrooves;

echo (grooveAngle=grooveAngle, grooveHeight = grooveHeight);


///// RENDER /////////////////////
difference() {
    innerShell();
    groves();
}

//translate([0, dNut, 0]) outerShell();

///// MODULES /////////////////////

module outerShell() {
    difference() {
        hex(sides = sides, h = height - hNut);
        up(wall)
            cylinder(h = height, d = dInner(false));
    }
}

module groves() {
    for (h=[0 : hGrooves - 1])
        for(v=[0 : vGrooves - 1]){
            horizontalGroove(h = h, v = v);
            verticalGroove(h = h, v = v);
    }
}

module innerShell() {
    hex(sides = sides, h = hNut, d = dNut);
    up(hNut) difference() {
        cylinder(d = dInner(true), h = height - wall - hNut);
        up(-hNut + wall)
            cylinder(d = dInner(true) - wall * 1.5, h = height);
    }
}

module hex(sides = 6, h = 20, d = 20) {
    D = d / 10; // afronding van de hoeken
    angle = 360 / sides;
    linear_extrude(height = h) {
        hull() {
            for (i=[0 : sides - 1]) {
                rotate([0, 0, angle * i]) 
                    translate([d - D, 0, 0] / 2)
                        circle(d = D,$fn = 60); 
            }
        }
    }
}

module verticalGroove(h = 1, v = 1) {
    rotate(angleGroove(v))
        translate([dInner(true) /2, 0, upGroove(h)])
            cylinder(d=dGroove, h=grooveHeight, $fn=fnGroove);
    
}

module horizontalGroove(h = 1, v = 1) {
    up(upGroove(h))
        rotate(angleGroove(v))
            rotate_extrude(angle = grooveAngle)
                translate([dInner(true) / 2, 0, 0])
                    circle(d = dGroove, $fn = fnGroove);
}

///// FUNCTIONS ////////////////////////
function dInner(inner = true) = dNut / 1.5 + (inner ? -margin : margin);
function angleGroove(v) = [0, 0, grooveAngle * v];
function upGroove(h) = hNut + wall + ((height - hNut - wall *2) / hGrooves) * h; 


function rnd(cols) =  [ for (a = cols)  round(a) ];
function row(row) =  rnd(rands(0, 1, row));  
function matrix(row, col) = [for (a = [1:col]) row(row)];

echo (matrix(10, 8));
