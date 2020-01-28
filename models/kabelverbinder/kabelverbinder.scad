$fn = 60;
dDraad = 12;
aantalDraden = 3;
kroonsteen = [10, 15, 8];
tussenRuimte = 6;

kroonsteen();

module kroonsteen() {
    d = tussenRuimte + 2;
    for (i = [0 :aantalDraden - 1]) {
        echo(i);
        translate([kroonsteen.x + tussenRuimte, 0, 0] * i) {
            cube(kroonsteen, center = true);
            pijp(tussenRuimte, tussenRuimte - 2, kroonsteen.z / 2 + 2, false);
            translate([(kroonsteen.x + tussenRuimte)/ 2, 0, 0])
            pijp(d, d/2, kroonsteen.z / 2);
        }
    }
}

module pijp(dOut = 10, dIn = 8, h = 20, center = true){
    translate([0, 0, center ? 0 : h / 2]) 
    difference() {
        cylinder(d = dOut, h = h, center = true);
        cylinder(d = dIn,  h = h * 2, center = true);
    }
}