klokDiameter        = 500;   // diameter van klok, buitenste ring
aantalLeds          = 60;    // aantal leds per ring, standaard 60 
klokTussenruimte    = 25;    // tussenruimte tussen de ringen
ledsPerSegment      = 3;    // zorg dat het te printen valt  
                             // (segmenten *ledsPerSegment = aantalLEds)
aantalRingen        = 3;     // uren, minuten, seconden. Standaard 3

dikteVerbinding     = 2;

// de led, klein printplaatje van de ws2812
wDiameterOut        = 14;
wDiameterPcb        = 11;
wDiameterIn         = 9;
wHeight             = 2;

// algemeen
PI                  = 3.1415; // Get getal PI        

ringen();

module ringen() {
echo(aantalLeds_klok = aantalRingen * aantalLeds);
    for (i = [0 : aantalRingen - 1]) {
        leds(i);
    }
    
}

module leds(ring) {
    leds = min(aantalLeds, ledsPerSegment);
    if (aantalLeds > ledsPerSegment) {
        eindeSegment();
    }
    echo (leds = leds);
    ledsSegment = min(aantalLeds, ledsPerSegment);
    echo(aantalLeds_segment = aantalRingen * ledsSegment);
    for (i = [0 : leds - 1]) {
        translate(pos(i, ring)) {
            rotate([0, 0, -i / aantalLeds * 360]){
                led(ring);
            }
        }
    }
    
}

//!eindeSegment();
module eindeSegment() {
    lengte = (aantalRingen - 1) * klokTussenruimte;
    rotate([0, 0, -(ledsPerSegment - 0.5) * 360 / aantalLeds]) {
        translate([-dikteVerbinding / 2, straal(0) - lengte, 0]) {
            cube([dikteVerbinding, lengte, dikteVerbinding]);
        }
    }
}

//!boogHoek(1);
module boogHoek(ring) {
    r = straal(ring);
    segmenten = 360;
    hoek = 360 / aantalLeds;
    dx = r * sin(hoek);
    dy = r * cos(hoek);
    
    difference() {
        translate([0, dikteVerbinding / 2 - r, 0]) {
            linear_extrude(dikteVerbinding) {
                difference() {
                    circle(r = r                  , $fn=segmenten);
                    circle(r = r - dikteVerbinding, $fn=segmenten);
                    difference() {
                        square([2.5 * r, 2 * r], true);
                        polygon([[0, 0]
                              ,  [0, 2 * r]
                              ,  [2 * dx, 2 * dy]]);
                    }
                }
            }
        }
        translate([0, 0, dikteVerbinding / 2]) {
            rondje();
        }
        translate([dx, dy - r, dikteVerbinding / 2]) {
            rondje();
        }
    }
}
module rondje() {
    cylinder(center=true
           , h = dikteVerbinding * 2
           , d = wDiameterOut
           , $fn=30);
}
//!ringVerbinding(1);
module ringVerbinding1(ring) {
    if (ring >0) {
         difference() {
            translate([-dikteVerbinding / 2, 0, 0]) {
                cube([dikteVerbinding
                    , klokTussenruimte
                    , dikteVerbinding]);
            }
            translate([0, 0, dikteVerbinding / 2]) {
                rondje();
            }
            translate([0, klokTussenruimte, dikteVerbinding / 2]) {
                rondje();
            }
        }
    
    } 

}

module ringVerbinding2(ring) {
    hoek = 360 / aantalLeds;
    dx = straal(ring) * cos(hoek);
    dy = straal(ring) * sin(hoek);
    p1 = [dx, dy];
    p2 = [straal(ring) + klokTussenruimte, 0];
    
    l = lengte(p1, p2);
    h = hoek(p1, p2);
    
    if (ring > 0) {
        
        rotate([ 0, 0, 90 - hoek + h]) {
            verbindingSchuin(l);
        }
    }
}

module ringVerbinding3(ring) {
    hoek = 360 / aantalLeds;
    dx = straal(ring) * cos(hoek);
    dy = straal(ring) * sin(hoek);
    p1 = [dx, dy];
    p2 = [straal(ring) - klokTussenruimte, 0];
    
    l = lengte(p1, p2);
    h = hoek(p1, p2);
    
    if (ring < aantalRingen - 1) {
        
        rotate([ 0, 0, 270 + -hoek + h]) {
            verbindingSchuin(l);
        }
    }
}

module verbindingSchuin(lengte) {
    difference() {
        translate([0, -dikteVerbinding / 2, 0]) {
            cube([lengte, dikteVerbinding, dikteVerbinding]);
        }
        translate([0, 0, dikteVerbinding / 2]) {
            rondje();
        }
        translate([lengte, 0, dikteVerbinding / 2]) {
            rondje();
        }
    }
}

//!verbinding(1) ;
module verbinding(ring) {
    boogHoek(ring);
    ringVerbinding1(ring);
    ringVerbinding2(ring);
    ringVerbinding3(ring);
}


//!led(0);
module led(ring) {
    difference() {
        linear_extrude(height = wHeight) {
            difference() {
                circle(d=wDiameterOut, $fn=30);
                circle(d=wDiameterIn , $fn=30);
            }
        }
        translate([0,0,wHeight / 2]) {
            linear_extrude(height = wHeight) {
                difference() {
                    circle(d=wDiameterPcb, $fn=30);
                }
            }
        }
    }
    verbinding(ring);
}

function straal(ring) = ((klokDiameter - wDiameterOut) / 2  - ring * klokTussenruimte);

function pos(lampje, ring) = 
    [straal(ring) *  sin(lampje / aantalLeds * 360) , 
     straal(ring) *  cos(lampje / aantalLeds * 360) ,
     0];

function lengte(p1, p2) = 
    sqrt(
        pow(p1[0] - p2[0], 2) + 
        pow(p1[1] - p2[1], 2)
    );

function hoek(p1, p2) = 
    atan( (p1[1] - p2[1]) / (p1[0] - p2[0]));

function meerdereSegmenten() = aantalLeds > ledsPerSegment;