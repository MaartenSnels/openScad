use <maarten.scad>

hPoot = 65;
hSok = 30;
bottom = [80, 80];
top    = [100, 100];
wall = 15;
afstand = 140; 

 sok();

module hak(l = afstand, h = hSok, b = top.x) {
    sq = [h, b];
    rotate([0, -90, 0]) {
        linear_extrude(height = l, scale = .5) {
            translate([0, -sq.y/2, 0])
                square(sq);
        }
    }
}

module sok() {
    blok = [top.x, top.y, hSok] + [wall, wall, 0];
    difference() {
        union() {
            translate([-blok.x / 2 ,0 , 0])
            hak(l = afstand - wall, h = hSok, b = blok.x);
            up(hSok / 2) {
                cube(blok, center = true);
            }
        }
        up(-1) {
            poot();
        }
    }
}

module poot() {
    scale = top.x / bottom.x;
    linear_extrude(height = hPoot, scale = scale, center = false) {
        square(bottom, center = true);
    }
}