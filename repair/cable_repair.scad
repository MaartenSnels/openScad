$fn = 60;
kroonSteen = [5.8, 16.7, 7.7];
schroef = [5.15, 1.3, 5.5];
kroonSteenTussen = 2.4;

dWire = 10;



////////////////////////////////////////////////////////
///////////////// render drawing ///////////////////////
////////////////////////////////////////////////////////

//%kroonStenen(3);
cableAngle(radius = dWire * 1, angle = 180, before = 50, after = 50);
//cableMultiAngle();

////////////////////////////////////////////////////////
///////////////// prue display, do not print ///////////
////////////////////////////////////////////////////////


module cableMultiAngle(radius = 10, shape = [[90, 10, 10]]) {
    for (s = shape) {
        cableAngle(radius = radius, angle = s[0], before = s[1], after = s[2]);
    }
}

module cableAngle(radius = 10, angle = 90, before = 10, after = 10) {
    c = 10;
    color("red")
    rotate([0, 90, 0]) 
        cylinder(d = dWire, h = before);
    translate([before, radius, 0]) {
     #color("yellow")
       rotate([0, 0, -90])
            rotate_extrude(angle = mod(angle), convexity = c)
                translate([radius, 0])
                    circle(d = dWire);
    color("green")
        rotate([0, 0, mod(angle)])
    translate([0, -radius, 0]) 
        rotate([0, 90, 0])
            cylinder(d = dWire, h = after);
    }
    
}

module kroonStenen(aantal = 2) {
    t = kroonSteen.x + kroonSteenTussen;
    for(i = [0 : aantal - 1]) {
        translate([t * i, 0, 0])
            kroonSteen();
    }
    for (i = [1 : aantal - 1]) {
        translate([t * i - kroonSteenTussen / 2, kroonSteen.y / 2, 0]) {
            difference() {
                cylinder(d = kroonSteenTussen + 1.5, h = kroonSteen.z, center = false);
                cylinder(d = kroonSteenTussen, h = kroonSteen.z * 3, center = true);
            }
        }
    }
}

module kroonSteen() {
    kroonSteenBlok();
    translate([kroonSteen.x / 2, kroonSteen.y / 2, kroonSteen.z])
    kroonSteenSchroeven();
}
module kroonSteenBlok() {
    r = kroonSteen.x / 2;
    translate([0, 0, r])
        cube(kroonSteen - [0, 0, r]);
    translate([r, 0, r])
        rotate([-90, 0, 0])
            cylinder(r = r, h=kroonSteen.y, center = false);
}

module kroonSteenSchroeven() {
    tr = (schroef.x + schroef.y) / 2;
    for (i = [-1,1]){
        translate([0, tr * i, schroef.z / 2])
        difference() {
            cylinder(d = schroef.x, h = schroef.z, center = true); 
            cylinder(d = schroef.x - 1.5, h = schroef.z + 1, center = true); 
        }
    }

}

function mod(angle) = angle < 0 ? mod(angle + 360) : angle;

function nextCable(radius, startAngle = 0, startPos = [0, 0, 0], shape = [10, 90, 10]) = startPos + [0, 0, 0];