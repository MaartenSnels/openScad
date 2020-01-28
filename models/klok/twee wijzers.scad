

/**
    klok met twee wijzers
**/

/* Afmetingen van 603 zz kogellager, afmetingen o.a. te vinden in keep.google.com */
dBearing = 3; 
DBearing = 9;
hBearing = 5;

lLang = 250;
bLang = DBearing * 2;
hLang = hBearing * 3;
lKort = 125;
bKort = DBearing;
hKort = DBearing;

draaiPunt = DBearing * 2;
draaiPuntLang = lLang - DBearing;
draaiPuntKort = DBearing;
marge  = 1;
uur    = 0;
minuut = 15;

//// RENDER ////////
klok();

//// MODULES //////
module klok() {
    langeWijzer();
    korteWijzer();
}

module langeWijzer() {
    hK = hKort * 2;
    rotate([0, hoekMinuut(), 0])
    union() {
        translate([-draaiPunt, -bLang / 2, -hLang / 2])
        difference() {
            cube([lLang, bLang, hLang]);
            translate([draaiPuntLang, bLang / 2, hLang / 2])
            rotate([90, 0, 0])
            cylinder(r= lKort + marge, h = bKort + marge, $fn  = 100, center = true);
            translate([draaiPuntLang, bLang / 2, hLang / 2])
            rotate([90, 0, 0])
            cylinder(d= DBearing, h = bLang*2, $fn  = 60, center = true);
        }
        rotate([90, 0, 0])
        cylinder(d= DBearing, h = bLang*2, $fn  = 60, center = true);
        
    }
}
module korteWijzer(){
    hAxis = hBearing * 4 + bKort;
    translate(posKort())
    rotate([0, hoekUur(), 0])
    union() {
        translate([0, -(bKort + hBearing) / 2, 0]) driveWheel();
        translate([-draaiPuntKort, -bKort / 2, -hKort / 2]) cube([lKort, bKort, hKort]);
        translate([0, (bKort + hBearing)/2, 0]) driveWheel();
        rotate([90,0,0]) cylinder(d=dBearing, h=hAxis, center=true, $fn=60);
    }
}

// wiel dat korte wijzer laat aanstuurt
module driveWheel() {
    rotate([90, 0, 0])
    difference() { 
        cylinder(d=DBearing, h=hBearing, center=true, $fn=100); 
        rotate_extrude(convexity=2) 
        translate([DBearing / 2,0,0]) 
        circle(d = DBearing / 2, $fn=6); 
    }     
}
echo(posKort = posKort());
function hoekMinuut() = 360 / 60 * minuut - 90;
function hoekUur()    = 360 / 12 * (uur + minuut / 60) - 90;
function posKort() = [(draaiPuntLang - draaiPunt) * cos(hoekMinuut())
                     , 0
                     , -(draaiPuntLang - draaiPunt) * sin(hoekMinuut())];
