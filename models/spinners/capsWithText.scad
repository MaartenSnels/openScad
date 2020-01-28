// inner diameter of bearing! This is the diamter of the axis, make sure it fits!
d = 8.3;
// outer diameter of bearing (cap = 1 mm smaller)
D = 22;
// height of bearing, axis of caps is 1 mm higher
b = 7;
//height of the cap
h = 2.5;

// rounded edge on cap 0 = NO, 1 = yes
rounded = 1; // [0,1]
// text on first cap
text1 = "Super";    
text2 = "Spinner";  

hStub = (b + 1) / 2; // height of spinner axis
$fn = 0 + 60;

cap( text = text1
   , rounded = rounded
   , male = true);
translate([D + 2, 0, 0])
    cap( text = text2
       , male=false
       , rounded = rounded);
    
    
module cap(text, male = true, rounded = 1) {
    difference() {
        union() {
            cylinder(d = d, h = hStub, center = false);
            if (male) {
                dimple(male);
            }
        }
        if (!male) {
            dimple(male);
        }
    }
    translate([0, 0, hStub])
    difference() {
        capPlate(rounded);
        translate([0, 0, h])
        getText(text);
    }
}

module dimple(male = true) {
    m = .1;
    margin = male ? -m : m;
    cylinder( d = d / 2 + margin
            , h=hStub / 2 + margin
            , center=true);
}

module capPlate(rounded = 1) {
    if (rounded == 1) {
        r=1;
        minkowski() {
            cylinder( d = D - 1 - 2 * r
                    , h = h - r
                    , center = false);
            sphere(r = r);
        }
    }
    else {
        cylinder(d = D - 1, h = h, center = false);
    }
}

module getText(text = text) {
    /* make sure the text fits! */
    depth = 1; // depth of engraving
    translate([-D / 2 + 1.5, 0,  -depth])
        linear_extrude(depth * 2, convexity = 4)
            resize([D * 0.8, 0], auto = true)
                text( text = text  
                    , font="Tw Cen MT:style=Bold"
                    , valign = "center");
}

