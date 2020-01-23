use <threads.scad>
hoek = 90;
dikte = 3;

stijl = [20, 20.5, 400];//
lijst = [10, 34.5, 300];//
hoogte = 200;           // hoogte van draaischijf
geleiderGat = 8;        // groote van geleidergat
margin = .1;            //
rotate = 60;            // hoe ver staat deurtje open in tekening

// berekende waarden
lijstMinStijl = lijst.y - stijl.y;
delta = lijstMinStijl / sin(hoek);
openingsHoekGeleider = hoek * 0.70;
hoogteGeleider = hoogte * 0.9;
dPin = geleiderGat  - margin;

difference() {
    plaat();
    geleider();
}
hg = hoogteGeleider + dPin / 2;
%color("blue") 
    rotate([270 + atan(hg / (lijst.y + 15)), 0, 0])
        translate([-stijl.x, 0, hg])
            pin();

%color("green") stijl();
%color("yellow") lijst();



module plaat() {
    
    rotate([rotate, 0, 0])
        difference() {
            union() {
                translate([dikte + margin, lijst.y, 0])
                    rotate([0, -90, 0])
                        rotate_extrude(angle = hoek, $fn = 60)
                            square([hoogte,dikte]);
            plaatBevestiging();
        }
    }
}
module geleider() {
    angle = openingsHoekGeleider;
    h = hoogteGeleider;
    
    rotate([rotate, 0, 0])
    rotate([0 , -90,  0])
    translate([0, 0, -h/2]) 
    rotate([0, 0, (hoek - angle) / 2]) {
        rotate_extrude(angle = angle, $fn = 60)
            translate([h, 0, 0])
                square([geleiderGat, h]);
            translate([h + geleiderGat / 2, 0, 0])
                cylinder(d=geleiderGat, h = h, $fn = 60);
            rotate([0, 0, angle])
                translate([h + geleiderGat / 2, 0, 0])
                    cylinder(d=geleiderGat, h = h, $fn = 60);
    }
    
}

module pin() {
    pitch = 1.5;
    h=stijl.x * 1.5;
    rotate([0, 90, 0])
//    cylinder(d = dPin, $fn=60, h=h);
    metric_thread(diameter = dPin, length = h, pitch = pitch); 
}


module plaatBevestiging() {
    difference() {
        translate([dikte, lijst.y / 2, hoogte / 4])
        cube([lijst.x, lijst.y / 2 + dikte, hoogte / 2]);
        cube(lijst);
        translate([lijst.x + dikte, lijst.y * .75, hoogte * .35])
            schroefGat();
        translate([lijst.x + dikte, lijst.y * .75, hoogte * .65])
            schroefGat();
    }
}

module schroefGat() {
#translate([0, 0, 0])
    rotate([0, -90, 0])
        linear_extrude(height=dikte, scale=0.5)
            circle(d=geleiderGat, $fn=60);
    
}

module stijl() {
    translate([-stijl.x, 0 , 0])
        cube (stijl);
}

module lijst() {
    rotate([rotate, 0, 0])
    union() {
        
        translate([margin, 0, 0])
        cube(lijst);
        translate([margin, 0, lijst.x])
            rotate([0, 90, 0])
                cube(lijst);
        translate([margin, 0, lijst.z])
            rotate([0, 90, 0])
                cube(lijst);
    }
}