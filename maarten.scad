// voorbeelden

//ring(d = 100, h = 10, w = 1, center = false, bottom = false, top = false);
//box([40, 40, 10], w = 1, center = true, bottom = true, top = true);
//roundedBox([200, 300, 30], w = 1, radius = 10, center = true,  bottom = true);
//dome(100, 30, 1);

//difference() {
//    h=5;
//    cube([40,40,h], center = true);
//    translate ([-h, 0, 0]) screwHole(hHead = 0);
//    translate ([h, 0, 0]) screwHole(hHead = h/2);
//}

size = [100, 200, 300];
roundedCube(size = size);
translate([0, size.y * 1.1, 0]) fullRoundedCube(size);

/**
*   d = binnendiameter ring
*   h = hoogte ring
*   w = wandDikte ring
*   bottom = aftesloten geheel met een bodem
*
*   Doel: teken een ring met een opgegeven binnendiameter, bredte en hoogte
**/
module ring(  d = 100           // inner diameter of the ring
            , h = 10            // height of the ring
            , w = 1             // wall thickness
            , center = false    // center the object
            , fn = $fn          // fn
            , bottom = false    // incluede bottom
            , top = false)      // include top
{
    up(!center ? h / 2 : 0) {
        difference() {
            cylinder(d = d + w * 2, h = h, center = true ,$fn = fn);
            cylinder(d = d, h = h + w, center = true, $fn = fn);
        }
        if (bottom) {
            up((w - h) / 2)
                cylinder(d = d, h = w, center = true, $fn = fn);
        }
        if (top) {
            up((h - w) / 2)
                cylinder(d = d, h = w, center = true, $fn = fn);
        }
    }
}


/**
    size = afmetingen van de box
    w = wall
    
    standaard box zonder onderkant
    als bottom = true, met onderkant
**/
module box(   size = []         // size of the box
            , w = 1             // wall thickness
            , center = false    // center object
            , bottom = false    // include bottom
            , top = false)      // include top
{
    t = center ? [0, 0, 0] : size / 2;
    b = size - [w, w, -w] * 2;
    translate(t) {
        difference() {
            cube( size, center = true);
            cube(b, center = true);
        }
        if (bottom) {
            translate([size.x, size.y, size.z] / -2) 
                cube([size.x, size.y, w]);
        }
        if (top) {
            translate([size.x, size.y, w * 2 - size.z] / -2) 
                cube([size.x, size.y, w]);
        }
    }
}


module roundedBox(size = []
                , w=1               // wall thickness
                , center = false    // center object
                , bottom = false        // has bottom
                , radius = 10)      // radius of the rounding
{        
                    
    t = center ? [0, 0, 0] : size / 2;
    b = size - [w, w, -w] * 2;
    up = bottom ? w * 2 : 0;
    rIn = radius - w > 0 ? radius - w : radius;
    translate(t) {
        difference() {
            roundedCube( size, radius = radius);
            up(up) roundedCube(b, radius = rIn);
        }
    }
}



module roundedCube(size = []        // size of the box 
                , fn = 60           // fn
                , center = true     // center the object
                , radius = 10)      // radius of the box
{
    
    points = [
                [radius,          radius,          0]
           ,    [size.x - radius, radius,          0]
           ,    [size.x - radius, size.y - radius, 0]
           ,    [radius,          size.y - radius, 0]
    ];
    translate(center ? size / -2 : [0, 0, 0]) {
        hull() {
            for(i=points) {
                translate(i) cylinder(r=radius, h=size.z, center=false, $fn = fn);
            }
        }
    }
}

module tube(radius = 10, h = 200, fn = 60) {
    up(radius) {
        sphere(r = radius, $fn = 60);
        cylinder(r = radius, h = h - radius * 2, $fn = fn);
    }
    up(h - radius)
        sphere(r = radius, $fn = 60);
}


