overhangOnder = 55;       // overhang of bottom
overhangBoven = 35;       // overhang of top 
table         = 34.5;     // thickness of tabletop
dSpool        = 220;      // diameter of spool, to determine clearence from table
hSpool        = 70;       // height of the spool (not used for holder
wall          = .75;      // thickness of the wall
dBeam         = 09;       // thickness of the beams   
dOutHolder    = 25;       // diamter of spool holder
dInHolder     = 10;       // hole in spoolholder
fill          = true;     // fill space between beams
center        = false;    // Center part to middle of the beams,print with support
mirror        = true;     // if center is false, mirror the print
hClamp        = 21;       // height of the clamp
dScrew        = 14;       // diameter of clamping screw
surrounding   = false;    // show surrounding
hKnob         = 25;       // height of the knob on the clamp bolt
doPrint       = "all";    // [bolt, clamp, holder, all]
color         = "color1"; //[color1, color2, all]
nut           = 15;       // M8



/****************
** TODO
*****************
** -    afgeronde hoeken bij tafel
** done -    klem implementeren
** -    uiteindelijke spoolholder toevoegen??
** -    check of diameter echt klopt
*****************/


/*******************************
**    position of the points  ** 
********************************
**            _p2
**        __/   |\
**      p1------p0\
**              |  \
**              |   \     
**      p4------p5   \
**        \____       \
**             \____   \
**                  \__ \
**                      p3
*******************************/
p0 = [0, dBeam / 2, 0];
p1 = [-overhangBoven, dBeam / 2, 0];
p2 = [0, table + dBeam / 2];
p3 = [dSpool + dBeam, -(dSpool + dBeam), 0] * .50;  
p4 = [-overhangOnder, -table - dBeam / 2, 0];
p5 = -p2;

///// calculated //////////

/////// paths /////////////////////////
pathOut = [p0, p1, p2, p3, p4, p5];
pathCutOut = [p0, p1, p4, p5];

///////// render ///////////////////

doPrint();

//////////// modules //////////////////

module doPrint() {
    if (doPrint == "bolt") {
        bolt();
    } else 
    if (doPrint == "clamp") {
        print(clampOnly = true);
        translate(middle(p0, p4)) bolt();
    } else 
    if (doPrint == "holder") {
        print(clampOnly = false);
    } else {
        print(clampOnly = false);
        echo(middle(p0, p5));
        translate([p5.x + p0.x, p5.y + p0.y, 0] / (mirror ? -2 : 2) - [dBeam + dScrew, 0, 0]) 
            bolt();
    }
    if (surrounding) {
        %spool();
        %table();
    }
}



module print(clampOnly = false) {
    shift = center ? -(hClamp - dBeam) / 2 : 0;
    mirror([0, mirror ? -1 : 0,  0])
    difference() {
        union() {
            if(!clampOnly) {
                grip(fill);
                holder();
            }
            up(shift)
                clamp();
        }
        translate(p3)
            cylinder(d=dInHolder, h = hClamp * 3, center = true);
        up(shift) {
            screwHole();
        }
    }
}

module screwHole() {
    marge = 0.6;
    l = length(p0, p1);
    translate(middle(p0, p1) + [0, -dBeam, hClamp / 2])
        rotate([-90,0,0])
            mirror([0, mirror ? -1 : 0,  0])
                screw_thread(dScrew + marge, 4, 55, l, PI / 2,2);
    translate(middle(p0, p1) + [0, dBeam, hClamp / 2])
        rotate([-90,0,0])
            cylinder(d = dScrew + 2, h = l);
}

module clamp() {
    
    inside([p0, p1, p2], wall = hClamp, center = false);
    beam(p0, p5, hClamp);
    beam(p4, p5, hClamp);
}

module table() {
    x = hSpool * 4;
    y = table;
    z = x;
    translate([-x, -y, -z/2])
        cube([x, table, z]);
}
module spool() {
    start = dBeam * 1.2;
    hs = dBeam / 2;
    translate([p3.x, p3.y, start])
        cylinder(d=dSpool, hs);
    translate([p3.x, p3.y, start + hSpool])
        cylinder(d=dSpool, h = hs);
    translate([p3.x, p3.y, start])
        cylinder(d=dSpool / 3, h = hs + hSpool);
}
module holder() {
    up(center ? -(hClamp - dBeam) / 2 : 0)
        translate(p3)
            cylinder(d=dOutHolder, h = hClamp);
}

