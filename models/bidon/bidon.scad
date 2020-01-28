

dSchroef        = 6;  // bouten waar bidon mee vast zig
dGat            = 10; // lasstuk op framebuis 
bOnder          = 41; // breedste deel van de buis
l               = 41; // vanaf schroef tot breedste deel buis
schroefAfstand  = 65; // Afstand tussen bevestigings schroeven
verlenging      = 20; // bepaald de lengte van de bidonhouder
dFrameBuis      = 35; // doorsnede framebuis / zadel
wall            = 4;  // dikte van de wanden
d               = 20; // afronding van houder

//
dFles = 65;
dSmall = 51;


//////////// Calculated ///////////////////
holes = [[verlenging                 , 0, 0]
       , [verlenging + schroefAfstand, 0, 0]];


bevestiging();
flesHouder();


module flesHouder() {

    flesVoet();

}

module flesVoet() {
    hVoet = verlenging;
    difference() {
        up(dFles / 2 + wall)
        rotate([0, 90, 0])
        difference() {
            cylinder(d=dFles + 2 * wall, h=hVoet);
            up(wall)  cylinder(d=dFles, h=hVoet);
            up(-wall) cylinder(d=dFles - 4 * wall, h=hVoet * 2);
        }
        holes();
    }
    

}

module bevestiging() {
    difference() {
        frameMount();
        holes();
    }
}

module holes() {
    for(i=holes) {
        translate(i)
            cylinder(d = dGat, h = 10, center = true);
    }
}

module frameMount() {
    steun = 20;
    
    rotate([270,0,0])
    rotate([0, 90, 0]) 
    linear_extrude(height  = schroefAfstand + verlenging * 2)
    difference() {
        bevestiging2d(wall);
        bevestiging2d(0);
        difference() {
            circle(d=steun * 10);
            circle(d=steun * 2);
        }
    }
    
}

module bevestiging2d(wall = 0) {
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

module up(h = 0) {translate([0, 0, h]) children();}

// bereken de y aan de hand van buidBreedte en lengte van vlak
function hoek() = asin((bOnder / 2) / l);
function y() = l * cos(hoek());