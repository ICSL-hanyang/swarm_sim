class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector origin_pos;
  float m;
  float g;
  float d;

  PShape part;
  float partSize;

  Particle(PVector o) {
    origin_pos = o.copy();
    position = new PVector(random(-width/2, width/2), random(-height/2, height/2));
    velocity = new PVector(random(-1, 1), random(-1, 1));
    acceleration = new PVector(0, 0);
    m = 5;

    //이미지 형상
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


  void resetAcceleration() {
    acceleration = PVector.mult(acceleration, 0);
  }

  void updatePartialAcceleration(Particle neighbor, boolean clicked) {
    if (neighbor != this) {
      PVector dist = PVector.sub(position, neighbor.position);
      //      d = PVector.dist(position, neighbor.position);

      //      float common;
      //      if (d < 1) d = 1;          //너무 가까우면 1로봄 common이 너무 커지지 않게
      //      if (clicked) {
      //        common = m * neighbor.m / (d*d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      //      } else {
      //        common = abs(m) * abs(neighbor.m) / (d);  //m의 곱을 거리로 나눔, m이 커봐야 8이니까 common은 최대 64
      //      }
      //      acceleration = PVector.add(dist.mult(common), acceleration);
    }
  }

  void updateVelocityAndPosition() {
    velocity = PVector.add(velocity.mult(1), acceleration.mult(g));
    position.add(velocity);

    pushMatrix();
    translate(width/2, height/2);
    shape(part);
    popMatrix();
    part.translate(velocity.x, velocity.y); 


    if ((position.x < -width/2) || (position.x > width/2)) {
      velocity.x *= -1;   //벽에 튕기는 코드
      acceleration.x *= -1;
    }
    if ((position.y < -height/2) || (position.y > height/2)) {
      velocity.y *= -1;
      acceleration.y *= -1;
    }
  }
}
