use <maarten.scad>

/////// CONSTANTS ///////////////
card = [100, 7, 65];
spaceBetweenCards = 5;
numberOfCards = 10;

/////// CALCULATED VALUES ///////////////
xHolder = card.x / 2; 
yHolder = card.x / 2;
zHolder = card.z  + spaceBetweenCards * 2;


cardHolder(numberOfCards);
//cardSlot();

module cardHolder(cards = 6) {
    y = cards * card.y + (cards + 1) * spaceBetweenCards;
    difference() {
        holder(y);
        for(i=[0 : cards - 1]) {
            translate([spaceBetweenCards
                     , spaceBetweenCards * (i  + 1) + card.y * i 
                     , card.z * 0.1])
                cardSlot();
        }
    }
}


module cardSlot() {
    cube (card);
}

module holder(y = yHolder) {
    size = [xHolder, y, zHolder];
    difference() {
        fullRoundedCube(size, center = false, radius = 4);
        rt(r=[0, -45, 0], t=[size.x * 1.3, -size.y * .05, 0])
            fullRoundedCube(size * 1.1, radius = 4);
    }
}

module wallMount() {
    difference() {
        cube([40, 70, 30]);
        #translate([-30, -5, 10]) 
            cube([40, 80, 10]);
    }
}
