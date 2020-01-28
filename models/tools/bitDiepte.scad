

hTotaal   = 16;  // gedeelte van bitje dat uit bithouder steekt
dBout     = 8;   // gat om hex te vorm
gatDiepte = 3.5; // hoever steekt het bitje in de schroef 
diepte    = 1.5;   // hoever mag de schroef het hout in, NEG is boven het hout
kraag     = 5;   // uitstekende hex gedeelte van bitje

// berekende waarden
h = hTotaal - diepte - gatDiepte;


bit();

module bit() {
    dOuter = dBout * 3;
    difference () {
        shell(d = dOuter);
        translate([0, 0, kraag]) 
            shell(d = dBout * 2);
        hex();
        translate([0, 0, dOuter / 3]) 
            rounder(d = dOuter);
    }
}

module shell(d = 10) {
    cylinder(d=d, h = h, $fn = 60); 
}

module hex() {
    cylinder(d=dBout, h = h * 3, $fn = 6, center = true); 
}

module rounder(d = 10) {
    c = [d, d, d] * 1.1;
    difference() {
        translate([0, 0, -c.z / 2])
        cube(c, center = true);
        sphere(d=d, $fn = 60);
    }
}

