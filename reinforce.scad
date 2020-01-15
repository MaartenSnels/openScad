/*
    make reinforcement axis in a open frame.
*/

d=[210,100,5];
width = 5;
t=[0, d.y + 10, 0];

// standaard, geen afroding
translate(t * 0) reinforceX(d=d, width=width);
// afronding
translate(t * 1) reinforceX(d=d, width=width, radius = 5);
// xOnly, geen afronding
translate(t * 2) reinforceX(d=d, width=width, xOnly=true);
// xOnly, afronding (doet het nog niet)
translate(t * 3) reinforceX(d=d, width=width, xOnly=true, radius = 5);


module reinforceX(d =[200, 100, 5], width=2, xOnly=false, radius = 0) {
    if (radius <= 0) {
        __X(d=d, width=width, xOnly =  xOnly);
    } else if (xOnly) {
        // TODO hier moet nog een oplossing voor worden verzonnen
        __X(d=d, width=width, xOnly =  xOnly);
    } else {
        __cutOut(d=d, width=width, xOnly =  xOnly, radius=radius);
    }

}

module __X(d =[200, 100, 5], width=2, xOnly=false) {

    if (!xOnly)
    difference() {
        cube(d);
        translate([width, width, -d.z / 2])
        cube ([d.x - width * 2, d.y - width * 2, d.z * 2]);
    }
    __balk(d, width);
}

module __balk(d =[200, 100, 2], width = 2) {
    hoek=atan(d.y / d.x);
    l = sqrt(d.x*d.x + d.y*d.y);

    difference() {
        union() {
            rotate([0, 0, hoek])
            translate([0, -width / 2, 0])
            cube([l, width ,d.z]);
            
            translate([0, d.y, 0])
            rotate([0, 0, -hoek])
            translate([0, -width / 2, 0])
            cube([l, width ,d.z]);
        }
        difference() {
            translate(-d/2)
            cube(d*2);
            cube(d);
        }
    }
}
    


module __cutOut(d =[200, 100, 2], width=2, radius = 2, xOnly = false) {
    
    /*
        x
     ====>
    ||
    || y
    \/ 
    
    
     0   ------------------- 3          H0 = atan (d.x / d.y)
        |\H2            H2/|            H1 = 180 - 2 * Hoek 1    
        | \              / |            H2 = atan (d.y / d.x)
        |H0\            /  |            h3 = 180 - 2 * Hoek 3
        |   \    D3    /   |
        |    \        /    |   
        |     \      /     |   
        |      \    /      |   
        |       \ 3/       |   
        |  D0  H1\/H1  D2  |   
        |        /\        |   
        |       /H3\       |
        |      /    \      |
        |     /      \     |
        |    /        \    |
        |   /   D0     \   |
        |H0/            \H0|
        | /              \ |
        |/H2            H2\|
     1  |------------------|  2
    
        
      H0   
        |\
        | \         Aangeven van de hoekenpinten: D1H1 etc 
        |  \ 
        |   \    
        |    \   
        |     \ 
        |      \ 
        |       \ 
        |  D?    \  H2
        |        /
        |       /
        |      /
        |     / 
        |    /  
        |   /   
        |  /    
        | /     
        |/     
    H1 |
    
        
    
    
    
    */


    // de hoeken
    H = [atan(d.x / d.y)
       , 180 - 2 * atan(d.x / d.y)
       , atan(d.y / d.x)
       , 180 - 2 * atan(d.y / d.x)];
    
    // de deltas per hoek
    dd = [ [width                    , deltaBuiten(width, H[0])]
         , [deltaBinnen(width, H[1]) , 0                          ]
         , [deltaBuiten(width, H[2]) , width                      ]
         , [0                        , deltaBinnen(width, H[3])]];
    
    
    // de punten
    D  = [  [[0  , 0  ], [0  , d.y], [d.x, d.y]/2 ]
          , [[0  , d.y], [d.x, d.y], [d.x, d.y]/2 ]
          , [[d.x, d.y], [d.x, 0  ], [d.x, d.y]/2 ]
          , [[d.x, 0  ], [0  , 0  ], [d.x, d.y]/2 ]];
          
    // de delta's
    DD = [  [[ dd[0].x,  dd[0].y], [ dd[0].x, -dd[0].y], [-dd[1].x, -dd[1].y]]
          , [[ dd[2].x, -dd[2].y], [-dd[2].x, -dd[2].y], [ dd[3].x,  dd[3].y]]
          , [[-dd[0].x, -dd[0].y], [-dd[0].x,  dd[0].y], [ dd[1].x,  dd[1].y]]
          , [[-dd[2].x,  dd[2].y], [ dd[2].x,  dd[2].y], [-dd[3].x, -dd[3].y]]];
    

    // hulpvariabelen voor het bepalen van middelpunt van de cirkel.
    // l = lengten van hoekpunt naar brandpunt van cirkel
    l = [radius / sin(H[0] / 2)
       , radius / sin(H[1] / 2)
       , radius / sin(H[2] / 2)
       , radius / sin(H[3] / 2)];
    
    r =  [[l[0] * sin(H[0] / 2), l[0] * cos(H[0] / 2)] 
        , [l[2] * cos(H[2] / 2), l[2] * sin(H[2] / 2)]];
    
    // de deltas voor de afronding per driehoek 
    R = [[[ r[0].x,  r[0].y], [ r[0].x, -r[0].y], [-l[1],  0   ]]
       , [[ r[1].x, -r[1].y], [-r[1].x, -r[1].y], [ 0   ,  l[3]]]
       , [[-r[0].x, -r[0].y], [-r[0].x,  r[0].y], [ l[1],  0   ]]
       , [[-r[1].x,  r[1].y], [ r[1].x,  r[1].y], [ 0   , -l[3]]]];
         
//    for(i=[0:3]) {
//        for(j=[0:2]) {
//            color("red") inspectPoint(D[i][j], heightObject = d.z);
//            color("green") inspectPoint(D[i][j] + DD[i][j], , heightObject = d.z);
//            color("blue") inspectPoint(D[i][j] + DD[i][j] + R[i][j], radius, , heightObject = d.z);
//        }
//    }
    
    
    difference() {
        cube(d);
        for(i=[0:3]) {
            translate([0, 0, -d.z / 2])
            linear_extrude(height = d.z * 2) {
                hull()  {
                    for(j=[0:2]) {
                        pos = D[i][j] + DD[i][j] + R[i][j];
                        translate([pos.x, pos.y, 0])
                        circle(d = radius * 2, center=true, $fn=100);
                    }
                }
            }
        }
    }
 
    echo(width=width);
    echo(d=d);
    echo(radius=radius);
    echo(H=H);
    echo(dd=dd);
    echo(D=D);
    echo(DD=DD);
    echo(l=l);
    echo(r=r);
    echo(R=R);
    
    
    

}


module inspectPoint(point, radius = 0.1, heightObject = 5) {
    l=heightObject * 3;
    
    translate([point.x, point.y, -heightObject])
    linear_extrude(height=l)
    circle(d=radius*2, true, $fn=100);
}


function deltaBuiten(width = 2, hoek = 90) = 
    (width / 2) * ((2 * cos(hoek) + 1) / sin(hoek));
function deltaBinnen(width = 2, hoek = 90) = 
    (width / sin(hoek)) * cos(hoek / 2);