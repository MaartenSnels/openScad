
/*
    The front of the x and z axis is the point [0,0,0]
    all is drawn in referenct to that point
    up    == +z
    down  == -z
    left  == -x
    right == +x
    back  == -y 

    the support does not have to be symetric, so left and right
    can differ.
    
    For instanxe 
        left = 35 and right = 65 for the left support
        left = 65 and right = 30 for the right support
    
    

*/

left             = 30;  // 35
right            = 30;  // 65
up               = 30;
down             = 30;
back             = 30;
thicknessStud    = 7.5;  // Thickness acrylic studs
minimumThickness = 5;  // minimal thickness of the walls

boltHead = 8;
bolt     = 5;
nut      = 9;

// use exsisting screws
screws = true; // use the tronxy screws to fasten the brackt
screw1 = 7;    // height of first screw
screw2 = 23;   // height of second screw


bracket();

module bracket() {
    difference() {
        bijgewerktBlok();
 //       reinforcement();
        dikkeBout();
    }    
}

module dikkeBout() {
    translate([-back/2, 0, -down / 2])
    rotate([90, 0, 0])
    boltHole();
    translate([-thicknessStud / 2, (right + thicknessStud) / 2, up / 2])
    rotate([0, 90, 0])
    boltHole();
    translate([-thicknessStud / 2, -(left + thicknessStud) / 2, up / 2])
    rotate([0, 90, 0])
    boltHole();
}

module boltHole() {
    // maximum bore hole on one side 
    maxHole = max(left, right, back);
    // shift holes
    shift = (thicknessStud + minimumThickness) / 2;
    
    union() {
        // middle part
        cylinder(  d = bolt
                 , center = true
                 , h = thicknessStud + minimumThickness 
                 , $fn = 30);
        // hole for screw head
        translate([0,0,shift])
        cylinder(  d = boltHead
                 , h = maxHole 
                 , $fn = 30);
        // hole for screw head
        translate([0,0,-maxHole - shift])
        cylinder(  d = nut
                 , h = maxHole 
                 , $fn = 6);
    }
}

module reinforcement() {
    x = 2;
    y = 40;
    z = 15;
    
    translate([(minimumThickness - x ) / 2
            , (-y + thicknessStud)/2 
            , up - z])
    cube([x, y, z]);
}

module bijgewerktBlok() {
    hoogte = up + down;
    breedte = left + right + thicknessStud;
    diepte = minimumThickness + thicknessStud + back;
    h1 = -atan((back - minimumThickness) / (right - minimumThickness));  // hoek right
    h2 = -atan((back - minimumThickness) / (left - minimumThickness));  // hoek right
    h3 = -atan((right - minimumThickness) / (down - minimumThickness));  // hoek right
    h4 = -atan((left - minimumThickness) / (down - minimumThickness));  // hoek right
    difference() {
        block();
        //right up
        translate([-(back + thicknessStud) 
                , thicknessStud / 2 + minimumThickness
                , -hoogte ])
        rotate([0,0,h1])
        translate([-back, 0, 0])
        cube([back, diepte * 2, hoogte * 2]);
        // left up
        translate([-(back + thicknessStud) 
                , -(thicknessStud / 2 + minimumThickness)
                , -hoogte])
        rotate([0,0, -h2])
        translate([-back * 1, -hoogte * 2, 0])
        cube([back * 1, hoogte * 3, hoogte * 2]);
        // right down
        translate([-diepte * 1.5
                 , right + thicknessStud / 2
                 , -minimumThickness])
        rotate([h3, 0, 0])
        translate([0, 0, - breedte * 2])
        cube([diepte * 2, right, breedte * 2]);
        // left down
        translate([-diepte * 1.5
                 , -(left + thicknessStud / 2)
                 , -minimumThickness])
        rotate([-h4 , 0, 0])
        translate([0, -left, - breedte * 2])
        cube([diepte * 2, left, breedte * 2]);
    }


}

// start with massive bloc, with only the 
// cutouts for the acrylic parts and the screws
module block() {
    l = minimumThickness  + thicknessStud + back;
    b = left  + thicknessStud + right;
    h = down + up;
   
    l2 = minimumThickness + thicknessStud * 2;

    hoek = atan((thicknessStud) / (down - minimumThickness));
    echo (hoek=hoek);
    difference() {
        translate([minimumThickness - l
        , -left - thicknessStud /2
        , -down])
        cube([l, b, h]);
        // make lower part movable
        translate([minimumThickness,0 ,-minimumThickness])
        rotate([0,hoek, 0])
        translate([0, -b , -down])
        cube([minimumThickness * 2, b * 2, down]);
        // y support cutout 
        translate([-thicknessStud, -left - b/2, 0])
        cube([thicknessStud, b * 2,up * 2]);
        // cutout for screws (TRONXY ONLY)
        if (screws) {
            screwHole(screw1);
            screwHole(screw2);
        } else {
            translate([-l2 + minimumThickness / 2
            , -thicknessStud / 2
            , 0])
            cube([l2 , thicknessStud, up * 2]);
        }
        // Z-support cutout
        translate([-l - thicknessStud
        , -thicknessStud / 2
        , -h])
        cube([l , thicknessStud, h * 2]);
    }
}

module screwHole(screw) {
    translate([ minimumThickness / 2
               , 0
               , screw]) 
    rotate([0, 90, 0])
    cylinder(d = 4
           , h = minimumThickness * 2
           , $fn = 30
           , center = true);
}