/* private, zorg dat je wat kunt*/ 
module halfTubeCube(size = [100, 200, 300], fn = 60, radius = 10) {
    // x-as
    rt(t=[0, radius, radius], r=[0, 90, 0])
        tube(h=size.x, radius = radius, $fn = fn);
    rt(t=[0, size.y - radius, radius], r=[0, 90, 0])
        tube(h=size.x, radius = radius, $fn = fn);
    // y-as
    rt(t=[radius, 0, radius], r=[-90, 0, 0])
        tube(h=size.y, radius = radius, $fn = fn);
    rt(t=[radius, 0, size.z - radius], r=[-90, 0, 0])
        tube(h=size.y, radius = radius, $fn = fn);
    //z-as
    rt(t=[radius, radius, 0], r=[0, 0, 0])
        tube(h=size.z, radius = radius, $fn = fn);
    rt(t=[radius, size.y - radius, 0], r=[0, 0, 0])
        tube(h=size.z, radius = radius, $fn = fn);
}

module fullTubeCube(size = [100, 200, 300], fn = 60, radius = 10) {
    halfTubeCube(size = size, fn = fn, radius = radius);
    translate(size)
        rotate([0, 0, 180]) 
            mirror([0, 0, -1])
                halfTubeCube(size = size, $fn = fn, radius = radius);
}

module tubedCube(size = [100, 200, 300], fn = 60, radius = 10) {
    fullTubeCube(size = size, $fn = fn, radius = radius);
    translate([1, 1, 1] * radius) cube(size - [1, 1, 1] * radius * 2);
}

module fullRoundedCube(size = [100, 200, 300], fn = 60, radius = 10, center = false) {
    
    translate(center ? size * -0.5 : [0, 0, 0]) {
        fullTubeCube(size = size, fn = fn, radius = radius);
        translate([1, 1, 0] * radius) cube(size - [1, 1, 0] * radius * 2);
        translate([1, 0, 1] * radius) cube(size - [1, 0, 1] * radius * 2);
        translate([0, 1, 1] * radius) cube(size - [0, 1, 1] * radius * 2);
    }
}


module dome(  d = 100           // diamter
            , h = 10            // height
            , hollow = true     // massive of hollow
            , w = 1             // wall thickness
            , fn = 128)         // fn
{
	sphereRadius = (pow(h, 2) + pow((d/2), 2) ) / (2*h);

	translate([0, 0, (sphereRadius-h)*-1])
	{
		difference()
		{
			sphere(sphereRadius, $fn = fn);
			translate([0, 0, -h])
			{
				cube([2*sphereRadius, 2*sphereRadius, 2*sphereRadius], center=true);
			}

			if(hollow)
				sphere(sphereRadius-w, $fn = fn);
			
		}
	}
}
/**
* schruif alle elemetnen tussen de acculades omhoog
**/
module up(height = 0) // momement
{
    translate([0, 0, height]) children();
}


/**
* eert roteren en dan verplaatsen
**/
module rt(r = [0, 0, 0]     // rotation
        , t = [0, 0, 0])    // translation
{
    translate(t) rotate(r) children();
}

/**
* eert verplaatsen dan roteren
**/
module tr(t = [0, 0, 0]         // translation
        , r = [0, 0, 0]) {      // rotation
    rotate(r) translate(t) children();
}

module screwHole( dScrew = 4     // diameeter of screw hole
                , hScrew = 100   // depth of the screw hole
                , dHead  = 8     // diameter of head
                , hHead  = 3     // height of head, can be 0
                , fn     = 60)   
{
    up(-hScrew)
        cylinder(d = dScrew, h = hScrew, center = false, $fn = fn);
    up(hHead)
        cylinder(d = dHead, h = hScrew, center = false, $fn = fn);
    if (hHead > 0) {
        cylinder(d1 = dScrew, d2  = dHead, h = hHead, center = false, $fn = fn);
    }
}


module tubularRing(dTube = 10, dRing = 100, fn = 60, angle = 360){
   rotate_extrude(angle=angle, convexity=10, $fn = fn)
       translate([dRing - dTube, 0] / 2) circle(d = dTube);
}
