ArrayList<Vehicle> vehicles;
PImage drone;
int droneNum = 15;


void setup() {
  size(800, 600, P2D);
  drone = loadImage("ry.png");
  frameRate(50);
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < droneNum; i++) {
    vehicles.add((new Vehicle(new PVector(random(width), random(height)), true)));
  }
}

void draw() {
  background(255);
  drawEvent();

  for (Vehicle v : vehicles) {
    v.applyBehaviors(vehicles);
    v.geofence();
    v.update();
    v.display();
    //PVector wind = new PVector(0.5,0);
    //v.applyForce(wind);
  }
}
