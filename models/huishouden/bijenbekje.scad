/*
    Bijenbekje
 */
 
lengte          = 45;
breedte         = 15;
dikteGrondplaat = 1.5;

bekje();

module bekje() {
    difference() {
        grondplaat();
        uitsparingen();
    }
}

//!grondplaat();
module grondplaat() {
    cube ([lengte, breedte, dikteGrondplaat]);
}

//!uitsparingen();
module uitsparingen() {
    aantal = (lengte - dikteGrondplaat) / (dikteGrondplaat * 2) - 1;
    echo(aantal = aantal);
    for (i = [0 : aantal]) {
        translate([dikteGrondplaat * (1 + i * 2)
                 , dikteGrondplaat
                 , -dikteGrondplaat]) {
            cube([dikteGrondplaat
                , breedte - 2 * dikteGrondplaat
                , 3 * dikteGrondplaat]);
        }
    }
}