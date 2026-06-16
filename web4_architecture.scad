$fn = 64;

// User
translate([0,0,0])
cube([20,20,10]);

// CDN
translate([40,0,0])
cube([20,20,10]);

// Nginx
translate([80,0,0])
cube([20,20,10]);

// FastAPI
translate([120,0,0])
cube([30,30,15]);

// Blockchain
translate([180,0,0])
cylinder(h=20,r=12);

// AI Engine
translate([120,50,0])
sphere(r=15);

// Redis
translate([120,-50,0])
cube([20,20,10]);

// Connection lines
hull() {
    translate([10,10,5]) sphere(2);
    translate([50,10,5]) sphere(2);
}

hull() {
    translate([90,10,5]) sphere(2);
    translate([135,15,7]) sphere(2);
}
