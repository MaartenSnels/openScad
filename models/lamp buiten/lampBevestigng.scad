
/*
    lamphouder voor ikea lamp
    doorvoer stroom onder, mogelijkheid voor 
    kroonsteen oid om boel droog en kortsluit vrij te houden.
*/
$fn = 60;
straalBuiten = 110;
straalBinnen = 103;
hoogte = 30;
dikteBodem = 5;
draad = 12;

lamp();

module lamp() {
    difference() {
        union() {
            basePlate();
            bevestingingLamp();
        }
        doorvoerDraad();
        bevestigingSchutting();
        bevestingingLampBout();
        #trekOntlasting();
    }
}

module basePlate() {
    shift = 10;
    difference() {
        cylinder(d=straalBuiten, h=hoogte);
        translate([0,0,-shift]) 
            cylinder(d=straalBinnen, h=hoogte - dikteBodem - draad + shift);
        cylinder(d=90, h=hoogte - dikteBodem);
    }
}

module trekOntlasting() {
    // doorgang voor tyrip
    l = 10;
    b = 8; //breedte van de tyrip
    h = 2;
    
    translate([-l / 2, straalBinnen / 4, hoogte - h]) {
        cube([l, b, h]);
        translate([-h, 0, -dikteBodem + h])
        cube([h, b, dikteBodem]);
        translate([l, 0, -dikteBodem + h])
        cube([h, b, dikteBodem]);
    }
}

module bevestingingLamp() {
    startHoek = 135;
    aantal = 2;
    d = 14;
    h = draad;
    dX = 35;
    dZ = hoogte - dikteBodem - h;
    
    for(i = [0 : aantal - 1]) {
        hoek = i * (360 / aantal) + startHoek;
        rotate([0,0,hoek])
        translate([dX, 0, dZ])
        difference() {
            cylinder(d=d,h=h);
        }
    }
}
module bevestingingLampBout() {
    startHoek = 135;
    aantal = 2;
    bout = 6;
    moer=12;
    h = draad + dikteBodem;
    dX = 35;
    dZ = hoogte - h*1.5;
    
    for(i = [0 : aantal - 1]) {
        hoek = i * (360 / aantal) + startHoek;
        rotate([0,0,hoek]) {
            translate([dX, 0, dZ]) 
            cylinder(d=bout,h=h*2);
            translate([dX, 0, hoogte - dikteBodem])
            cylinder(d=moer,h=dikteBodem * 2, $fn=6);
        }
    }
}

module bevestigingSchutting() {
    h = dikteBodem * 4;
    d=4;
    aantalSchroeven = 4;
    dZ = hoogte - h/2;
    x = straalBinnen / 2 - 10 - d/2;
    for(i=[0:aantalSchroeven - 1]) {
        hoek = i * (360 / aantalSchroeven);
        rotate([0,0,hoek])
        translate([x, 0, dZ])
        cylinder(d=d, h=h);
    }
}

module doorvoerDraad() {
    h = (straalBuiten - straalBinnen) * 4;
    translate([0, (straalBinnen - h/2)/2, hoogte - dikteBodem - draad/2])
    rotate([90, 0, 0]) 
    cylinder(d=draad, h = h , center=true);
}