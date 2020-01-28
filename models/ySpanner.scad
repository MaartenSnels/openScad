/*
 * spanner voor mijn printer.
 * TODO spanner moet moer gat aan onderkant hebben
 */


$fn=50;

doorgangH      = 7.5;
doorgangB      = 8;
tussenH        = 12;
tussenB        = 10;
lengte         = 50;
hoogteGat      = 20;  // hoogte gat t.o.v. midden van Y
gatLager       = 5;
moerLager      = 9.5;
gatVerbinding  = 4;
moerVerbinding = 7;
marge          = 0.5; //  marge tussen endstop en spanplaten

// berekend
hoogteLager     =  doorgangH + tussenH / 2 + hoogteGat;
diameterHouder  = (hoogteLager - 2 * doorgangH - tussenH) * 2;
breedte         = 2 * doorgangB + tussenB;
hoogte          = 2 * doorgangH + tussenH;
dikte           = gatVerbinding * 3;  // dikte eindstop
endCapHoogte    = 10;

montageGat1     = [lengte - dikte / 2
                 , doorgangB / 2
                 , 0];
montageGat2     = [lengte - dikte / 2
                 , breedte - doorgangB / 2
                 , 0];
                 
                 


//------------- print info ----------------//
echo(hoogteLager = hoogteLager);
echo(diameterHouder = diameterHouder);
//------------- Render --------------------//
schuif();
translate([0, tussenB + doorgangB, 0]) schuif();
endstop();
endCap();

module endCap() {
    extra = 2; // dikte van bodem endCap
    
    color("orange")
    translate([lengte  / 2, breedte / 2, hoogte/ 2])
    rotate([0, 90, 0])
    difference() {
        union() {
            cylinder(d=moerLager,
                     h = endCapHoogte);
            cylinder(d=moerLager + extra,
                     h = extra);
            }
            translate([0,0,extra])
            cylinder(d=gatLager + marge,
                     h = endCapHoogte);
        }
}

module endstop() {
    bBlok1 = tussenB - 2 * marge;
    hBlok1 = 2 * doorgangH + tussenH;
    bBlok2 = 2 * doorgangB + tussenB;
    hBlok2 = tussenH - 2 * marge;
    
    color("green") {
        difference() {
            union() {
                translate([lengte - dikte
                         , doorgangB + marge
                         , 0])
                cube([dikte, bBlok1, hBlok1]);
                translate([lengte - dikte
                         , 0
                         , doorgangH + marge])
                cube([dikte, bBlok2, hBlok2]);
            }
            stelGat();
            translate(montageGat1) montageGat();
            translate(montageGat2) montageGat();
        }
    }
}

module stelGat() {
    translate([lengte - dikte / 2, breedte / 2, hoogte / 2])
    rotate([0, 90, 0]) {
        translate([0, 0, dikte / 2])
        cylinder(d = gatLager
               , h = dikte
               , center=true);
        translate([0, 0, -dikte / 2])
        cylinder(d = moerLager
               , h = dikte
               , center=true
               , $fn=6);
    }
}

module montageGat() {
    union() {
        translate([0, 0, hoogte / 2 + doorgangH / 2])
        cylinder(d = gatVerbinding
               , h = hoogte
               , center=true);
        translate([0, 0, -hoogte / 2 + doorgangH/ 2])
        cylinder(d = moerVerbinding
               , h = hoogte
               , center=true
               , $fn = 6);
    }
}


module staaf() {
    cube([lengte, doorgangB, doorgangH]);
}

module schuif() {
    color("red") {
        difference() {
            union() {
                staaf();
                translate([0, 0, tussenH + doorgangH])
                    staaf();
                translate([0, doorgangB, hoogteLager])
                rotate([90, 90, 0])
                linear_extrude(height=doorgangB)
                lagerHouder2d();
            }
            translate(montageGat1) montageGat();
        }
    }
}

module lagerHouder2d() {
    difference() {
        union() {
            circle(d = diameterHouder
                 , center = true);
            translate([0, -diameterHouder / 2, 0])
            square([hoogteLager, diameterHouder * 1.5]);
        }
        circle(d=gatLager
               , center = true);
        translate([0, diameterHouder, 0])
        circle(d=diameterHouder
               , center = true);
        translate([hoogteLager - tussenH/2 - doorgangH
                 , tussenH / 2
                 , 0])
        circle(d=tussenH);
        translate([hoogteLager - tussenH - doorgangH
        , tussenH/2
        , 0])
        square([tussenH, diameterHouder]);
    }
}