ArrayList<Particle> particles; 
PImage drone;

int drone_num = 10;

void setup() {
  size(800, 600, P2D);
  drone = loadImage("ry.png");
  particles = new ArrayList<Particle>();
  
  for (int i = 0; i < drone_num; i++) {
    particles.add(new Particle(new PVector(random(-width/2,width/2), random(-height/2,height/2))));
  }
}


void draw() {
  background(255);

  for (int i = 0; i < particles.size(); i++) {
      Particle p = particles.get(i);
      p.updateVelocityAndPosition();  
    }
}
