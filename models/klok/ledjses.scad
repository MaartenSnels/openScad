use <maarten.scad>

box = [40,40,10];       // afmeting van de box
leds = 12;               // aantal leds
wall = 2;
dLed = 5;

klok();


module klok() {
    difference() {
        translate([box.x, box.y, 0] / -2)
            roundedBox(  size   = box
                       , w      = wall
                       , radius = 4
                       , bottom = true);
        placeInCube(number = leds
                   , d = min(box.x, box.y) - wall * 4 - dLed) {
            led(d = dLed);
        }
    }
}

module led(d=5, h = 10,  fn=60) {
    cylinder(d=d, $fn=fn, center = true, h = h);
}

module ledHolder(d = 5) {
    
    
}


module placeInCube(d=100, number = 100) {
    for(i=[0:number-1]) {
        tr(t=[d, 0, 0] / 2, r=[0, 0, i * 360 / number]) children();
    }
}