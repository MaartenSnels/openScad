/*
    around the door with ikea torv plint system

    TODO
    -   rounding edg of rand
    -   small piece on bottom edge
    -   plinth size of original, not hte size of the printed elements
        that cover the plith
    
*/

$fn=60;
wall        = 1.6;  // wall thickness 
bottom      = 20;   // bottom width including wall
top         = 13;   // top including wall
height      = 60;   // height including wall
rounding    = 4;    // rounding edg outer
endplate    = 2;    // thickness of the endplate
overlap     = 7;    // how far does it stick over the plint
holderWidth = 10;   // length of the clamp



test2();

module test1() {
                            endStop(left = true);
    translate([0, 30, 0])   endStop(left = false);
    translate([0, 60, 0])   cornerPiece(80);
    translate([40, 60, 0])  cornerPiece(90);
    translate([80, 60, 0])  cornerPiece(100);
    translate([0, 110, 0])  cornerPiece(0);
    translate([0, 140, 0])  cornerPiece(290);
    translate([40, 140, 0]) cornerPiece(270);
    translate([80, 140, 0]) cornerPiece(260);
    translate([-50, 0, 0])  plinth(length = 200, cutOut = true);
    echo("done");
}

module test2() {

    cornerPiece(90);
    translate([0, overlap - 70, 0])
    plinth(length = 70, cutOut = true);
    translate([bottom, bottom + overlap + wall, 0])
    rotate([0,0,-90])
    plinth(length = 70, cutOut = true);
    translate([0, overlap - 70, 0])
    rotate([0, 0, -90])
    cornerPiece(270);
}


////////////////////////////////////////////////
// COMPLETE PLINTH OBJECTS
////////////////////////////////////////////////

// beginning of end of a plinth
module endStop(left=true, cutOut = false) {
    echo("Endstop", left=left, cutOut=cutOut);
    base(left, cutOut);
}

// connect two pieces of plinth
module connect(cutOut = true) {
    echo("connect", coutOut = cutOut);
    endStop(true, cutOut);
    translate([0, -overlap, 0])
    endStop(false, cutOut);
}

// go around the corner
module cornerPiece(angle = 90) {
    a = angle % 360;
    echo("cornerPiece (select next module)", angle=angle);
    if (a <= 180 && a > 0) {
        innerCorner(a);
    } else if (a == 0) {
        connect(true);
    } else {
        outerCorner(a - 180);
    } 
}

module plinth(length=200, cutOut = false) {
    translate([bottom, 0, 0])
    mirror([0,1,0])
    rotate([90, -90, 0])
    linear_extrude(height = length)
    difference() {
        baseShape2D(cutOut = cutOut);
        edge2D();
    }
}

// connect two pieces around a wall
module outerCorner(angle = 90) {
    // outer corner of two plints
    echo("outerCorner", angle=angle);
    translate([0, -overlap - endplate, 0])
    endStop(false, true);
    rotate([0, 0, angle])
    endStop(true, true);
//    rotate([0, 0, 90 - angle])
    corner(inner = false, cutOut = true, angle = angle);
}

// connect two pieces around a wall
module innerCorner(angle = 90) {
    //inner corner of two pinths
    echo("innerCorner", angle=angle);
    endStop(false, true);
    translate([bottom, overlap + endplate, 0])
    rotate([0, 0,  -angle])
    translate([-bottom, 0, 0])
    endStop(true, true);
    translate([bottom, overlap + endplate, 0])
    corner(inner = true, cutOut = true, angle = angle);
    topPlate(angle);
}


////////////////////////////////////////////////
//  PARTS
////////////////////////////////////////////////


module topPlate(angle=90) {
    // make sure the top of the corner fits in the corner
    a = angle / 2;
    l = bottom / cos(a);
    x = bottom * cos(a);
    y = bottom * sin(a);
    
    points = [[x,y], [l,0], [x,-y]]; 
    
    translate([bottom, overlap + endplate, height])
    rotate([0, 0,  180 - a])
    mirror([0,0,1])
    linear_extrude(height = height / 2, scale = .5)
    difference() {
        polygon(points);
        circle(r = bottom, center=true);
        translate([l , 0 ,0])
        circle(r=2, center=true);
    }
}

module base(left = false, cutOut = false) {
    translate([left ? 0 : bottom, left ? 0 : endplate + overlap, 0])
    rotate([0, -90, left ? -90 : 90])
    union() {
        translate([height  / 4, bottom *.7, endplate])
        letter(left ? "L" : "R");
        translate([0, left ? bottom : 0, 0])
        rotate([0, 0, left ? 180 : 0])
        mirror([left ? 1 : 0, 0, 0]) {
            linear_extrude(height = endplate)
            baseShape2D(cutOut);
            translate([0, 0, endplate])
            edge();
            translate([0, 0, endplate])
            holders();
        }
    }
}

module baseShape2D(cutOut = false) {
    echo("baseShape2D");
    points = [[0, 0], [0, bottom], [height, bottom]];
    difference() {
        hull() {
            polygon(points);
            translate([height - rounding, bottom - top + rounding, 0])
            circle(d = rounding * 2, true);
        }
        if (cutOut) {
            cutOut2D();
        }
    }
}

module cutOut2D() {
    points = [[0, bottom - 12.4], [0, bottom], [18, bottom], [14, bottom - 4.3]];
    polygon(points);
}
module corner(inner, cutOut, angle) {
    rotate([0, 0, inner ? -angle : 0])
    rotate_extrude(angle = inner ? angle : angle) {
        rotate([0, 0, 90])
        translate([0, inner ? 0 : -bottom, 0])
        baseShape2D(cutOut);
    }
}

module holders() {
    h = [holderWidth, 1.2, overlap + 2];
    
    translate([38, bottom - h.y, 0])
    holder(h);
    
    translate([h.x / 2 * cos(30) +.5, bottom - 11, 0])
    rotate([0, 0, 30])
    holder(h);
}

module holder(h) {
    
    p = [1, .5, h.x / 2];
    
    points = [ [-h.z / 2, 0  ]
             , [h.x     , 0  ]
             , [h.x     , h.z]
             , [0       , h.z] ];
    
    translate([0, h.y, 0])
    rotate([90, 0, 0])
    linear_extrude(height = h.y)
    polygon(points);
    
    for(i=[0:2]) {
        translate([i * ((h.x - p.x) / 2), -p.y, 0])
        cube(p);
    }
    
}

module letter(l) {
    rotate([0, 0, -90])
    linear_extrude(height = .3) text(l);
}

module edge() {
    linear_extrude(height = overlap)
    edge2D();

}

//edge2D();
module edge2D() {
    alpha = atan((bottom - top) / height);
    echo(alpha=alpha);
    points = [
              [0, wall]
             ,[0, bottom]
             ,[height - wall, bottom]
             ,[height - wall, bottom - wall]
             ,[wall, wall * (1 + sin(alpha))]
             ];
    
    difference() {
        baseShape2D();
        // make the rounding smooth
        offset(r=-wall)
        baseShape2D();
        // cut away the outer edges
//        translate([-wall, wall, 0])
//        baseShape2D();
        polygon(points);
    }

}