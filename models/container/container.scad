use <threads.scad>

dInner         = 15;    // inner diameter
wall           = 3;     // wall thickness, must be at least 4
innerHeight    = 70;    // inner height of container, 
                        // defines wat it can hold
bottemHeight   = 3;     // thickness of bottem and top of cap
cap            = 7;     // thread height of cap
enlargeCap     = 7;     // part of cap without thread
capClearance   = 0.2;   // space between cap and thread if bottle 
                        // fully closed
gripsContainer = 8;     // number of grips on oudter shell
gripsCap       = 12;    // number of grips on oudter shell
oRing          = false; // with room for o-ring in cap
roundBottom    = true;  // remove sharp edges bottom of cap and container
roundTop       = true;  // remove sharp edges top of cap and container
keyCord        = true;  // create hole for lanLine
margin         = 0.20;  // margin for threads and overlapping cylinders
fnGrips        = 6;     // how to draw the grips
dHookHolder    = 3;     // diameter of hook holder.
debug          = true; // debub mode, fn is smaller
multiColor     = true;


///// thread settings ///////////////////
pitch = 2;
thread_size = 1.5;

///// calculated values /////////////////
fn = debug ? 30 : 60;              // printing quality of circular faces
height = innerHeight - cap + capClearance + bottemHeight;
dOuter = dInner + 2 * wall; // outer diameter, excliding grips
dThread = dOuter - wall / 2 - thread_size;
echo (height = height, dOuter=dOuter, dThread=dThread);

////////// TODO /////////////////
//
//       - aansluiting in dop massief als grips > 0
//       - Vulhoogte aangeven in bakje
//       - twee kleuren voor twee kleuren printer
// DONE  - sleutel om geen zere handen te krijgen
// DONE  - foutmelding bij grips = 0
// DONE  - afronden van onderkant grip
// DONE  - recycle gegevens
//
//////////////////////////////////////



//////// RENDER  ////////////////////
//containerAndCap(print = false);
//containerAndCap(print = true);
//capWithHook();
//container();
slice();
//key(forCap = false);
//key(forCap = true);


/////// DEBUG ///////////////////////
module slice() {
    difference() {
        containerAndCap(print = false);
        sliceBlock();
    }
}

module sliceBlock(blockSize = 200, slice = .1) {
    difference() {
        cube([blockSize,blockSize,blockSize], center = true);
        cube([slice, blockSize * 1.1, blockSize * 1.1], center = true);
    }
}


/////// MODULES ///////////////////////
module containerAndCap(print = true) {
    
    delta = 0.5;
    
    tPrint = [0, dOuter * 1.5, 0];
    tStack = [0, 0, height + enlargeCap + bottemHeight + delta];
    rPrint = [0, 0, 0];
    rStack = [0, 180, 0];
    
    container();
    translate(print ? tPrint : tStack) {
        rotate(print ? rPrint : rStack) {
            if (keyCord) {
                capWithHook();
            } else {
                cap();
            }
        }
    }
}

module outerShell(d = dOuter
                , h = height
                , grips = 6
                , roundTop = true
                , roundBottom = true) {
    difference() {
        union() {
            cylinder(d = d, h = h, $fn=60);
            grip(d = d, h = h, grips = grips);
        }
        if (roundBottom) {
            rounder(top = false);
        }
        if (roundTop) {
            translate([0, 0, h ])
                rounder(top = true);
        }
    }
}

module rounder(d = dOuter, top = false) {
// round the top and bottom of the container
    d = d + wall;
    rotate([0, top ? 180 : 0, 0])
    translate([0, 0, wall * 2])
        difference() {
            cube([d, d, d] , center = true);
            sphere(d=d, $fn=fn);
            translate([0, 0, d])
            cube([d, d, d] * 2, center = true);
            
        }
}

