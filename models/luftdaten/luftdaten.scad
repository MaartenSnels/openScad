/*

    module to store the electronics vor luftdaten (https://luftdaten.info/)


    TODO:
    -   bodem voorzien van schroefdraad
    -   extra rand aan onderste segment om bodem in te schroeven
    -   muurbevestinging
    -   doorvoer voor usb kabel
    -   bevestiging voor apperatuur
    -   zorgen dat de bevestiging niet omvalt
    





*/



use <maarten.scad>



fn = 180;
dOut = 110;                         // outer diameter
dIn  = 90;                          // inner diameter
wall = 2;                           // wall thickness
hSegment = 20;                      // hoogte van segment
hLid = 25;                          // hoogte van dakje
layers = 5;                         // height of instrument, includijg the top layer
ventilation = [wall, wall * 2];     // size of ventilation holes
holes = 30;                         // number of holes 
dLuchtSlang = 6;                    // luchtslang
margin = .2;                        // fitting between segment and bottom
hTop = wall * 2;                    // height of top and bottom
print = "printAll";                 // bottom, cover, all, assemble, cutout, printAll


doPrint();

module doPrint() {
    if (print == "bottom") {
        up(hTop)
        bottom();
    } else if (print == "cover") {
        up(layers > 1 ? (layers - 1) * hSegment : 0)
            total(bottom = false);
    } else if (print == "all") {
        translate([0, dOut + 10, hTop])
            bottom();
        up(layers > 1 ? (layers - 1) * hSegment : 0)
            total(bottom = false);
    } else if (print == "printAll") {
        translate([0, dOut + 10, hTop])
            bottom();
        rt(r=[0, 180, 0], t=[0, 0, hLid + hTop])
            total(bottom = false);
    } else if (print == "cutout"){
        up(layers > 1 ? (layers - 1) * hSegment : 0)
        cutout(90) total(layers);    
    }
}

module cutout(rotate = 0) {
    rotate([0, 0, rotate])
    difference() {
        rotate([0, 0, -rotate])
            union() 
                children();
        cube=[dOut, dOut, max(hSegment, hLid) * layers] * 2;
        trans = [cube.x / 2 + margin, 0, 0];
        translate(trans)
            cube(cube, center = true);
        translate(-trans)
            cube(cube, center = true);
    }
}

module total(layers = 5, bottom = true) {
    top();
    if (layers > 1) {
        for(i = [1 : layers - 1]) {
            up(-hSegment * i ) 
                segment();
        }
    }
    if (bottom) {
        up(-hSegment * (layers - 1) + (hLid - hSegment) - margin)  
            bottom();
    }
}

module top() {
    segment();
    hoek = atan(hLid / ((dOut - dIn) / 2) );
    echo(hoek = hoek);
    d2 = dIn - hTop * cos(hoek) * 2;
    up(hLid)
        cylinder(d1 = dIn, d2 = d2, h = hTop, $fn = fn );
}
module segment() {
    difference() {
        cylinder(d1=dOut, d2 = dIn, h = hLid, $fn = fn );
        up(-wall * 2) cylinder(d1=dOut, d2 = dIn, h = hLid);
        cylinder(d=dIn - wall * 2, h=hLid * 3, center = true, $fn = fn );
    }
    up(hLid - hSegment)
        mesh();
}


module mesh() {
    difference() {
        cylinder(d = dIn, h = hSegment, $fn = fn );
        up(-wall) cylinder(d = dIn - wall * 2, h = hSegment + wall * 2, $fn = fn );
        for(i=[0 : holes - 1 ]) {
            tr( t = [0, -ventilation.x, hSegment - ventilation.y] / 2 
              , r = [0, 0, 360 / holes * i])
                    cube([dOut / 2, ventilation.x, ventilation.y], center = false);
        }
    }

}

module bottom() {
    h2 = wall * 3;
    up(-hTop)
    difference() {
        union() {
            cylinder(d = dIn, h = hTop, $fn = fn );
            up(hTop)
                cylinder(d = dIn - wall * 2 - margin, h = h2, $fn = fn );
        }
        translate([0, dIn - wall * 4 - dLuchtSlang, 0] / 2)
        cylinder(d = dLuchtSlang, h = (hTop + h2) * 3, center = true, $fn = fn );
    }
    
    rt(r=[90, 0, 0], t=[0, 0, h2]) lucht();
    
}
module lucht() {
    dScrew = 5;
    grondPlaat = [75, 75, wall];
    
    dX = 2.5;
    dY = 2.5;
    holesF = [  [dX +  5, dY + 11, 3.2]
              , [dX + 65, dY + 11, 3.2]
              , [dX + 46, dY + 66, 3.2]
            ];
    
    translate([grondPlaat.x, 0, grondPlaat.z] / -2) {
        difference() {
            cube(grondPlaat);
            for (h = holesF) {
                translate([h.x, h.y, 0]) 
                    cylinder(d = dScrew, h=30, center = true, $fn = 6);
            }
        }
        for (h = holesF) {
            translate([h.x, h.y, wall]) {
                difference() {
                    cylinder(d=10, h=10, $fn = fn );
                    cylinder(d=h.z, h=30, center = true, $fn = fn );
                }
            }
        }
}
}
