use <maarten.scad>

rows = 8;
cols = 8;
matrix = [65.2, 65.2];
randen = [1, 1];
led = [5, 5, 1];
margin = .2;
grondVlak = .5;
wall = 2;
ledBuffer = [1.3, 1.3, 4];



tussenX = (matrix.x - randen.x * 2 - cols * led.x) / (cols - 1);
tussenY = (matrix.y - randen.y * 2 - rows * led.y) / (rows - 1);
echo(tussenX=tussenX);
echo(tussenY=tussenY);


// %leds();
ledHouder();


module ledHouder() {
    delta = (wall + margin) * 2;
    grond = [matrix.x + delta, matrix.y + delta, grondVlak];
    translate = [-delta, -delta, 0] / 2;

    difference() {
        tX = randen.x - (tussenX - ledBuffer.x) / 2 - ledBuffer.x;
        tY = randen.y - (tussenY - ledBuffer.y) / 2 - ledBuffer.y;
        union() {
            translate(translate) {
                cube(grond);
                up(grond.z)
                    box(size = [grond.x, grond.y, ledBuffer.z + 4], w = wall);
            }
            
            for(r = [1 : rows - 1]) {
                translate([ -margin
                          , tX +(led.x + tussenX) * r
                          , grond.z])
                    cube([matrix.x + margin * 2
                        , ledBuffer.y
                        , ledBuffer.z]);
            }
            for(c = [1 : cols - 1]) {
                translate([ tY +(led.y + tussenY) * c
                          , -margin
                          , grond.z])
                    cube([ ledBuffer.x
                         , matrix.y + margin * 2
                         , ledBuffer.z]);
}
        }
        cutOut = [led.x +tussenX - ledBuffer.x + margin
                , ledBuffer.y + margin * 2
                , 10];
        up = grondVlak + 1.5;
        translate([   -margin
                    , tX + led.x + tussenX - margin
                    , up])
            cube(cutOut);
        translate([matrix.x - cutOut.x + margin 
                 , tX +(led.x + tussenX) * (rows - 1) - margin
                 , up])
            cube(cutOut);
    }
}

module connect(male = true) {
    
}




module leds() {
    
    for( r = [0 : rows - 1]) {
        for( c = [0 : cols - 1]) {
            translate([ randen.x + c * (led.x + tussenX)
                      , randen.y + r * (led.y + tussenY)
                      , grondVlak])
                color("yellow") led();
        }
    }
}

module led() {
    cube(led);
}