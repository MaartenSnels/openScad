/*
    plintlegger
    
    
    leg plinten op de volgende maniet

    in eetste instantie alleen nog maar voor standaard cubus
    
*/


use <plint.scad>
use <rcube.scad>

plintH = 2;
plintB = 20;
extra  = 5;
wall   = 2;

// 7 40 25 17 65 57 10
// rechts draaiende opdek deur, linker kozijn



/*
                  5 
         ----------------
       6 |              |
                        |
                        | 4
                        |
                 -------    
                 |    3
      0  |       | 2
         --------
            1


    Parameter d in lrd are the lenghts of 0 to 6
    lrd stand for Left side of Right turning door. If you see the
    hinge and the hing is right you have a right turning door. From this door
    this is the left door post
*/
function lrd(d=[7, 40, 25, 17, 65, 57, 10], endStops=false) =
[     
   [ endStops ? 0 : (d[0] + plintB), -90, [0                           , 0            ]]
 , [ d[1] + extra + wall           ,   0, [d[0]                        , -wall        ]]
 , [ d[2] + plintB                 ,  90, [d[0] + plintB               , d[1]         ]]
 , [ d[3] + plintB                 ,   0, [-d[2] + d[0]                , d[1]         ]]
 , [ d[4] + plintB + extra         ,  90, [-d[2] + d[0] + plintB       , d[1] + d[3]  ]]
 , [ d[5] + plintB + extra         , 180, [d[0] - d[2] - d[4]          , d[5] + plintB]]
 , [ endStops ? 0 : (d[6] + plintB), -90, [d[0] - d[2] - d[4] - plintB , 0            ]]
] ;

plint_lrdOpdek(endStops=false);       
translate([150, 0, 0])
plint_lrdStomp();       

module plint_lrdStomp(d=[7, 57, 90, 57, 10], endStops = false) {
    plintLegger(lrd([d[0], d[1], 0, 0, d[2], d[3], d[4]], endStops));
}

// linker kant, rechts draaiend deur opdek
module plint_lrdOpdek(d=[7, 40, 25, 17, 65, 57, 10], endStops = false) {
    plintLegger(lrd(d, endStops), rounding=3);
//    translate([0, -9, 0])  // TODO -9 is afhankelijk van wall en overlapp
//    endStop(left=false);
//    translate([d[0] - d[2] - d[4] + d[6], 0, 0]) // todo is afhankelijk van bottom
//    rotate([0, 0, 180])
//    endStop(left=true);
}

module plintLegger(path, rounding=2) {
    echo(path=path);
    for(i = path) {
        echo(i[2].x, i[2].y);
        translate([i[2].x, i[2].y, 0])  
        rotate([0, 0, i[1]])
        plintPerMM(i[0], rounding);
    }
}

// Zorg ervoor dat beide zijkanten dezelfde afronding hebben, anders dan 
// gaat het mis bij het samenvoegen
module plintPerMM(lenght = 100, rounding=2) {
    size = [plintB * 2, lenght, plintH * 2];
    
    if (lenght > 0)
    translate([0, lenght / 2, 0])
    difference() {
        rcube(shape = size, d=rounding, center = true);
        translate([0, 0, -plintH*2])
        cube(size * 2, center=true);
        translate([-plintB * 2, 0, plintH])
        cube(size * 2, center=true);
    }
}
