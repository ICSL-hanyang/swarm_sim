class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float size;
  float m;
  float k;
  float b;
  float maxforce;    
  float maxspeed;    

  PShape part;
  float partSize;

  Vehicle(PVector o, boolean selected) {
    position = o.copy();
    size = 30;
    m=1;
    maxspeed = 4;
    maxforce = 0.5;
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));

    partSize = 50;
    part = createShape();
    part.beginShape(QUAD);
    part.noStroke();
    part.texture(drone);
    part.normal(0, 0, 1);
    part.vertex(-partSize/2, -partSize/2, 0, 0);
    part.vertex(+partSize/2, -partSize/2, drone.width, 0);
    part.vertex(+partSize/2, +partSize/2, drone.width, drone.height);
    part.vertex(-partSize/2, +partSize/2, 0, drone.height);
    part.resetMatrix();
    part.translate(position.x, position.y); 
    part.endShape();
  }

  void applyForce(PVector force) {
    PVector f = force;
    f.div(m);   
    acceleration.add(f);
  }

  void applyBehaviors(ArrayList<Vehicle> vehicles) {
    PVector separateForce = separate(vehicles);
    PVector seekForce = seek(target_point);
    PVector cohesionForce = cohesion(vehicles);
    separateForce.mult(3);
    seekForce.mult(1);
    cohesionForce.mult(1);
    applyForce(separateForce);
    applyForce(seekForce);
    //applyForce(cohesionForce);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position); 
    float d = PVector.dist(target, position);
    float dampSpeed = map(d, 0, size*3, 0, maxspeed);
    desired.normalize();
    //desired.mult(maxspeed);
    if (d < size*4) {
      desired.mult(dampSpeed);
    } else {
      desired.mult(maxspeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    return steer;
  }

  PVector separate (ArrayList<Vehicle> vehicles) {
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < size * 2)) {
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        
        sum.add(diff);
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }

  PVector cohesion (ArrayList<Vehicle> vehicles) {
    float dist = 200;
    PVector sum = new PVector(0, 0);  
    int count = 0;
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < dist)) {
        sum.add(other.position); 
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);
    }
    return sum;
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  void display() {
    part.resetMatrix();
    part.translate(position.x, position.y); 
    shape(part);
  }
  void geofence() {
    if ((position.x <0) || (position.x > width)) {
      velocity.x *= -1;   
      acceleration.x *= -1;
    }
    if ((position.y < 0) || (position.y > height)) {
      velocity.y *= -1;
      acceleration.y *= -1;
    }
  }
}
