use <maarten.scad>

wall = 1;
margin = 0.1;

tandWiel();

//color("green") tandwiel(dWiel = 15, xWiel = 10, hAs = 40, dAs = 4, dInner = 3, hollow = true);
//up(-10) color("yellow") tandwiel(dWiel = 25, xWiel = 5, hAs = 70, dAs = 2.5, hollow = true, dInner = 1.5);
//up(-20) color("red") tandwiel(dWiel = 35, xWiel = 2, hAs = 100, dAs = 1, hollow = false);

/**
* door alle tandwielen kan een as van 1 mm, maar ze kunnen ook hol zijn
*/
module tandwiel(dWiel = 25
              , hWiel = 1
              , xWiel = 5
              , tanden = 25
              , dAs = 4
              , hAs =40
              , hollow = false
              , dInner = 1
              , fn = 60) 
{ 
    difference() {
        union() {
            cylinder(d=dAs, h=hAs, $fn = fn);
            up(xWiel) {
                // FIXME wtf? Waarom werkt dit niet.
//                tandWielHouder(dAs = dAs, h = hWiel * 1.2);
                tandWiel(tanden = tanden, d = dWiel, dAs = dAs, h = hWiel, $fn = fn);
            }
        }
        if (hollow) {
            cylinder(d = dInner, h = hAs * 3, center = true, $fn = fn);
        }
    }

}

module tandWielHouder(dAs = 4, h = 3, center = true) {
    up(center ? 0 : h / 2) {
        tandWielHouderGrip(dAs, h);
        up((wall - h) / 2)
            cylinder(d = dAs * 2, h = wall, $fn = 60, center = true);
    }
}

module tandWielHouderGrip(dAs = 4, h = 3, center = true) {
    aantal = 3;
    d = [dAs, dAs, h];
    t = [0, -dAs / 2, -dAs / 2];
    up(center ? 0 : h / 2) {
        intersection() {
            for(i=[0 : aantal -1]) {
                rotate([0, 0, i * 360 / aantal])
                    translate(t)
                        cube(d);
            }
            cylinder(d = dAs * 2, h = h, $fn = 60, center = true);
        }
    }

}

module tandWiel(tanden = 40, d = 25, dAs = 4, h = 2, fn = 60) {
    wall = d / 10;
    spokes = 7; 

    difference() {
        union() {
            difference() {
                cylinder(d = d, h = h, $fn = fn);
                up(-h * .1)
                    cylinder(d = d - wall * 2, h = h * 1.2, $fn = fn);
            }
            for (i = [0 : spokes - 1]) {
                rotate([0, 0, (360 / spokes) * i])
                    translate([0, -wall / 2, 0])
                        cube([d/2, wall, h]);
            }
        }
        #tandWielHouderGrip(dAs = dAs + margin, h = h * 2, center = true);
    }
}