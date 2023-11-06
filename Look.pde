class Look {
  final int ledSize, arrowSize, arrowShift, triangleSize;
  final color colorRobotito;
  final float ledDistance;

  Look(int size) {
    ledSize= size/20;
    arrowSize = size/6;
    arrowShift = arrowSize/2+1;
    triangleSize = arrowSize/2;
    ledDistance = size*0.52/2-ledSize/2;
    colorRobotito = #FCB603;
  }

  void drawArrows() {
    strokeWeight(1);
    noStroke();
    pushMatrix();
    translate(0, -ledDistance - arrowShift);
    // stroke(green);
    fill(green);
    drawArrow(arrowSize);
    popMatrix();
    // red light
    pushMatrix();
    rotate(radians(180));
    translate(0, -ledDistance - arrowShift);
    // stroke(red);
    fill(red);
    drawArrow(arrowSize);
    popMatrix();
    //yellow
    pushMatrix();
    rotate(radians(270));
    translate(0, -ledDistance - arrowShift);
    // stroke(yellow);
    fill(yellow);
    drawArrow(arrowSize);
    popMatrix();
    //blue
    pushMatrix();
    rotate(radians(90));
    translate(0, -ledDistance - arrowShift);
    // stroke(blue);
    fill(blue);
    drawArrow(arrowSize);
    popMatrix();
  }

  void drawArrow(int aSize) {
    triangle(0, -aSize, triangleSize/2, -aSize+triangleSize, -triangleSize/2, -aSize+triangleSize);
    // CENTER MODE!!
    rect(0, 0-(aSize-triangleSize)/2, triangleSize/2, (aSize-triangleSize));
  }
  
  void draw4lights() {
    // 4 lights
    // green light
    pushMatrix();
    translate(0, -ledDistance);
    fill(green);
    stroke(strokeColor);
    circle(0, 0, ledSize);
    popMatrix();
    // red light
    pushMatrix();
    rotate(radians(180));
    translate(0, -ledDistance);
    fill(red);
    circle(0, 0, ledSize);
    popMatrix();
    //yellow
    pushMatrix();
    rotate(radians(270));
    translate(0, -ledDistance);
    fill(yellow);
    circle(0, 0, ledSize);
    popMatrix();
    //blue
    pushMatrix();
    rotate(radians(90));
    translate(0, -ledDistance);
    fill(blue);
    circle(0, 0, ledSize);
    popMatrix();
  }
  
  void drawDirectionLights(int activeDirection) {
    switch(activeDirection) {
    case 1: // green
      drawArc(0, green);
      break;
    case 2: // blue
      drawArc(90, blue);
      break;
    case 3: // red
      drawArc(180, red);
      break;
    case 4: // yellow
      drawArc(270, yellow);
      break;
    case 5: // violet
      drawAllViolet();
      break;
    }
  }

  void drawArc(int rotation, color ledArcColor) {
    pushMatrix();
    rotate(radians(rotation));
    translate(0, -ledDistance);
    fill(ledArcColor);
    stroke(strokeColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(rotation) + radians(360/24));
    translate(0, -ledDistance);
    fill(ledArcColor);
    stroke(strokeColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(rotation)+radians(360/24)*2);
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
    // left
    pushMatrix();
    rotate(radians(rotation)-radians(360/24));
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(rotation)-radians(360/24)*2);
    translate(0, -ledDistance);
    fill(ledArcColor);
    circle(0, 0, ledSize);
    popMatrix();
  }
  void drawAllViolet() {
    for (int i=0; i<24; i++) {
      pushMatrix();
      rotate(radians(i*360/24));
      translate(0, -ledDistance);
      fill(violet);
      stroke(strokeColor);
      circle(0, 0, ledSize);
      popMatrix();
    }
  }

  void drawSmile() {
    pushMatrix();
    rotate(radians(45)); //eye right
    translate(0, -ledDistance);
    fill(violet);
    stroke(strokeColor);
    circle(0, 0, ledSize);
    popMatrix();
    pushMatrix();
    rotate(radians(315)); //eye left
    translate(0, -ledDistance);
    circle(0, 0, ledSize);
    popMatrix();
    for (int i=0; i<12; i++) {
      pushMatrix();
      rotate(radians(90)+radians(360/24)*i);
      translate(0, -ledDistance);
      circle(0, 0, ledSize);
      popMatrix();
    }
  }
}
