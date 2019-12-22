$fn = 60;
kroonSteen = [5.8, 16.7, 7.7];
schroef = [5.15, 1.3, 5.5];
kroonSteenTussen = 2.4;


// kroonSteenBlok();
// kroonSteenSchroeven();
// kroonSteen();
kroonStenen(3);

module kroonStenen(aantal = 2) {
    t = kroonSteen.x + kroonSteenTussen;
    for(i = [0 : aantal - 1]) {
        translate([t * i, 0, 0])
            kroonSteen();
    }
    for (i = [1 : aantal - 1]) {
        translate([t * i - kroonSteenTussen / 2, kroonSteen.y / 2, 0]) {
            difference() {
                cylinder(d = kroonSteenTussen + 1.5, h = kroonSteen.z, center = false);
                cylinder(d = kroonSteenTussen, h = kroonSteen.z * 3, center = true);
            }
        }
    }
}

module kroonSteen() {
    kroonSteenBlok();
    translate([kroonSteen.x / 2, kroonSteen.y / 2, kroonSteen.z])
    kroonSteenSchroeven();
}
module kroonSteenBlok() {
    r = kroonSteen.x / 2;
    translate([0, 0, r])
        cube(kroonSteen - [0, 0, r]);
    translate([r, 0, r])
        rotate([-90, 0, 0])
            cylinder(r = r, h=kroonSteen.y, center = false);
}

module kroonSteenSchroeven() {
    tr = (schroef.x + schroef.y) / 2;
    for (i = [-1,1]){
        translate([0, tr * i, schroef.z / 2])
        difference() {
            cylinder(d = schroef.x, h = schroef.z, center = true); 
            cylinder(d = schroef.x - 1.5, h = schroef.z + 1, center = true); 
        }
    }

}