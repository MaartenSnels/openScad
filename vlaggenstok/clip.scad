$fn = 60;
dStaaf = 28.3;
dSchroef = 3.5;
dSchroefKop = 6.6;
dMoer = 6.6;
h = 10;
dGap = 2;
dTouw = 3;
schoefGatMove = 6; // schoef moet minstens 2 * move zijn

ring();
// zigZag();
module ring() {
    difference() {
        sphere(d = dStaaf * 2);
        cylinder(d = dStaaf, center = true, h = dStaaf * 4);
        translate([0, 0, dStaaf * 2 + h / 2])
            cube([1,1,1] * dStaaf * 4, center = true);
        translate([0, 0, -dStaaf * 2 + -h / 2])
            cube([1,1,1] * dStaaf * 4, center = true);
        
        x = 100;
        // inkeping
        translate([0, -dGap / 2, -50])
            cube([x, dGap, x]);
        
        // gaten voor schroef om boel aan te draaien
        translate([dStaaf * 0.75, 0, 0])
            rotate([90, 0, 0])
                cylinder(d = dSchroef, h = x, center = true);
        translate([dStaaf * 0.75, -schoefGatMove, 0])
            rotate([90, 0, 0])
                cylinder(d = dSchroefKop, h = x, center = false);
        translate([dStaaf * 0.75, x + schoefGatMove, 0])
            rotate([90, 0, 0])
                cylinder(d = dMoer, h = x, center = false, $fn = 6);
        
        // gat voor touw 
        rotate([0, 0, -30])
        translate([0, -dStaaf * 0.70, 0])
                cylinder(d = dTouw * 2, h = 100, center = true);
                
        rotate([0, 0, 30]) {
            translate([0, dStaaf/2 + dTouw * 1.5, 0]) { 
                zigZag();
                translate([0, dTouw/2, 0])
                cube([dTouw, dTouw, h * 2], center = true);
            }
            
        }
    }
    rotate([0, 0, 30]) {
        translate([0, dStaaf/2 + dTouw * 2.5, 0]) { 
            cylinder(d = dTouw, h = h, center = true);
        }
    }

}

module zigZag() {
    
    hull() {
        translate([-1, 1.5, 0] * dTouw)
            #cylinder(d = dTouw, h = h * 2, center = true);  
        translate([-dTouw, 0, 0])
            cylinder(d = dTouw, h = h * 2, center = true);  
    }    
    hull() {
        translate([dTouw, 0, 0])
            cylinder(d = dTouw, h = h * 2, center = true);  
        translate([-dTouw, 0, 0])
            cylinder(d = dTouw, h = h * 2, center = true);  
    }    
    hull() {
        translate([dTouw, dTouw * 7, 0])
            cylinder(d = dTouw, h = h * 2, center = true);
        translate([dTouw, 0, 0])
            cylinder(d = dTouw, h = h * 2, center = true);  
    }
    //translate([0, dTouw / 2, 0])
   // cube([dTouw, dTouw, h*2], center = true);
}