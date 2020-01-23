/* pegboard pins */


dPeg     = 5;   // diameter of peg
inHolder = 3;   // minimum depth in tool holder
hClamp   = 4;
inBoard  = 4;   // minimum depth in board
angle    = 60;  // angle of upper peg  
overlap  = 1.5; // overlap of barb
clampCut = 10;

clamp();

module lPin() {

}

module uPeg(){

}


module lPeg2d() {
    

}

module clamp() {
    
    square([dPeg, dPeg]);
}

module rt(r=[], t=[]) {
    translate(t) rotate(r) children();
}