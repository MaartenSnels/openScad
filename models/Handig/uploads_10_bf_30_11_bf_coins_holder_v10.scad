

// ###############################################################################
//
// Euro Coins
//
// Alexander Nischelwitzer
// 1/1/2014
//
// for shopping
//
// ###############################################################################

use <./write/write.scad>

use <MCAD/fonts.scad>
thisFont=8bit_polyfont();

// ###############################################################################

euro1_d = 23.17;
euro1_h =  2.37;

euro2_d = 25.68;
euro2_h =  2.19;

handle = 1; // 1 == true, draw holder

// ###############################################################################

translate([0,0,0])           euro1();
translate([1.1*euro2_d,0,0]) euro2();

// ###############################################################################

module euro1()
{

 difference()
  { 
    union() 
    {
      color([0,0,1]) cylinder(r = euro1_d/2, h = euro1_h);
      	if (handle) clip_holder(euro1_d/2, euro1_h);
    }
    color([1,0,1]) translate([0,0,euro1_h-1]) cylinder(r = (euro1_d-3)/2, h = euro1_h);
  };

  // color([1,0,1]) cylinder(r = euro1_d/2, h = euro1_h);
  // color([1,1,1]) translate([0,0,height+15]) sphere(4);

  translate([-4.0,-5.0,0]) rotate([0,0,0])
    color([1,1,0]) write("1",t=euro1_h,h=11,font="letters.dxf");
}

// ###############################################################################

module euro2()
{
 difference()
  {
    union() 
    {
      color([0,0,1]) cylinder(r = euro2_d/2, h = euro2_h);
      	if (handle) clip_holder(euro1_d/2, euro1_h);
    }
    color([1,0,1]) translate([0,0,euro2_h-1]) cylinder(r = (euro2_d-3)/2, h = euro2_h);
  };

  translate([-3.0,-5.0,0]) rotate([0,0,0])
    color([1,1,0]) write("2",t=euro2_h,h=11,font="letters.dxf");
}

// ###############################################################################

module clip_holder(radius, height) 
{
		translate([-4,0,0]) cube([8,30,height]);
		translate([0,33,0]) difference() {
			cylinder(r=6,h=height,$fn=30);
			translate([0,0,-0.05]) cylinder(r=2.5,h=height+0.1,$fn=30);
		}
}

// ###############################################################################

