PVector target_point = new PVector(0, 0);
boolean erase = false;
PVector drag_2 = new PVector(mouseX, mouseY);
PVector drag_1 = new PVector(mouseX, mouseY);

void drawEvent() {
  fill(255, 0, 0);
  stroke(0);
  strokeWeight(2);
  ellipse(target_point.x, target_point.y, 10, 10);

  //if (erase==false) {
  //  fill(10, 0, 200, 70);
  //  stroke(0);
  //  strokeWeight(2);
  //  rect(drag_1.x, drag_1.y, drag_2.x-drag_1.x, drag_2.y-drag_1.y);
  //}
}

void mouseDragged() {
  drag_2 = new PVector(mouseX, mouseY);
}

void mousePressed() {
  if (mouseButton == LEFT) {
    erase = false;
    drag_1 = new PVector(mouseX, mouseY);
    vehicles.add((new Vehicle(new PVector(mouseX, mouseY), true)));
  } else if (mouseButton == RIGHT) {
    target_point = new PVector(mouseX, mouseY);
  }
}
void mouseReleased(ArrayList<Vehicle> vehicles) {
  erase = true;
  //for (Vehicle other : vehicles) {
  //  if (position.x<drag_2.x && position.x>drag_1.x && position.y<drag_2.y && position.y >drag_1.y) {
  //  }
  //}
}

void keyPressed() {
  if (key == 'c') {
  } else if (key == '1') {
    mode = 1;
  } else if (key == '2') {
    mode = 2;
  } else if (key == '3') {
  } else if (key == CODED) {
    if (keyCode == RIGHT) {
    } else if (keyCode == LEFT) {
    } else if (keyCode == UP) {
    } else if (keyCode == DOWN) {
    }
  }
}
