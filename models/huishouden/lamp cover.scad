use <maarten.scad>

hRing = 2.5;
dRing = 94;
wall  = 2;
fn    = 180;
hDome = 15;

up(hRing)
    ring(d = dRing, w = wall, h = wall, fn = fn);
ring(d = dRing - wall * 2, w = wall, h = hRing + wall, fn = fn);
up(hRing + wall)
    dome(d = dRing, w = wall, h = hDome, , hollow = true, fn = fn);


