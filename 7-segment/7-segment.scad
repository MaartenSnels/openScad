$fn = 60;

segment = [20, 55, 10];
segmentCorner = 4;
segmentMargin = 2.5;
segmentBottom = .5;         // botom wall of segment, light must shine through
segmentWall = 1;
segmentDrop = 7;

boxCorner = 10;             // corner of box
boxHeight = 25;             // height of the box
boxBottom = 1;                // bottom wall of the box
boxWall   = 2;

ledDiameter = 5;
ledsPerSegment = 2;

////////////////////////////////////////////////////////////////////////////////
// CALCULATED VALUES
////////////////////////////////////////////////////////////////////////////////
box = [ segment.x + segment.y + segmentMargin * 2 + boxCorner * 2
      , segment.x + segment.y * 2 + segmentMargin * 4 + boxCorner * 2
      , boxHeight];
      
segmentConnect = segmentDrop + boxBottom;

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// TESTJES ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//for(i=[0:1])
//    translate([box.x, 0, 0] * i)
        display();
//segment(connect = true);

//////////// TODO //////////////
// fullsegment en segment lijken nog niet op elkaar.
// te veel variabelen worden doorgegeven terwijl ze eigelijk globaal zijn

////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// MODULES ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

module display() {
    color("gray") huis();
//    translate([0, 0, -segmentDrop + boxBottom + 1])
        color("white") cijfer();
}

module dak(cube = segment) {
    theCube = [segment.x, segment.y, segment.z / 2];
    ledCube = [ledDiameter / 2, segment.y * 2, ledDiameter];
    translate([0, 0, -segmentBottom]) {
        difference() {
            translate([0, 0, -theCube.z / 2 + segmentBottom])
            fullSegment(cube = theCube, bottom=false);
            for(i=[-0, 0]) {
                rotate([0, 135 - i, 0])
                    translate([0, -segment.y, 0] / 2)
                        cube([segment.x, segment.y, segment.y]);
            }
//            translate([0, 0, -ledCube.z / 2])
//                cube(ledCube, center = true);
            leds();
        }
    }
}

module leds() {
    x = (segment.y - ledDiameter) / (ledsPerSegment + 1);
    for(i = [1 : ledsPerSegment])  
    translate([0, (segment.y - ledDiameter) / 2 - i * x, 0]) {
        cylinder (d = ledDiameter, h = segment.z * 2, center = true);
        rotate([0, 180, 0])
            cylinder (d1 = ledDiameter, d2 = ledDiameter + segment.z, h = segment.z, center = false);
    }
}


module huis() {
    theBox = box + [0, 0, box.z];
    difference() {
        translate([0, 0, box.z])
        difference() {
            box(theBox, corner = boxCorner); 
            box(theBox - [boxWall, boxWall, boxBottom] * 2, corner = boxCorner);
            translate([0, 0, theBox.z])
                cube(theBox * 2, center = true);
        }
        translate([0, 0, -boxWall * 2]) 
            massive(cube = segment + [1, 1, 0]);
    }
}

/**
*   massive version of the number. Used for cutting the box.
*/
module massive(cube = segment) {
    translate([- segment.y - segmentMargin, -segment.y - segmentMargin, segment.z] / 2)
    create7() {
        fullSegment(cube = cube, flat = false, connect = false);
    }
}

module cijfer(bottom = true) {
    translate([- segment.y - segmentMargin, -segment.y - segmentMargin, segment.z * 2] / 2)
    create7() {
        segment(cube = segment, d = segmentMargin, connect = true, bottom = true);
    }
}

module create7() {
    d = segmentMargin;
    translate ([0            , 0                  , 0]  ) rotate([0, 0,   0]) children();
    translate ([segment.y + d, 0                  , 0]  ) rotate([0, 0, 180]) children();
    translate ([segment.y + d, segment.y + d      , 0]  ) rotate([0, 0, 180]) children();
    translate ([0            , segment.y + d      , 0]  ) rotate([0, 0,   0]) children();
    translate ([segment.y + d, segment.y + d      , 0]/2) rotate([0, 0, 270]) children();
    translate ([segment.y + d, -segment.y - d     , 0]/2) rotate([0, 0,  90]) children();
    translate ([segment.y + d, (segment.y + d) * 3, 0]/2) rotate([0, 0, 270]) children();
}

module segment(cube = segment, d = 0, connect = false, bottom = true) {
    m = max(cube) * 2;
    difference() {
        fullSegment([cube.x, cube.y, cube.z * 2 ], connect = connect, bottom = bottom);
        fullSegment([cube.x, cube.y, cube.z * 2] - [segmentWall, segmentWall, segmentBottom] * 2, connect = false, bottom = bottom);
        translate([0, 0, m / 2])
            cube([m, m, m], center = true);
    }
    dak(cube = segment);
}

module fullSegment(cube = segment, flat = false, connect = false, bottom = true) {
    x = cube.x / cos(45) / 2;
    trans = [0, cube.y - sqrt(2) * x, 0] / 2;
    theCube = [x, x, cube.z];
    hull() {
        for(i = [-1, 1])
            translate(trans * i)
                rotate([0, 0, 45]) {
                    if (flat) {
                        cube(theCube, center = true);
                    } else {
                        segmentPoint (cube = theCube, corner = segmentCorner, bottom = bottom);
                    }
                }
    }
    if (connect) {
        connect(segment = cube, cube = theCube, trans = trans);
    }
}

module connect(segment = segment, cube = [10, 10, 10], trans = [0, 0, 0]) {
    up = -segment.z + segmentDrop + boxBottom;
    for(i = [1, -1]) {
        translate(trans * i)
            rotate([0, 0, 45]) {
                box(cube + [-segmentCorner,  segmentCorner, up] , corner = segmentCorner, bottom = true);
                box(cube + [ segmentCorner, -segmentCorner, up] , corner = segmentCorner, bottom = true);
            }
    }
}

module segmentPoint(cube = [10, 20, 30], corner = 4, bottom = true) {
    box (cube, corner = corner, bottom = bottom);
}

module box(cube = [10, 20, 30], corner = 4, bottom = true) {
    fn = 4;
    smallCube = (cube - [corner, corner, bottom ? corner : 0]) / 2;
    staand = [[ smallCube.x,  smallCube.y, 0], 
              [-smallCube.x,  smallCube.y, 0], 
              [ smallCube.x, -smallCube.y, 0], 
              [-smallCube.x, -smallCube.y, 0]
    ];
    
    liggendX = [[ smallCube.x, 0,  smallCube.z], 
                [-smallCube.x, 0,  smallCube.z], 
                [ smallCube.x, 0, -smallCube.z], 
                [-smallCube.x, 0, -smallCube.z]
    ];
    
    liggendY = [[0,  smallCube.y,  smallCube.z], 
                [0, -smallCube.y,  smallCube.z], 
                [0,  smallCube.y, -smallCube.z], 
                [0, -smallCube.y, -smallCube.z]
    ];
    hull() {
        translateMutiple(staand) 
            cylinder(d = corner, h = cube.z - (bottom ? corner : 0), center = true, $fn = fn);
        if (bottom) {
            translateMutiple(liggendX) 
                rotate([90, 0, 0])
                    cylinder(d = corner, h = cube.y - corner, center = true, $fn = fn);
            translateMutiple(liggendY)
                rotate([0, 90, 0])
                    cylinder(d = corner, h = cube.x - corner, center = true, $fn = fn);
        }
    }
}

module translateMutiple(trans) {
    for(i = trans) {
        translate(i)
            children();
    }
}

