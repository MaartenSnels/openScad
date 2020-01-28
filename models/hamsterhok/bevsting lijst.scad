hoogte = 15;        // hoogte van klem
overlap = 40;       // totale lengte
stijl = 20.5;
lijst = 34.5;
dikte = 2;

lijst(lijst);
translate([0, -overlap / 2, 0]) lijst(stijl,top=false );
vulPlaat();

module lijst(b = lijst, top = true) {
    rotate([0, 180, 0])
    difference() {
        cube([b + dikte * 2, overlap / 2, hoogte + dikte]);
        if (top) {
            translate([dikte, dikte - overlap / 2, dikte])
            cube([b, overlap , hoogte * 2]);
        } else {
            translate([dikte, dikte - overlap / 2, -dikte])
            cube([b, overlap , hoogte * 2]);
        }
    }
}

module vulPlaat() {
    translate([-(lijst + dikte * 2),- dikte, -(hoogte + dikte) ])
    cube([lijst - stijl + dikte, dikte, hoogte + dikte]);
    x1 = -(stijl + dikte);
    x2 = -(lijst + dikte * 2);
    y1 = -dikte;
    y2 = -(overlap + dikte)/ 2;
    translate([0, 0, -dikte])
    linear_extrude(height = dikte) 
    polygon([[x1, y1],[x1, y2],[x2, y1]]);
}