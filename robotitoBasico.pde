Robotito robotito; //<>//

color cardColor, yellow, blue, green, red, violet, white, markerColor, strokeColor;
int cardSize, initPixelMat, inBoxMargin, maxPixelMat, lastSelectedZoneForViolet;
boolean puttingCards, stopRobot, taskSolved;
int offsetSensing;
int strokeThickness;

Card selectedCard;
int ignoredId;
ArrayList<Card> allCards;
PImage play;

void setup() {
  size(800, 800);
  //fullScreen();
  ellipseMode(CENTER);
  smooth();
  robotito = new Robotito(width/2, height/2);

  noStroke();
  background(255);
  rectMode(CENTER);
  imageMode(CENTER);

  play = loadImage("play.png");

  yellow = #FAF021;
  blue = #2175FA;
  red = #FA0F2B;
  green = #02E01A;
  violet = #A20FFF;
  white = #FFFFFF;
  markerColor = #000000;
  strokeColor = 185;

  cardColor = green;
  cardSize = 100;
  initPixelMat = 60;
  inBoxMargin = 40;
  maxPixelMat = initPixelMat + (cardSize+inBoxMargin)*4 ;
  lastSelectedZoneForViolet = -1;
  puttingCards = true;
  stopRobot = false;
  taskSolved = false;
  offsetSensing = cardSize/2;
  ignoredId = 0;
  strokeThickness = 4;

  newGame();
}

void draw() {
  //scale(1.2);
  drawMat();
  displayCards();
  if (!stopRobot) {
    robotito.update();
  }
  robotito.drawRobotitoAndLights();
  //checkIfNewCardNeeded();
}
void keyPressed() {
  if (key == 'n' || key == 'N') {
    newGame();
  }
}

void mouseReleased() {
  robotito.setIsSelected(false);
}

void mousePressed() {
  boolean foundOne = false;
  if (dist(robotito.xpos, robotito.ypos, mouseX, mouseY) < robotito.size/2)
  {
    robotito.setIsSelected(true);
    foundOne = true;
  } else {
    robotito.setIsSelected(false);
  }

  for (int i = allCards.size()-1; i >= 0; i--) {
    Card currentCard = allCards.get(i);
    if (currentCard.isPointInside(mouseX, mouseY) && !foundOne) {
      if (currentCard.id != 5) { // we do not move violet
        selectedCard =  currentCard;
        currentCard.setIsSelected(true);
        foundOne = true;
      }
    } else {
      currentCard.setIsSelected(false);
    }
  }
}
void mouseDragged() {
  for (Card currentCard : allCards) {
    if (currentCard.isPointInside(mouseX, mouseY) && currentCard.isSelected) {
      currentCard.updatePosition(mouseX, mouseY);
    }
  }
  // we do not allow to move robotito!!
  //if ((dist(robotito.xpos, robotito.ypos, mouseX, mouseY) < robotito.size/2) && robotito.isSelected)
  //{
  //  robotito.updatePositionDragged(mouseX, mouseY);
  //}
}

void newGame() {
  robotito.activeDirection = 0;
  allCards = new ArrayList<Card>();
  initWithCards(); // all the cards
  // define the violet card position
  Pair zoneBox = getZoneAndBox();
  Pair violetXY = getXYFromIds(zoneBox.x, zoneBox.y);

  for (Card currentCard : allCards) {
    if (currentCard.cardColor == violet) { // violet!
      currentCard.updatePosition(violetXY.x, violetXY.y);
    }
  }
  // define robots position (has to be in the same line as the card)
  int robotitoZone = (zoneBox.x+1)%4 + 1;
  Pair robotitoXY = getXYFromIds(robotitoZone, zoneBox.y);
  robotito.setXY(robotitoXY.x, robotitoXY.y);
  robotito.setRotation(0);
  taskSolved = false;
}

void addCard(int x, int y) {
  allCards.add(new ColorCard(x, y, cardSize, cardColor));
}
Pair getZoneAndBox() {
  // 1 top, 2 right, 3 bottom, 4 left
  int zone = getNewZone();
  // first, second, third, fourth
  int box = int(random(1, 5));
  return new Pair(zone, box);
}

int getNewZone() {
  // first, second, third, fourth
  int zone = int(random(1, 5));
  if (zone == lastSelectedZoneForViolet) {
    zone = (zone+1)%4 + 1;
  }
  lastSelectedZoneForViolet = zone;
  return zone;
}


Pair getXYFromIds(int zone, int box) {
  int cardX;
  int cardY;
  if (zone == 1 || zone == 3) {
    cardX = initPixelMat+(cardSize+inBoxMargin)/2+(cardSize+inBoxMargin)*(box-1);
    if (zone == 1) {
      cardY = initPixelMat+(cardSize+inBoxMargin)/2; // first row
    } else {
      cardY = initPixelMat+(cardSize+inBoxMargin)/2+(cardSize+inBoxMargin)*3; // last row
    }
  } else {
    cardY = initPixelMat+(cardSize+inBoxMargin)/2+(cardSize+inBoxMargin)*(box-1);
    if (zone == 2) {
      cardX = initPixelMat+(cardSize+inBoxMargin)/2+(cardSize+inBoxMargin)*3; // last column
    } else { // zone == 4
      cardX = initPixelMat+(cardSize+inBoxMargin)/2; // first column
    }
  }
  Pair p = new Pair(cardX, cardY);
  return p;
}

void drawMat() {
  background(255);
  stroke(0);
  strokeWeight(1);
  for (int i=initPixelMat; i<= maxPixelMat; i=i+cardSize+inBoxMargin) {
    line(initPixelMat, i, maxPixelMat, i);
  }
  for (int i=initPixelMat; i<= maxPixelMat; i=i+cardSize+inBoxMargin) {
    line(i, initPixelMat, i, maxPixelMat);
  }
}
void displayCards() {
  for (Card currentCard : allCards) {
    currentCard.addToBackground();
  }
}

void deleteSelectedCard() {
  allCards.remove(selectedCard);
}
void initWithCards() {
  int x = 0 + cardSize/2 + 10;
  int y = height - cardSize/2 -10;

  allCards.add(new ColorCard(x, y, cardSize, green, 1));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, red, 2));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, yellow, 3));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, blue, 4));
  x = x + cardSize + 10;
  allCards.add(new ColorCard(x, y, cardSize, violet, 5));
  x = width - cardSize/2-10;
  ImgCard playBtn = new ImgCard(x, y, cardSize, play, 6);
  playBtn.setIsVisible(false);
  allCards.add(playBtn);
}

void checkIfNewCardNeeded() {
  int x = 0 + cardSize/2 + 10;
  int y = height - cardSize/2 -10;
  if (get(x, y) != green) {
    allCards.add(new ColorCard(x, y, cardSize, green));
  }
  x = x + cardSize + 10;
  if (get(x, y) != red) {
    allCards.add(new ColorCard(x, y, cardSize, red));
  }
  x = x + cardSize + 10;
  if (get(x, y) != yellow) {
    allCards.add(new ColorCard(x, y, cardSize, yellow));
  }
  x = x + cardSize + 10;
  if (get(x, y) != blue) {
    allCards.add(new ColorCard(x, y, cardSize, blue));
  }
  x = x + cardSize + 10;
  if (get(x, y) != violet) {
    allCards.add(new ColorCard(x, y, cardSize, violet));
  }
}
