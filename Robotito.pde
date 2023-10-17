class Robotito { //<>//
  int size, ypos, xpos, speed, directionX, directionY, activeDirection, currentRotation;
  color lastColor;
  boolean isSelected;
  Look look;
  Robotito (int x, int y) {
    xpos = x;
    ypos = y;
    speed = 1;
    size = 100;
    currentRotation = 0;
    look = new Look(size);
    directionX = directionY = activeDirection = 0;
    lastColor = white;
    isSelected = false;
  }
  void update() {
    xpos += speed*directionX;
    ypos += speed*directionY;
    checkRotation();
    checkRobotitoPosition(); // updates posistions and directions if necessary 
    // calculate offset necesary to change direction in the middle of the card depending direction
    int offsetX = directionX*offsetSensing*-1;
    int offsetY = directionY*offsetSensing*-1;

    for (Card currentCard : allCards) {
      if (currentCard.isPointInside(xpos+offsetX, ypos+offsetY)) {
        if (currentCard.id != ignoredId && !isSelected) {
          processColorAndId(currentCard.cardColor, currentCard.id);
        }
      }
    }
  }
  
  void checkRotation(){
    if(taskSolved){
      currentRotation +=1;
    }
    currentRotation = currentRotation%360;
  }
  void checkRobotitoPosition() {
    if ((ypos+size/2) > maxPixelMat) { // over bottom line
      ypos = ypos - 1;
      directionY = 0;
    } else if ((ypos-size/2) < initPixelMat) { //above top line
      ypos = ypos + 1;
      directionY = 0;
    }
    if ((xpos+size/2) > maxPixelMat) { // over bottom line
      xpos = xpos - 1;
      directionX = 0;
    } else if ((xpos-size/2) < initPixelMat) { //above top line
      xpos = xpos + 1;
      directionX = 0;
    }
  }

  void drawRobotitoAndLights() {
    drawRobotito();
    //circle(xpos+offsetX, ypos+offsetY, 10); // debugging sensing position
    translate(xpos, ypos);
    rotate(radians(currentRotation));
    //draw4lights();
    look.drawArrows();
    look.drawDirectionLights(activeDirection);
  }

  void updatePositionDragged(int x, int y) {
    directionX = 0;
    directionY = 0;
    activeDirection = 0;
    currentRotation = 0;
    if ((y < maxPixelMat) && (y > initPixelMat)) { // restricted to the mat size
      ypos = y;
    }
    if ((x < maxPixelMat) && (x > initPixelMat)) { // restricted to the mat size
      xpos = x;
    }
    ignoredId = -1;
  }
  void drawRobotito() {
    fill(look.colorRobotito);
    stroke(strokeColor);
    strokeWeight(1);
    circle(xpos, ypos, size);
    fill(255);
    noStroke();
    circle(xpos, ypos, size*0.62);
    fill(200);
    circle(xpos, ypos, size*0.52);
    fill(255);
    circle(xpos, ypos, size*0.42);
  }


  void processColorAndId(color currentColor, int id) {
    if (currentColor == green || currentColor == yellow || currentColor == red || currentColor == blue || currentColor == violet) {
      if (currentColor == green) {
        directionY = -1;
        directionX = 0;
        activeDirection = 1;
      } else if (currentColor == blue) {
        directionY = 0;
        directionX = 1;
        activeDirection = 2;
      } else if (currentColor == red) {
        directionY = 1;
        directionX = 0;
        activeDirection = 3;
      } else if (currentColor == yellow) {
        directionY = 0;
        directionX = -1;
        activeDirection = 4;
      } else if (currentColor == violet) {
        directionY = 0;
        directionX = 0;
        activeDirection = 5;
        taskSolved = true;
      }
    }
    ignoredId = id;
  }

  void setIsSelected(boolean is) {
    isSelected = is;
  }

  void setXY(int x, int y) {
    xpos = x;
    ypos = y;
  }
  
  void setRotation(int ro){
    currentRotation = ro;
  }
}
