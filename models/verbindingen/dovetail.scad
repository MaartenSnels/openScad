/**
    blind dovetail 
    
    http://www.craftsmanspace.com/knowledge/dovetail-woodworking-joints.html
*/

l = 25;
b = 10;
h = 50;

hiddenThickness  = 2;
tailLength = b; // vergissing mijnerzeids, moet gelijk zijn natuurlijk
margin     = 0.2; // marging between pins and tail
angle = 75;  // 90 degrees is no dovetail.
             // hardwood 8:1 = 83 degrees. Softwoord 6:1 = 80 degrees
minimumGap  =  5;  // minimum room between tails

//calculate the number of tails
tails = getTails();
gap = getGap(tails);
echo(tails=tails, gap=gap);

color("green") tailBoard();
//color("red")   pinBoard();


module tailBoard(hidden = true) {
    union() {
        translate([tailLength, 0, 0])
            cube([l - tailLength, b, h]);
        pins(false, true);
    } 
}

module pinBoard(hidden = true) {
    difference() {
        translate([b, 0, 0])
            rotate([0, 0, 90])
                cube([l,b,h]);
        pins(true, true);
    }
}


module pin(cutOut) {
    
    m = cutOut ? margin : -margin;
    w = tailLength;    // width of pin
    tX = 0;   // translate x
    
    x = tailLength / tan(angle);
    p1 = [-x - m, 0];
    p2 = [-m, tailLength];
    p3 = [gap + m, tailLength];
    p4 = [gap + x + m, 0];
    
    p=[p1, p2, p3, p4];
    translate([tX, b, gap / 2])
    rotate([0, 90, -90])
    linear_extrude(height = b)
    polygon(p);
}

module pins(cutOut, hidden = true) {
    
    start = tailHeight(gap) / 2;
    height = 2 * start;
    union() {
        for (i = [0:tails - 1]) {
            translate([0, 0, start + i*height])
            pin(cutOut);
        }
        if (hidden) {
            cube([tailLength,hiddenThickness,h]);
        }
    }
}

//!halfPin(true, true);
module halfPin(top, cutOut) {
    c = [b*2, b*2, b];
    t = top ? [-b/2,-b/2, 0] : [-b/2, -b/2, -b];
    tc = top ? [0, 0, h] : [0, 0, 0];
    echo(top=top,t=t);
    translate(tc)
    difference() {
        pin(cutOut);
        translate(t)
            #cube(c);
    }
    
}


function getTails() = floor(h / tailHeight(minimumGap));
function getGap(tails)   = angle == 90 
                                ? h/(2 * tails)
                                : h/(2 * tails) - tailLength / tan(angle);  
function tailHeight(gap) = angle == 90 
                                ? gap 
                                : 2 * (tailLength / tan(angle) + gap);

