use <maarten.scad>

bord        = [62, 28, 1.6   ];     // afmeting van het bordje
oled        = [27, 15, 1     ];     // afm. oled
posOled     = [27,  8, bord.z];     // positon of oled
chip        = [15, 12, 3.5   ];     // afm. chip
posChip     = [ 8,  8, bord.z];     // position of chip
box         = [80, 40, 15    ];     // size of the box
dHole       = 3;                    // diameter van de gaten
rBord       = 2;                    // radius bordje
margin      = 0.1;                  // margins
wall        = 2;                    // wanddikte doosje
delta       = 2;                    // ruimte tussen oled en binnenkant van de box
usb         = [15, 13];             // size of usb hole    
wallBezel   = 1.5;                  // wall of beezle


%up(5) bord();
doosje();

module doosje() {
    tOled = posOled + [bord.x, bord.y, 0] / -2;
    difference() {
        up(box.z / 2)
            mirror([0, 0, -1])
                roundedBox(box, bottom = true, w = wall, center = true);
        translate(tOled)
            cube([oled.x, oled.y, box.z]);
        usb();
    }
    bordHolder(box.z - wall);
    beezel(tOled);
}

module beezel(t=[0, 0, 0]) {
    up(box.z - wall * 2 - delta)
        translate(t - [wallBezel, wallBezel, 0])
            box(size = [oled.x + wallBezel * 2, oled.y + wallBezel * 2, delta + wall]
              , w = wallBezel
              , center = false);
    
}

module usb() {
    delta = 1;
    translate([box.x / 2 + wall, usb.y / 2, delta] * -1)
        cube([wall * 3 + delta, usb.x, usb.y, ]);
}


module bordHolder(top = 10) {
    m = 2;
    h = bord.z + chip.z + delta;
    up (top - h) {
        up(-m)
        holes( d = dHole - margin
            ,  h = bord.z + m
            ,  center = false);
        up(bord.z)
        holes( d = dHole + 1
            ,  h = chip.z + delta 
            ,  center = false);
    }
}



///// BORDJE, ALLEEN VOOR PASSEN EN METEN ///////////
module bord() {

    difference() {
        translate([bord.x, bord.y, 0] / -2)
            union() {
                color("green")
                    roundedCube(bord
                              , radius = rBord
                              , center = false);
                color("gray") oled();
                color("gray") chip();
            }
            holes(d = dHole, h = bord.z * 3, center = true);
    }
}

module oled() {
    translate(posOled) cube(oled);
}

module chip() {
    translate(posChip) cube(chip);
}
module holes(d = 3, h = 5, center = true) {
    r = rBord + .5; 
    x = bord.x / 2 - r;
    y = bord.y / 2 - r;
    
    for (i=[ [ x,  y, 0]
            ,[ x, -y, 0]
            ,[-x,  y, 0]
            ,[-x, -y, 0] ]) {
                
        translate(i)
            cylinder( d      = d
                    , center = center
                    , h      = h
                    , $fn    = 30);
    }
}