ledDiameterInner   =  5.2;      // specs 5 +/- 0.2
ledDiameterRim     =  5.8;    // specs 8.8 +/- 0.2
ledHeihght         =  8.7;    // specs 8.7 +/- 0.2, including rim
ledHeightRim       =  1;      // specs 1.0 +/- 0.2
ledDiameterOuter   =  8;
ledHolderHeight    =  3;
ledWireLengthS     =  13;     // soecs 13 +/- 0.5
ledWireLengthL     =  15;     // soecs 15 +/- 0.5
marge              =   2.5;
leds               =  60;     // aantal leds in ring
$fn                =  30;
pi                 =  3.1415;
hoogteKast         = 40;
wandDikte          = 4;
vloerDikte         = 3;
rijen              = 3;  // aantal rijen leds
vrijVanRand        = 8;
bevestinging       = 10; // paal waar bevestigingsschoerf in komt
bevestingsDiameter = 4;  // gat waar de bout in moet

// bepaal diameter van de ring
D = (rijen - 1) * (marge + ledDiameterRim) * 2 + 
    (marge + ledDiameterRim) * leds / pi;
kastBreedte = D + vrijVanRand * 2;
    
echo(D = D);
echo(kastBreedte = kastBreedte);
    
kast();


module kast() {
    vloerPlaat();
//    wanden();
    leds();
}

module leds() {

    forAllLeds() 
       translate([0, 0, ledHeightRim + vloerDikte]) 
            rotate ([180, 0, 90]) 
                led();
}



module wanden() {
    inner = kastBreedte - 2  * wandDikte;
    h = hoogteKast - vloerDikte;
    
    translate([0, 0, vloerDikte * 2])
    difference() {
        cube([kastBreedte, kastBreedte, h]);
        translate([wandDikte, wandDikte, -h / 2])
        cube([inner, inner, h * 2]);
    }
}

module vloerPlaat() {
    l = kastBreedte - bevestinging - wandDikte;
    b = wandDikte;
    h = vloerDikte;
    
    difference() {
        union() {
            cube([kastBreedte, kastBreedte, vloerDikte / 2]);
            translate([ wandDikte
                      , wandDikte
                      , vloerDikte ] / 2)
            cube([ kastBreedte - wandDikte
                 , kastBreedte - wandDikte
                 , vloerDikte / 2]);
            for(i=[[b,b,h]
                  ,[l,b,h]
                  ,[l,l,h],
                  ,[b,l,h]]) {
                translate(i)
                bevestinging();
            }
            forAllLeds() {
                translate([ledDiameterRim / 2, -ledDiameterRim / 2, vloerDikte])
                ledBridge();
            }
        }
        forAllLeds()
            translate([0, 0, - wandDikte / 2])
                cylinder(d = ledDiameterInner
                       , h = wandDikte * 2);
    }
}

module bevestinging() {
    echo (hoogteKast - vloerDikte);
    b = bevestinging;
    difference() {
        cube([b, b, hoogteKast - vloerDikte]);
        translate([b / 2, b / 2,  hoogteKast / 2])
            cylinder( d = bevestingsDiameter
                    , center = true
                    , h = hoogteKast * 2);
    }
}

module powerSupply() {
    color("red")
    translate([wandDikte, wandDikte, vloerDikte]) 
    cube([57,85,34]);
}



// voor alle leds moet je dit uitvoeren
module forAllLeds() {
    for (j = [0 : rijen - 1]) {
        d = D - j * 2 * (marge + ledDiameterInner);
        for(i = [0 : leds - 1]) {
            h = i * 360/leds;
            x = d/2 * sin(h) + kastBreedte / 2;
            y = d/2 * cos(h) + kastBreedte / 2;
            translate([x, y, 0])
            rotate([0, 0, -h])
            children();
        }
    }
}



//!hoek(20,20);
module hoek(l, h) {
        
    difference() {
        rotate([0,0,45])
        cylinder(d1 = l, d2 = 0, h = h, $fn = 4);
        translate([0, -l, -h / 2]) cube([l * 2, l * 2, h * 2]);
        translate([-l ,0, -h / 2]) cube([l * 2, l * 2, h * 2]);
    }
}

module ledBridge() {
    color("yellow")
    cube([marge / 2, ledDiameterInner, ledHeightRim * 2]);
}

//!ledHolder();
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

//!translate([0, 0, ledHeightRim + vloerDikte]) rotate ([180,0,0]) led();
module led(row, led) {
    h = ledHeihght - ledDiameterInner / 2;
    color("green")
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
        rotate([0,0,-90])
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
    d=.5;
    color("gray")
    translate([-d - 1 -d / 2, d / 2, 0])
    rotate([180, 0, 0]) {
        translate([0,0,0])
        cube([d, d, ledWireLengthS]);
        translate([1,0,0])
        cube([d, d, ledWireLengthS]);
        translate([2,0,0])
        cube([d, d, ledWireLengthL]);
        translate([3,0,0])
        cube([d, d, ledWireLengthS]);
    }
}


