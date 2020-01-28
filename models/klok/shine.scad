/*

    Drie onderdelen: 
    1   buitenkand + lijst voor afwerken en vasthouden van 
        de glasplaat
    2   ring voor leds
    3   bodem waar spiegel op bevestigd is, in combinatie met
        houder voor electronica, knoppen etc.
        
   TODO
   -    gaten voor knoppen in buitenkant
   -    gaten voor stroomdoorvoer in buitenkant
   -    bevestingingen buitenkant
   -    gat voor led settings module
   -    maak componenten bibliotheek
   -    hou rekening met de dikte van de galsplaat


    Aandacht
    -   spiegel moet zo dicht mogelijk onder de leds
    -   glasplaat moet zo dicht mogelijk bij de leds

*/


use <maarten.scad>

ledsPerMeter = 144;    // aantal leds per meter strip
wall = 2;              // dikte van de buitenkant
fn = 60;               // uit hoeveel segmenten bestaan de circles
mirror = [150,150];    // spiegel onder leds
klok = [200, 200, 40]; // afmetingne van de klok
glaslat = 6;           // vasthouden glasplaat
glasplaat = 5;         // dikte van de glasplaat
spiegelDikte = 2;


// verschillende hoogtes
hoogteKlok = klok.z; // hoogte van de klok. Bodem zit er onder
hoogteBodem = wall;  //
hoogteRing = 15;     // hoogte van de buitenste ring, moet kleinder zijn
                     // omdat er licht onderuit moet komen. Maar moet wel
                     // groter dan de led strip zijn
hoogteMirror = wall * 2; // hoogte van spiegelplaat
topRing = klok.z - hoogteRing - wall - glasplaat; // bevenste punt ring
topMirror = topRing - spiegelDikte;

// TODO haal uit componenten bibliotheen
ledDisplay    = [15, 62, 8];   // voorlopige ametingen led cijfer displa
ledDisplayPCB = [15, 83, 1.5]; // voorlopige ametingen led cijfer displa
arduino       = [55, 35, 13];  // voorlopige afmetingen arduino module

echo (ledsPerMeter=ledsPerMeter, straal=straal());

//////////// render ///////////////
buiten();
color("yellow") bodem();
ledRing();
color("silver") spiegel();
//////// ONDERDELEN DIE IN DE CLOK MOTEN
%ledDisplay();
%arduino();

module buiten() {
    up(klok.z/2)
    difference() {
         box(klok,w = wall, top = true, center = true);
        cube([klok.x - (wall + glaslat) * 2
            , klok.y - (wall + glaslat) * 2
            , klok.z * 2], center = true);
    }

}

module bodem() {
    up(- wall / 2)
        cube([klok.x
            , klok.y
            , hoogteBodem], center = true);
}

module spiegel() {
    echo (up=topMirror); 
    up(topMirror - hoogteMirror)
    box([mirror.x, mirror.y, hoogteMirror]
        , w = wall
        , bottom = true
        , center = true);
}

module ledRing() {
    up(topRing) 
        ring(straal() , hoogteRing, wall, fn = fn);
}

module ledDisplay() {
    translate([ klok.x / 2 - ledDisplay.x - wall * 2 - glaslat
              , -wall * 2 - glaslat
              , klok.z - ledDisplay.z - wall * 2])
    union() {
        color("red") 
            cube(ledDisplay);
        color("red") 
            translate([ 0
                      , (ledDisplay.y - ledDisplayPCB.y) / 2
                      , -ledDisplayPCB.z])
                cube(ledDisplayPCB);
    } 
}

module arduino() {
    translate([  klok.x / 2 - arduino.x - wall * 2
              , -klok.y / 2 + wall * 2
              , klok.z - arduino.z - wall * 2])
    color("green") cube(arduino);
}

module rtc() {
}







function straal(lpm = ledsPerMeter) = ceil((60 / lpm) / 3.1415 * 1000);