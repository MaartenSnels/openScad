tinDiameter = 75;   // actual size of tin, excluding thicker brim on top
margin      = .5;   // how much must upper oring be smaller than the tin
lidHeight   = 6;    // total height of lid

lip = 1.5;
$fn=60;
 /////////////  CALCULATED /////////////
 
lidDiameter = tinDiameter + lip - margin;

//////////////  RENDER /////////////////
lid();

////////////// MODULES //////////////////
module lid()  {
    difference() {
        union() {
            oRing();
            translate([0, 0, -lip / 2])
                cyl(lip, lidDiameter);
        }
        translate([0, 0, lidHeight / 2])
            cyl(lidHeight, lidDiameter);
    }

    translate([0,0,lidHeight/2])
    difference() {
        cyl(lidHeight    , lidDiameter + lip * 2);
        cyl(lidHeight + 1, lidDiameter);
    }

    translate([0,0,lidHeight]) oRing();
}

module oRing() {
    rotate_extrude()
        translate([lidDiameter / 2, 0, 0])
            circle(r = lip);
}

module cyl(h, d) {
    cylinder(h = h, d = d, center=true);
}