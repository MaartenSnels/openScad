use <maarten.scad>
pi = 3.1415;
rounded = 10;
wall = 40;
size = [250, 250, 10]; // de afmeting als we geen afgeronde hoeken hebben

box();
echo(sizeX(size, rounded, wall), sizeY(size, rounded, wall));

module box() {
    s = boxSize(size, rounded, wall);
    echo("size of teh box", s);
    roundedBox(s, w = wall, radius = 15);
}

function boxSize(size, radius, wall) = 
                               [sizeX(size, radius, wall)
                              , sizeY(size, radius, wall)
                              , size.z];
function sizeX(size, radius, wall) = 
            radius*(4 - pi)/(1+size.y / size.x) + size.x + wall * 2;  
function sizeY(size, radius, wall) = 
            radius*(4 - pi)/(1+size.x / size.y) + size.y + wall * 2;  
