

dLamp = 83;     // diamter lamp
hLamp = 27;     // hoogte bedekt
wall  = 5;      // dikte van wand en nu ook nog van bodem
bodem = 5;      // nog niet gebruikt
dDraad = 16;    // gat voor draad
lGat = 73;      // afstandt tussen bevestigingsgaten in lamp
fn = 60;        // hoe nauwkeurig moeten rondingen worden getekend
holes = 2;      // aantal gaten om lamp aan lamphouder te vevestigen
bevGaten = 3;   // aantal bouteen waarmee doos aan wand wordt bevestigd 
startHoek = 30; // hoek waarover de gaten gedraaid moeten worden
dGat = 4.5;     // bevestigingsGat
dMoer = 8.5;    // diameter moerhouder


// berekende waarden
h = hLamp + wall + dDraad + 1;
echo(h=h);
// 68.5 77.5
wandHouder();

module wandHouder() {
    difference() {
        union() {
            difference() {
                cylinder(d=dLamp, h = h, $fn = fn);
                up(wall) cylinder(d=dLamp - wall * 2, h = h, $fn = fn);
                gaten() cylinder( d = dGat * 2
                                , h = h * 3
                                , $fn = fn
                                , center = true);
            }
            gaten() uitsparing(dMoer * 2, h);
        }
        difference() {
            cylinder(d = dLamp * 2, h = h * 3, $fn = fn, center = true);
            cylinder(d = dLamp    , h = h * 3, $fn = fn, center = true);
        }
        gaten() schroefGat();
        bevestigingsGaten();
        draadDoorvoer();
    }
}

module bevestigingsGaten() {
    x = dLamp / 2 - wall - dGat * 2 - 1;
    for(i=[0 : bevGaten - 1]) {
        hoek = 360 / bevGaten * i + startHoek;
        rotate([0, 0, hoek])
        translate([x, 0, 0])
        cylinder(d = dGat, h = wall * 3, $fn = fn, center = true);
    }
}

module draadDoorvoer() {
    translate([0, dLamp / 4, 0]) trekOntlasting();
    translate([0, dLamp / 2, dDraad / 2 + wall])
        rotate([90, 0, 0])
            cylinder(d = dDraad, $fn = fn, h = wall * 3, center = true);
}

module trekOntlasting() {
    // doorgang voor tyrip
    l = 14;
    b = 8; //breedte van de tyrip
    h = 2;
    
    translate([-l / 2, -b / 2, 0])
    difference() {
        cube([l, b, wall + h]);
        translate([h, -b / 2, h])
        cube([l - 2 * h, b * 2, wall * 2]);
    }
}


module uitsparing(d, h) {
    cylinder(d = d, h = h, $fn = fn);
    translate([0, -d/2, 0]) cube([d, d, h]);
}

module schroefGat() {
    z = h - hLamp;
    up(-wall)  uitsparing(d = dMoer * 1.5, h = z + wall );
    up(-wall) cylinder(d = dGat , h = h * 2, $fn= fn);
    up(z) rotate([0, 0, 30]) cylinder(d = dMoer , h = 6, $fn= 6);
}

module gaten() {
    x = lGat / 2 ;
    for(i=[0:holes - 1]) {
        rotate([0, 0, 360 / holes * i])
        translate([x, 0, 0])
        children();
    }
}

module up(h) {translate([0, 0, h]) children();}