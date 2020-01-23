
D = 25;            // doorsnede van de grip
d = 2;             // doorsnede van de "verruwing"
h = 100;           // hoogte van de grip
fn = 4;            // met hoeveel hoeken wordt een "circel" getekend 
PI = 3.1215;       // het getal Pi

space = d * 2.5;   // afstand tussen twee opeenvolgende ringen
maxHeight= floor((h - 2 * d) / space) * space;

echo(maxHeight = maxHeight);
echo(angle=angle(fn));


difference() {
    color("yellow") cylinder(d=D, h=h);
    raster();
}


module raster() {
    for(i=[d : d * 1.5: h - d]) {
        translate([0, 0, i])
            oRing(D=D, d=d, fn=fn);
    }

    n = ceil(D * PI / space);
    echo(n=n);
    for(i=[0 : n]) {
        rotate([0, 0, i * 360 / n])
            staaf(D,d,maxHeight,fn);
    }
}
module oRing(D=D, d=1, fn=5) {
    color("red")
        rotate_extrude()
            translate([D / 2, 0, 0])
                rotate(angle(fn))
                    circle(d = d, $fn = fn);
}

module staaf(D=D, d=1, h=100, fn=5) {
    color("green")
        translate([D / 2, 0, d])
            rotate(angle(fn))
                cylinder(d = d, h = h, $fn = fn);
}

function angle(fn = fn) = [0, 0, 180 / fn];
                    