module grip(filled = true) {
    if (filled) {
        difference() {
            inside(pathOut, center = center);
            inside(pathCutOut, wall * 1.1, center = center);
        }
    }
    outside(pathOut);
    versteviging();
}

module versteviging() {
    hoek = atan(abs(p3.y - p2.y)/abs(p3.x - p2.x));
    y = p2.y - p5.y;
    x = y / tan(hoek); 
    beam(p0, p2);
    beam(p5, [p5.x + x, p5.y, 0]); //TODO nog te bepalen a.h.v. hoek
}

module outside(path) {
    for(i=[0:len(path) - 1]) {
        beam(path[i], path[i +1>= len(path) ? 0 : i+1]);
    }
}

module inside(path, wall = wall, center = true) {
    up(center ? (dBeam - wall) / 2 : 0)
    linear_extrude(height = wall)
        hull()  
            for(p=path) {
                translate(p) 
                    circle(d=dBeam);
            }
}

module beam(p1=[0, 0, 0], p2=[50, 50, 0], h = dBeam) {
    linear_extrude(height=h)
        hull() {
            translate(p1) 
                circle(d=dBeam);
            translate(p2) 
                circle(d=dBeam);
        }
}

module bolt(){
    length = length(p0, p1) + dBeam;

    up(center ? -(hClamp - dBeam) / 2 : 0) {
        knurled_cyl(hKnob, dScrew + 4, 2.5, 2.5, 1, 2, 10);
        up(hKnob)
            screw_thread(dScrew, 4, 55, length, PI/2,2);
        up(hKnob + length)
            cylinder(h = 1, d = dScrew - 4, $fn=30);
    }
}

module up(up=0) {
    translate([0, 0, up]) {
         children();
    }
}

///// FUNCTIONA
function middle(p0, p1) = (p0 + p1) / 2;
function length(p0, p1) = sqrt(pow(p0.x - p1.x, 2) + pow(p0.y - p1.y, 2)) + dBeam;


/////////// THIRD PARTY LIBRARIES /////////////////////////////
// copy past from   knurledFinishLib
//                  polyScrewThread
//
// otherwise the costomizer does not work
////////////////////////////////////////////////////////

module knurled_cyl(chg, cod, cwd, csh, cdp, fsh, smt)
{
    cord=(cod+cdp+cdp*smt/100)/2;
    cird=cord-cdp;
    cfn=round(2*cird*PI/cwd);
    clf=360/cfn;
    crn=ceil(chg/csh);

    intersection()
    {
        shape(fsh, cird, cord-cdp*smt/100, cfn*4, chg);

        translate([0,0,-(crn*csh-chg)/2])
          knurled_finish(cord, cird, clf, csh, cfn, crn);
    }
}

module shape(hsh, ird, ord, fn4, hg)
{
        union()
        {
            cylinder(h=hsh, r1=ird, r2=ord, $fn=fn4, center=false);

            translate([0,0,hsh-0.002])
              cylinder(h=hg-2*hsh+0.004, r=ord, $fn=fn4, center=false);

            translate([0,0,hg-hsh])
              cylinder(h=hsh, r1=ord, r2=ird, $fn=fn4, center=false);
        }

}

module knurled_finish(ord, ird, lf, sh, fn, rn)
{
    for(j=[0:rn-1]) {
        h0=sh*j;
        h1=sh*(j+1/2);
        h2=sh*(j+1);
    
        for(i=[0:fn-1]) {
            lf0=lf*i;
            lf1=lf*(i+1/2);
            lf2=lf*(i+1);
        
            polyhedron(
                points=[
                     [ 0,0,h0],
                     [ ord*cos(lf0), ord*sin(lf0), h0],
                     [ ird*cos(lf1), ird*sin(lf1), h0],
                     [ ord*cos(lf2), ord*sin(lf2), h0],

                     [ ird*cos(lf0), ird*sin(lf0), h1],
                     [ ord*cos(lf1), ord*sin(lf1), h1],
                     [ ird*cos(lf2), ird*sin(lf2), h1],

                     [ 0,0,h2],
                     [ ord*cos(lf0), ord*sin(lf0), h2],
                     [ ird*cos(lf1), ird*sin(lf1), h2],
                     [ ord*cos(lf2), ord*sin(lf2), h2]
                    ],
                faces=[
                     [0,1,2],[2,3,0],
                     [1,0,4],[4,0,7],[7,8,4],
                     [8,7,9],[10,9,7],
                     [10,7,6],[6,7,0],[3,6,0],
                     [2,1,4],[3,2,6],[10,6,9],[8,9,4],
                     [4,5,2],[2,5,6],[6,5,9],[9,5,4]
                    ],
                convexity=5);
         }
    }
}

