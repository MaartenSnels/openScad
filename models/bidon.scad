

dSchroef = 6;        // bouten waar bidon mee vast zig
bOnder = 51;         // breedste deel van de buis
l=41;                // vanaf schroef tot breedste deel buis
schroefAfstand = 10; // Afstand tussen bevestigings schroeven
dFrameBuis = 35;     // doorsnede framebuis / zadel



buis();

module buis() {
wall = 3;
d=20;
    linear_extrude(height  = schroefAfstand)
    difference() {
        buis2d(wall);
        buis2d(0);
        translate([-bOnder, y() - d / 2, 0])
            #square([bOnder, y()] * 2);
    }
    
}



module buis2d(wall = 0) {
    d = 20;
    x = bOnder / 2;
    pos = [[ 0, d / 2, 0]
         , [-x, y()    , 0]
         , [ x, y()    , 0]];

    offset(wall)
        hull() {
            for(i=pos) {
                translate(i)
                    circle(d=d);
            }
        }

}

// bereken de y aan de hand van buidBreedte en lengte van vlak
function y() = l * cos(asin((bOnder / 2) / l));