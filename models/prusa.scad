dOuter = 26;
dInner = 17;
bOuter = 8;
bInner = 10;
$fn = 60;

DBearing = 22;
dBearing = 8;
hBearing = 7;

wall = 5; // minimal wall thickness


prusaCover();
bearingHolder();

module bearingHolder() {
    l = dOuter + wall * 2;
    b = hBearing + wall;
    h = dOuter / 2 + wall * 2;
    difference() {  
        translate([0, -b, -wall])
        cube([l, b, h]);
        translate([dOuter / 2 + wall, 0,DBearing / 2 ])
        cutOut(DBearing, hBearing, dBearing * 2, 20, DBearing, down=false);
    }
}


module prusaCover() {
    difference() {
        l = dOuter + wall * 2;
        b = bOuter + bInner + wall * 2;
        h = dOuter / 2 + wall * 2;
        
        translate([0, 0, -wall])
        cube ([l, b, h]);
        translate([l / 2, b - wall, 0])
        cutOut(dOuter, bOuter, dInner, bInner, dOuter);
    }
}
module cutOut(d1, h1, d2, h2, stretch, down=true) {
    rotate([90,down?90:-90,0]) {
        stretchCylinder(d=d1, b=h1, h=stretch);
        translate([0, 0, h1])
        stretchCylinder(d=d2, h=h2, h=stretch);
    }
}

module stretchCylinder(d = 10, b = 10, h = 10) {
   hull() {
       cylinder(d=d, h=b);
       translate([h,0,0])
       cylinder(d=d, h=b);
   }
}