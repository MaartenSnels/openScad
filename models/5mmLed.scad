ledDiameterInner =  5;      // specs 5 +/- 0.2
ledDiameterRim   =  5.8;    // specs 8.8 +/- 0.2
ledHeihght       =  8.7;    // specs 8.7 +/- 0.2, including rim
ledHeightRim     =  1;      // specs 1.0 +/- 0.2
ledDiameterOuter =  8;
ledHolderHeight  =  3;
ledWireLengthS   =  13;     // soecs 13 +/- 0.5
ledWireLengthS   =  15;     // soecs 15 +/- 0.5
marge            =   3;
leds             =  60; // aantal leds in ring
$fn              =  60;
pi               =  3.1415;

D1 = (marge + ledDiameterOuter) * leds / pi;
D2 = D1 + 2 * (marge + ledDiameterOuter);
D3 = D1 + 4 * (marge + ledDiameterOuter);

echo (D2 = D3);

houders(D1);
houders(D2);
houders(D3);

module houders(D) {
    for(i = [0 : leds-1]) {
        h = i * 360/leds;
        x = D/2 * sin(h);
        y = D/2 * cos(h);
        translate([x,y,0]) rotate([0,0,-h]) ledHolder();
    }
}

module leds(D) {
    for(i = [0 : leds-1]) {
        h = i * 360/leds;
        x = D/2 * sin(h);
        y = D/2 * cos(h);
        translate([x,y,0]) rotate([0,0,-h]) led();
    }
}

module ledHolder() {
    difference() {
        cylinder(  d=ledDiameterOuter
                 , h = ledHolderHeight
                 , center = true);
        translate([0,0,-ledHolderHeight / 4])
        cylinder(  d = ledDiameterInner
                 , h = ledHolderHeight
                 , center = true);
        translate([0,0,ledHolderHeight / 2])
        cylinder(  d = ledDiameterRim
                 , h = ledHolderHeight
                 , center = true);
        
        
        
    }
}

module led() {
    h = ledHeihght - ledDiameterInner / 2;
    difference() {
        union() {
            translate([0,0,h])
            sphere(d = ledDiameterInner);
            cylinder(  d = ledDiameterInner
                     , h = h
                     , center = false);
            cylinder(  d = ledDiameterRim
                     , h = ledHeightRim
                     , center = false);
        }
        translate([-ledDiameterInner / 2
                  , ledDiameterInner / 2
                  , -ledHeightRim / 2])
        cube([ledDiameterInner
            , ledHeightRim 
            , ledHeightRim * 2]);
    }
    wires();
}

module wires() {


}


