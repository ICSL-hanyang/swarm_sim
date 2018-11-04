ArrayList<Vehicle> vehicles;
PImage drone;
int drone_num = 10;


void setup() {
  size(800, 600, P2D);
  drone = loadImage("ry.png");
  frameRate(50);
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < drone_num; i++) {
    vehicles.add((new Vehicle(new PVector(random(width), random(height)))));
  }
}

void draw() {
  background(255);
  draw_event();

  for (Vehicle v : vehicles) {
    v.applyBehaviors(vehicles);
    v.geofence();
    v.update();
    v.display();
  }


}
