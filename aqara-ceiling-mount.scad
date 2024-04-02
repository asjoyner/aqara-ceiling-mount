// All dimension are in inches

// User-Modifiable Constants
mountdiameter=8;
mountheight=1.4;
shellThickness=0.2;

ceilingPlateThickness = 0.25;
ceilingPlateDiameter = 4.5;
rimheight = 0.5;      // height of the alignment rim
rimwidth = 0.2;       // width of the alignment rim
riminset = 0.2;       // inset of the alignment rim from the edge of the ceiling plate
tabextension=0.1;     // how far the tabs stick out from the rim
tabthickness=0.1;     // thickness of the locking tabs
tabwidth=16;          // width of the locking tabs, in degrees

// US outlet holes use 6/32 screws that are 3 9/32" apart
screwDiameter = 0.15; // 6/32 screw diameter is 0.138"
screwholeseparation = 3.28125;
screwholeClearance = 0.15;
boxopeningheight = screwholeseparation-screwDiameter-screwholeClearance;
boxopeningwidth = 2.09;

fitFactor = 1.02;      // how much clearance to give between the ceiling plate and the mount interface fit


// Internal constants
$fa = 1;
$fs = 0.05;
overlap = 0.001;
include <BOSL/constants.scad>
use <BOSL/shapes.scad>
use <BOSL/transforms.scad>

// Computed Intermediate Dimensions
rimexterior = ceilingPlateDiameter - riminset;
riminterior = rimexterior - riminset;
tabexterior=rimexterior+tabextension;
screwholeOffset = screwholeseparation/2;

mountCutPoint=mountdiameter/2-mountheight;


translate([ceilingPlateDiameter*1.5,0,0])
ceilingPlate();

housing();

module housing() {
    difference() {
        housingFace();
        scale([fitFactor, fitFactor, fitFactor])
        translate([0,0,-0.01])
        render() {  // precompute this as a single shape
            sixLockingTabChannels();
            ceilingPlateInterface();
        }
    }
}

// TODO: Deleteme
module housingTop() {
    difference() {
        housingShell();
        translate([0,0,-shellThickness])
        housingShell();
    }
}

module housingFace() {
    translate([0, 0, -mountCutPoint])
    top_half(cp=mountCutPoint)
    //color("white")
    sphere(d=mountdiameter, $fa=5, $fs=0.1);
}

module ceilingPlateInterface() {
    cylinder(ceilingPlateThickness, d=ceilingPlateDiameter);

    difference() {
        cylinder(rimheight, d=rimexterior);

        translate([0,0,-overlap])
        cylinder(rimheight + (overlap*2), d=riminterior);
    }
    sixlockingtabs();
}

module ceilingPlate() {
    difference() {
        ceilingPlateInterface();
        
        translate([0, screwholeOffset, 0])
        screwhole();
        translate([0, -screwholeOffset, 0])
        screwhole();

        boxopening();
    }

}

module boxopening() {
    sheight=(screwholeOffset*2)-screwDiameter-(screwholeClearance*2);
    swidth=sheight/2;
    translate([0, 0, ceilingPlateThickness/2])
    cube([swidth, sheight, ceilingPlateThickness+(overlap*2)], center=true);
}

module screwhole() {
    translate([0,0,-overlap])
    cylinder(ceilingPlateThickness+(overlap*2), screwDiameter, screwDiameter);
}

module sixlockingtabs() {
    for (i = [0:60:360]){
        rotate([0, 0, i])
        lockingtab();
    }
}

module lockingtab() {
    difference() {
        translate([0,0,rimheight-tabthickness])
        color("red")
        pie_slice(ang=tabwidth, h=tabthickness-overlap, d=tabexterior);

        cylinder(rimheight+overlap, d=rimexterior);
    }
}

module lockingTabChannel() {
    difference() {
        //translate([0,0,rimheight])
        color("red")
        pie_slice(ang=tabwidth, h=rimheight-overlap, d=tabexterior);

        cylinder(rimheight+overlap, d=rimexterior);
    }
}

module sixLockingTabChannels() {
    for (i = [0:60:360]){
        rotate([0, 0, i+5])
        lockingTabChannel();
    }
}