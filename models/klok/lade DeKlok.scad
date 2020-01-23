/*

    Keypad lade voor deKlok
    

*/

use <reinforce.scad>

lPad = 70;            // hoogte pad
bPad = 78;            // breedte pad
rPad = 5;             // afrondhoek van de pad
cable = 23;           // breedte van de kabel
cableDistance = 7;    // afstand van onderkand pad tot de kabel
cableConnector = 3.5; // dikte van de connector
margin = 1;           // extra ruimte in uitsparing
padMargin = 3;        // rand rond pad uitsparing
hPadHolder = 3;       // hoogte van de pad holder
hLade = 20;           // hoogte van de lader
overSteek = 25;;      // lade langer dan pad  
geleider= 3;          // dikte en breedte van de geleider
geleiderAfstand = 2;  // afstand van geleider t.o.v. boven en onderkant lade

leftSide = false;     // zit de lade aan de linker kant of rechter kant van de klok
ladeOpen = true;     // moet lade open of dicht getekend worden

/// BEREKENDE WAARDEN ///
lLade = lPad + margin + padMargin * 2 + overSteek;
bLade = bPad + margin + padMargin * 2;

echo ("hoogte",lLade, "breedte", bLade);

// render /////////////////////
    if (leftSide) {
        total(ladeOpen);
    } else {
        mirror([1,0,0]) total(ladeOpen);
    }

// MODULES //////////////////////

module total(ladeOpen=false) {
    l = 50;//lPad + margin + padMargin;
    b = hPadHolder + margin / 2 + geleider * 2;
    h = hPadHolder + margin / 2;
    
    translate([ladeOpen ? -l : 0, b, h]) part1(); 
    part2();
}

module part1() {
    translate([0, geleider, 0])
    difference() {
        union() {
            translate([0,0,hLade - hPadHolder]) padHolder();
            ladeMetOpener();
        }
        cutOut();
    }
}

module part2() {
    difference() {
        union() {
            front();
            translate([hPadHolder + margin, hPadHolder, hPadHolder])
            color("red") schuif(true);
            translate([hPadHolder + margin
            , bPad + margin + padMargin * 2 + geleider * 4 + margin
            , hPadHolder])
            color("red") schuif(false);
        }
    }
}

module schuif(left = true) {
    difference() {
        dY = left ? geleider * 2 - margin / 2 : -geleider;

        rail = [overSteek * 2, geleider * 2, geleider + margin];
        cube([overSteek - hPadHolder - margin, geleider * 3, hLade + margin]);
        translate([-overSteek / 2
            , dY
            , geleiderAfstand])
        cube(rail);
        translate([-overSteek / 2
            , dY
            , hLade - geleider - geleiderAfstand])
        cube(rail);
    }
}

module front() {
    dikte = hPadHolder;
    // een keer marge voor berikening van breedte en een keer om te zorgen dat
    // de boel past.
    l1 = overSteek;
    b1 = bPad + margin + padMargin * 2 + geleider * 2 + geleider * 4 + margin;
    h1 = hLade + margin;
    l2 = l1;
    b2 = b1 + dikte * 2;
    h2 = h1 + dikte * 2;
    difference() {
        cube([l2, b2, h2]);
        translate([-l1 / 2, dikte, dikte])
        cube([l1 * 2, b1, h1]);
    }
    // extra gat afsluiten
    cube([dikte, dikte * 3, h2]);
    translate([0, b2 - dikte * 3, 0])
    cube([dikte, dikte * 3, h2]);
    
    // bevestinging
    l = 2;          // dikte van de bevestiging
    b = 4 * dikte;  // oversteek links en rechts van de bevestiging
    o = 10;  // oversteek van de bevesting boven en onder
    
    out = [l, b * 2 + b2, h2 + o];
    in  = [l, b2, h2];
    translate([0, -b, -o/2]) 
    bevestiging(out, in);
    
}

/*
    maak een bevestigingsrand met gaten van afmeting out
    met als gat afmeting in. Gat wordt gecentreerd in de
    opening. 
    het nulpunt komt in [0.0,0]
*/
module bevestiging(out, in) {