module container() {
    d = dThread - margin - thread_size / 2;
    difference() {
        union() {
            outerShell(h = height - enlargeCap
                     , grips = gripsContainer
                     , roundTop = roundTop
                     , roundBottom = roundBottom);
            translate([0, 0, height - enlargeCap])
                cylinder(d=d, h=enlargeCap, $fn=fn);
        }
        translate([0, 0, bottemHeight])
            cylinder(d=dInner, h=height, $fn=fn);
        translate([0, 0, height - enlargeCap])
        difference() {
            cylinder(d=dOuter*2, h=height, $fn=fn);
            cylinder(d=d, h=height, $fn=fn);
        }
    }
    translate([0, 0, height])
        topThread();
}

module key(forCap = true) {
    grips = forCap ? gripsCap: gripsContainer; 
    d = dOuter * 1.6;
    l = d * 1.5;
    b = d / 2;
    h = wall;
    text = str(str(grips), "/", str(dOuter));
    difference() {
        union() {
            cylinder(d = d, $fn=6, h = h);
            translate([0, l, 0])
                cylinder(d = b, $fn = fn, h = h);
            translate([-b/2, 0, 0])
            cube([b, l, h]);
        }
        translate([0, l, -h]) 
            cylinder(d = b * 0.7, $fn = fn, h = h * 3);
        translate([0, 0, -wall])
            outerShell(h = wall * 3
                        , d=dOuter + 1
                        , grips=grips
                        , roundTop = false
                        , roundBottom = false );
        translate(([b/10, d/2, wall / 2]))
            rotate([0, 0, 90])
                write(text, size=d/5, height = wall);
    }
    
    translate([0, 0, -wall])
    %outerShell(h = wall * 3
                , d=dOuter
                , grips=grips
                , roundTop = false
                , roundBottom = false );
}

module grip(grips = 6, d = dOuter, h = height) {
    if (grips > 0) {
        for (i=[0 : grips - 1]) {
            hoek = 360 / grips * i;
            rotate([0, 0, hoek])
                translate([0, (d - wall)/ 2, 0])
                    cylinder(d=wall * 2, h=h, $fn=fnGrips);
                
        }
    }
}

module topThread() {
    difference() {
        capThread(false, cap - capClearance);
        translate([0, 0, -cap / 2])
            cylinder(d=dInner, h = cap * 2, $fn= fn);
    }
}

module capWithHook() {
    l = dInner - wall;
    difference() {
        cap(oRing = true);
        hookHole();
    }
    translate([0, 0, dHookHolder / 2]) 
        rotate([90, 0, 0])
            cylinder( d = dHookHolder
                    , h = l
                    , $fn = fn
                    , center = true);
    translate([0, 0, dHookHolder / 4])
    cube([dHookHolder, l, dHookHolder/2], center = true);
    
}

module cap(oRing = oRing) {
    h = cap + bottemHeight;
    d = dThread + margin;
    difference() {
        outerShell(h = h + enlargeCap
                 , grips = gripsCap
                 , roundTop = roundTop
                 , roundBottom = roundBottom);
        translate([0, 0, bottemHeight])
        capThread(true, h - bottemHeight);
        translate([0, 0, h])
            cylinder(d=d, h=enlargeCap * 2, center=false, $fn = fn);
    }
    if (oRing) {
        cylinder(d=dInner - margin * 4, h=h, $fn=fn);
    }
}

module hookHole() {
    d = dInner - wall;
    h = cap - d / 2 + wall;
    translate([0, 0, -wall]) {
        cylinder(d = d, h = h, $fn = fn);
        translate([0, 0, h])
            sphere(d=d, $fn=fn);
    }
}

module capThread(internal = false, height = 10) {
    d = dThread + (internal ? margin : -margin);
    metric_thread (diameter = d
                 , internal = internal
                 , length = height
                 , pitch = pitch
                 , thread_size = thread_size);
}

module write(text, size, height) {
    linear_extrude(height=height)
        text(text=text, size=size);
}