module screw_thread(od,st,lf0,lt,rs,cs)
{
    or=od/2;
    ir=or-st/2*cos(lf0)/sin(lf0);
    pf=2*PI*or;
    sn=floor(pf/rs);
    lfxy=360/sn;
    ttn=round(lt/st)+1;
    zt=st/sn;

    intersection()
    {
        if (cs >= -1)
        {
            thread_shape(cs,lt,or,ir,sn,st);
        }

        full_thread(ttn,st,sn,zt,lfxy,or,ir);
    }
}

module hex_nut(df,hg,sth,clf,cod,crs)
{

    difference()
    {
        hex_head(hg,df);

        hex_countersink_ends(sth/2,cod,clf,crs,hg);

        screw_thread(cod,sth,clf,hg,crs,-2);
    }
}

module hex_screw(od,st,lf0,lt,rs,cs,df,hg,ntl,ntd)
{
    ntr=od/2-(st/2+0.1)*cos(lf0)/sin(lf0);

    union()
    {
        hex_head(hg,df);

        translate([0,0,hg])
        if ( ntl == 0 )
        {
            cylinder(h=0.01, r=ntr, center=true);
        }
        else
        {
            if ( ntd == -1 )
            {
                cylinder(h=ntl+0.01, r=ntr, $fn=floor(od*PI/rs), center=false);
            }
            else if ( ntd == 0 )
            {
                union()
                {
                    cylinder(h=ntl-st/2,
                             r=od/2, $fn=floor(od*PI/rs), center=false);

                    translate([0,0,ntl-st/2])
                    cylinder(h=st/2,
                             r1=od/2, r2=ntr, 
                             $fn=floor(od*PI/rs), center=false);
                }
            }
            else
            {
                cylinder(h=ntl, r=ntd/2, $fn=ntd*PI/rs, center=false);
            }
        }

        translate([0,0,ntl+hg]) screw_thread(od,st,lf0,lt,rs,cs);
    }
}

module thread_shape(cs,lt,or,ir,sn,st)
{
    if ( cs == 0 )
    {
        cylinder(h=lt, r=or, $fn=sn, center=false);
    }
    else
    {
        union()
        {
            translate([0,0,st/2])
              cylinder(h=lt-st+0.005, r=or, $fn=sn, center=false);

            if ( cs == -1 || cs == 2 )
            {
                cylinder(h=st/2, r1=ir, r2=or, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }

            translate([0,0,lt-st/2])
            if ( cs == 1 || cs == 2 )
            {
                  cylinder(h=st/2, r1=or, r2=ir, $fn=sn, center=false);
            }
            else
            {
                cylinder(h=st/2, r=or, $fn=sn, center=false);
            }
        }
    }
}

module full_thread(ttn,st,sn,zt,lfxy,or,ir)
{
    for(i=[0:ttn-1])
    {
        for(j=[0:sn-1])
        {
            polyhedron(
                  points=[
                          [0,                  0,                  i*st-st            ],
                          [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt-st   ],
                          [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt-st       ],
                          [or*cos((j+1)*lfxy), or*sin((j+1)*lfxy), i*st+(j+1)*zt-st/2 ],
                          [or*cos(j*lfxy),     or*sin(j*lfxy),     i*st+j*zt-st/2     ],
                          [0,                  0,                  i*st+st            ],
                          [ir*cos((j+1)*lfxy), ir*sin((j+1)*lfxy), i*st+(j+1)*zt      ],
                          [ir*cos(j*lfxy),     ir*sin(j*lfxy),     i*st+j*zt          ]
                         ],
               faces=[
                          [0,1,2],
                          [5,6,3],[5,3,0],[0,3,1],
                          [3,4,1],[1,4,2],
                          [3,6,4],[4,6,7],
                          [0,2,4],[0,4,5],[5,4,7],
                          [5,7,6]
                         ],
               convexity=5);
        }
    }
}

module hex_head(hg,df)
{
    cylinder(h=hg, r=df/2/sin(60), $fn=6, center=false);
}

module hex_countersink_ends(chg,cod,clf,crs,hg)
{
    translate([0,0,-0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2, 
             r2=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             $fn=floor(cod*PI/crs), center=false);

    translate([0,0,hg-chg+0.1])
    cylinder(h=chg+0.01, 
             r1=cod/2-(chg+0.1)*cos(clf)/sin(clf),
             r2=cod/2, 
             $fn=floor(cod*PI/crs), center=false);
}

module nut() {
}