    shift = 5; // hoever van de kant moeten de schroeven
    holes = [
                  [0, shift        , shift        ]
                , [0, shift        , out.z - shift]
                , [0, out.y - shift, shift        ]
                , [0, out.y - shift, out.z - shift]
            ];

    translate(out / 2) 
    difference() {
        cube(out, true);
        cube([in.x * 2, in.y, in.z], true);
        for(i=holes) {
            translate(i - out / 2) hole(6,2);
        }
    }
}


module hole(d=4, h=2) {
    scale = .5;
    l = 50;
    rotate([0,90,0]) 
    cylinder(d=d*scale, h=l, $fn=60);
    translate([-l, 0, 0])
    rotate([0,90,0]) 
    cylinder(d=d, h=l, $fn=60);
    rotate([0,90,0])
    linear_extrude(height=h, scale=scale)
    circle(d=d, $fn=60);
}

module ladeMetOpener() {
    r = [0, -90, 0];
    t = [0, bPad + margin, hLade] / 2;
    difference() {
        lade();
        translate(t) rotate(r) pil(d= hLade - hPadHolder * 2, half=false);
    }
    translate(t) rotate(r) opener();
}

module lade() {
    l1 = lLade;
    b1 = bLade;
    h1 = hLade;
    l2 = l1 ;
    b2 = b1 - padMargin * 2;
    h2 = h1;
    difference() {
        cube([l1, b1, h1]);
        translate([padMargin, padMargin, -h2 / 2]) cube([l2, b2, h2 * 2]);
    }
    b = geleider;
    h = geleiderAfstand;
    // geleide rails
    for (i = [ [0, -b, h]
            , [0, -b, hLade - b - h] 
            , [0, b1, h] 
            , [0, b1, hLade - b - h] ]) 
    {
       translate(i) cube([l1, b, b]); 
    }
    // begin en end stops
    for (i = [ [0,      -b, 0]
            , [l1 - b, -b, 0] 
            , [0,      b1, 0] 
            , [l1 - b, b1, 0] ]) 
    {
       translate(i) cube([b, b, h1]); 
    }
    reinforceX(d=[l1, b1, 4], width=5, xOnly=true);
   
}

module opener() {
    h=2;
    d2=hLade - hPadHolder;
    d1=d2 - 2;
    difference() {
        union() {
            difference() {
                pil(d2);
                pil(d1);
            }
            translate([0,h/2,0])
            rotate([90,0,0]) 
            cylinder(d=d2,h=h, $fn=60);
        }
        translate([-d2, -h, 0]) cube([d2*2, h*2, d2*2]);
    }
}
module pil(d=20, half = true) {
    translate([0,-d,0])
    difference() {
        hull() {
            sphere(d=d, $fn=60, center=true);
            translate([0,2*d,0])
            sphere(d=d, $fn=60, center=true);
        }
        if (half)
        translate([-d, -d, 0]) cube([d * 2, d * 4, d]);
    }
}

module cutOut() {
    d = hLade - (geleider + geleiderAfstand + margin) * 2;
    l = lLade;
    dX = 20;

    hull() {
        translate([dX, bPad / 2, hLade / 2])
            cutOutCylinder(d);
        translate([l - dX, bPad / 2, hLade / 2])
            cutOutCylinder(d);
    }
}

module cutOutCylinder(d=10) {
    rotate([90, 0, 0])
    cylinder(d=d, h= bPad * 2, center = true, $fn=60);
}

module padHolder() {
    dL = padMargin * 2;
    
    difference() {
        cube([lPad + margin + dL, bPad + margin + dL, hPadHolder]);
        translate([padMargin, padMargin, hPadHolder - 1])
        pad(margin, 3);
        translate([(lPad + dL - cable ) / 2, padMargin + cableDistance , - hPadHolder / 2 ])
        cube([cable + margin, cableConnector, hPadHolder * 2]);
    }
}

module pad(margin = 0, h = 1) {
    l = lPad - rPad * 2 + margin;
    b = bPad - rPad * 2 + margin;
    
    linear_extrude(height=h)
    translate([rPad, rPad, 0])
    minkowski() {
        square( [l, b], true);
        translate([l / 2, b / 2, 0])
        circle(rPad);
    } 
}