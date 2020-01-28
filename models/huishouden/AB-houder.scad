/*
    bevestig afstandbediening aan vensterbank
    
    TODO
    -   gat verder door laten lopen zodat je een beetje ruimte aan de onderkant hetb
    -   diepte van de AB in de houder variabel maken
    -   bovenste houder iets steviger??
*/




vensterBank  = 31;
AB           = [16, 37, 106];
knoppenOnder = 40;
knoppenBoven = 30;
knopBreedte  = 20; 

wand = 3;
klemDiepte = 30;

vensterBankKlem();
translate([-AB.x - wand, 0, -AB.z / 2]) ABHouder();

module vensterBankKlem() {
    b = AB.y + wand * 2;

    difference() {
        cube([klemDiepte + wand, b, vensterBank + 2 * wand]);
        translate([wand, -b / 2, wand])
        cube([klemDiepte + wand, b * 2, vensterBank]);
    }
    translate([wand, 0, -klemDiepte])
    rounded();
}

module ABHouder() {
    difference() {
        cube([AB.x + wand * 2, AB.y + wand * 2, AB.z / 2 + vensterBank + wand * 2]);
        translate([wand, wand, wand])
        cube([AB.x, AB.y, AB.z]);
        translate([wand * 1.5, AB.y/ 2 + wand, wand])
        uitsparing();
    }
}

module uitsparing() {
    translate([0,0,knopBreedte / 2])
    rotate([0,-90,0])
    hull() {
        cylinder(d=knopBreedte, h = 2 * wand);
        translate([AB.z, 0, 0])
        cylinder(d=knopBreedte, h = 2 * wand);
    }
}

module rounded() {
    b = AB.y + wand * 2;
    difference() {
        cube([klemDiepte, b, klemDiepte]);
        translate([klemDiepte, b/2, 0])
        rotate([90, 0, 0])
        cylinder(r = klemDiepte, h=b * 2, center = true, $fn=60);
    }
}