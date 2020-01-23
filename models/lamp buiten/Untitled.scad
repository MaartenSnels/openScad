/*
    lamp gekocht bij AlieExpress: 
    https://www.aliexpress.com/item/15w-Waterproof-DRL-Led-Daytime-Running-Light-Auto-Car-White-12V-Bar-Car-Light-Source-day/32782545088.html?spm=2114.13010608.0.0.hCMLfp

*/


lamp  = [168, 14.5,   1];
licht = [166, 10  , 1.5];

marge = 0.5;


lamp();

module lamp() {
    color("white")
        cube(lamp);
    
    color("yellow")
        translate([(lamp.x - licht.x) / 2, (lamp.y - licht.y) / 2, lamp.z])
            cube(licht);
}

module behuizing() {
    // 1 enkele strip
}

module bevestiging() {
    // hoe maken we de boel vast, en waaraan
}

module electronica() {
    // knop
    // 12V aansluiting
    // bedrading
}