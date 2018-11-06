class Vehicle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector origin_position;

  float size;
  float m;
  float k;
  float b;

  float maxForce;    
  float maxSpeed;    

  PShape part;
  float partSize;

  Vehicle(PVector o, boolean selected) {
    position = o.copy();
    origin_position = o.copy();
    size = 30;
    m=1;
    maxSpeed = 4;
    maxForce = 0.5;
    acceleration = new PVector(0, 0);
    //velocity = new PVector(random(-1, 1), random(-1, 1));
    velocity = new PVector(0, 0);

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
    PVector seekOriginForce = seek(origin_position);

    //separateForce.mult(3);
    //seekForce.mult(1);
    //cohesionForce.mult(1);
    //seekOriginForce.mult(1);
    //applyForce(separateForce);
    //applyForce(seekForce);
    //applyForce(seekOriginForce);
    //applyForce(cohesionForce);
    if (mode == 1) {
      separateForce.mult(2);
      seekForce.mult(1);
      applyForce(separateForce);
      applyForce(seekForce);
    } else if (mode == 2) {
      seekOriginForce.mult(1);
      separateForce.mult(1);
      applyForce(seekOriginForce);
      applyForce(separateForce);
    }
  }
  
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position); 
    float d = PVector.dist(target, position);
    float dampSpeed = map(d, 0, size*3, 0, maxSpeed);
    desired.normalize();
    //desired.mult(maxSpeed);
    if (d < size*4) {
      desired.mult(dampSpeed);
    } else {
      desired.mult(maxSpeed);
    }
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxForce);
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
        println(count);
      }
    }
    if (count > 0) {
      sum.div(count);
      sum.normalize();
      sum.mult(maxSpeed);
      sum.sub(velocity);
      sum.limit(maxForce);
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
    velocity.limit(maxSpeed);
    position.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    part.resetMatrix();
    part.translate(position.x, position.y); 
    shape(part);
    //if (selected==true) {
    //  fill(255, 0, 0,30);
    //  stroke(0);
    //  strokeWeight(2);
    //  ellipse(position.x, position.y, 50, 50);
    //}
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
