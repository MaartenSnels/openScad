

/*
    box builder for arduino nano screwternumal project
    

*/

pcb = [36.2, 53.0, 1.6];
usb = [7, 10 ,4];
terminal = [(32 / 9), 6.8, 8.8];
holes =[ [12, 2 , 2]
       , [24, 2 , 2]
       , [11, 50, 2]
       , [25, 50, 2]]; // holes in pcb, x, y, diam

box();

module box() {
    h = 25;
    box = [pcb.x * 2, pcb.y * 2, h];
    verkleining = .05;
    difference() {
        minkowski() {
            cube(box);
            cylinder(d=3, h=.1, $fn=60);
        }
        translate(box * verkleining)
            cube(box * (1 - 2 * verkleining));
        translate([-box.x / 2, -box.y / 2, box.z * (1 - verkleining - 0.01)])
            cube(box * 2);
    }
    translate(box/4) 
        %arduino();
}

module arduino() {
    pcb();
    terminals();
    usb();
}

module usb() {
    translate([(pcb.x - usb.x) / 2, pcb.y - usb.y, pcb.z])
    difference() {
        cube(usb);
        translate([-1, usb.y - 2, -usb.z / 2])
            cube([2, 2, usb.z]);
        translate([usb.x - 1, usb.y - 2, -usb.z / 2])
            cube([2, 4, usb.z]);
    }
}

module pcb() {
    difference() {
        color("green") cube(pcb);
        for(i=holes) {
            translate([i.x, i.y, pcb.z / 2])
                cylinder(d=i.z, center=true, h=pcb.z * 2, $fn=60);
        }
    }
}

module terminals() {
    m = 1.5;  //afstand tussne rand pcb en terminals
    translate([pcb.x, 0, pcb.z])
    rotate([0,0,90])
    for (i=[0:14]) {
        translate([terminal.x * i, m, 0]) 
            terminal();
        translate([terminal.x * i, pcb.x - m, 0]) 
            mirror([0,1,0])
                terminal();
    }
}

module terminal() {
   pinD = 1;
   pinH = 4;
   color("yellow")
    difference() {
        m = 1;
        cutOut = [terminal.x - m, 2 + m, terminal.z / 2]; 
        d = 2.8;
        h = 3;
        cube(terminal, center=false);
        translate([terminal.x / 2, terminal.y / 2, terminal.z - h])
        cylinder(d = d, h = h * 2, center = false, $fn = 60);
        translate([m / 2, -m, m])
        cube(cutOut);
    }
    translate([terminal.x  / 2, terminal.y / 2, -pinH])
    cylinder(d = pinD, h = pinH, center = false, $fn = 60);
    
}