int points = 0;
int ammunition = 10;

int bombs = 5;
int bombSize = 20;
PVector[] bombsPlacement;
float[] bombsVelocity;

int shieldX;
int shieldY;
int shieldWidth;
int shieldHeight;
boolean activated;

int enemyY;
int enemyX;
int enemyWidth;
int enemyHeight;

PVector[] townPlacement;

color referenceColor = color (180,7,45);
color atmosphereColor;
color bombsColor;
color planetColor;
color shieldColor;
color spaceshipColor;
color townColor;

boolean gameEnd;
String endString;
// ===========================================================================
// Creation functions ========================================================
// ===========================================================================
void createBombs(){
  bombsPlacement = new PVector[bombs];
  bombsVelocity = new float[bombs];
  for (int id = 0; id < bombs; id++){
    bombsPlacement[id] = new PVector();
    bombsVelocity[id] = random(0,6);
    bombsPlacement[id].set(int(random( enemyX , enemyX + enemyWidth - bombSize/2 )), int(random( enemyY + 2 * enemyHeight/3 + bombSize/2, enemyY + enemyHeight - bombSize/2 )) );
  }
}

void createShield(){
  shieldX = 0;
  shieldY = int(random(0.6,0.75) * height);
  shieldWidth = width;
  shieldHeight = int(0.05 * height);
  activated = false;

}

void createTown(int buildings){
  townPlacement = new PVector[buildings];
  int middle = 0;

  if (buildings % 2 == 0){
    middle = buildings/2 - 1;
  }
  else {
    middle = (buildings + 1)/2 - 1;
  }

  float buildingOffsetX = 0.05 * width;

  for (int building = 0; building < buildings; building++){
    townPlacement[building] = new PVector();

    if (building == middle){
      townPlacement[building].x = width/2 - buildingOffsetX;
      townPlacement[building].y = 0.82 * height;
    }
    else if (building < middle){
      townPlacement[building].x = int(random(0.15 * width, width/2 - buildingOffsetX) - 0.15 * width);
      townPlacement[building].y = random(0.82, 0.9) * height;
    }
    else if (building > middle) {
      townPlacement[building].x = int(random(width/2 + 0.15 * width + buildingOffsetX, width - buildingOffsetX));
      townPlacement[building].y = random(0.82, 0.9) * height;
    }

  }
}

void createSpaceship(){
  enemyY = int(0.005 * height);
  enemyX = int(0.05 * width);
  enemyWidth = int(0.9 * width);
  enemyHeight = int (0.1 * height);
}




// ===========================================================================
// LOGIC FUNCTIONS ===========================================================
// Update function to make bombs logic and shield logic
// ===========================================================================
void update(){
  for (int bomb = 0; bomb < bombsPlacement.length; bomb++){
    float velocity = bombsVelocity[bomb];
    float bombX = bombsPlacement[bomb].x;
    float bombY = bombsPlacement[bomb].y;
    float bombRadius = bombSize/2;
    bombsPlacement[bomb].y += velocity;
    for (int rectangle = 0; rectangle < townPlacement.length; rectangle++){
      if(intersect(bombX, bombY, bombRadius, townPlacement[rectangle].x, townPlacement[rectangle].y, 0.1 * width, 0.08 * height)){
        endGame();
      }
      if(intersect(bombX, bombY, bombRadius, 0, 0.9 * height, width, 0.2 * height)){
        endGame();
      }
    }
  }
}

void destroyBomb(int bombID){
  bombsPlacement[bombID].y = enemyY + 2 * enemyHeight/3;
  points++;
}

void endGame(){
  gameEnd = true;
}

void shoot(){
    if (ammunition > 0){
      ammunition--;
      activated = true;
      for (int bomb = 0; bomb < bombsPlacement.length; bomb++){
        float bombY = bombsPlacement[bomb].y;
        if (bombY >= shieldY && bombY <= shieldY + shieldHeight){
          destroyBomb(bomb);
        }
      }
    }
}

void recharge(){
  ammunition = 10;
}

void restart(){
  ammunition = 10;
  gameEnd = false;
  points = 0;
  endString = "";
  createTown(5);
  createBombs();
  createShield();
}
// ===========================================================================
// Draw Functions ===========================================================
// ===========================================================================
void draw(){
  if(!gameEnd){
    update();
  }
  else{
    endString = "BoOoOoOoOoOoOoOoOoooooooommmmmmm";
  }
  drawBackground();
  drawTown();
  drawShield();
  drawBomb();
  drawEnemy();
  pushStyle();
  fill(0);
  textAlign(CENTER);
  text("Points: " + points, 0.10 * width, 0.05 * height);
  text("Ammunition: " + ammunition, 0.85 * width, 0.05 * height);
  text(endString, width/2, shieldY + shieldHeight/2);
  popStyle();
}
// Drawing functions for better readability
void drawBackground(){
  background(planetColor);
}
void drawTown(){
  pushStyle();

  fill(atmosphereColor);
  noStroke();
  rect(0, 0.8 * height, width, 0.2 * height);
  fill(hue(townColor), saturation(townColor), brightness(townColor) - 10); // Making the color with less brightness to make a visual effect of distance
  rect(0,0.90 * height, width, 0.2 * height);
  for (int y = 0; y < 12; y++){
    for (int x = 0; x < 64; x++){
      pushStyle();
      fill(317,18,21); // Gray for every back window
      rect(width/128 + x * width/64, 0.91 * height + y * height * 0.01, width/128, height/128);
      popStyle();
    }
  }

  // Buildings
  fill(townColor); // Setting the colors to the upfront buildings
  for (int id = 0; id < townPlacement.length; id++){
    if(townPlacement.length % 2 == 1 && id == (townPlacement.length + 1)/2 - 1){
      rect(townPlacement[id].x, townPlacement[id].y, 0.1 * width, height - townPlacement[id].y);
      rect(townPlacement[id].x - 0.01 * width, townPlacement[id].y + 0.02 * height, 0.12 * width, height - townPlacement[id].y + 0.02 * height);
      rect(townPlacement[id].x - 0.025 * width, townPlacement[id].y + 0.04 * height, 0.15 * width, height - townPlacement[id].y + 0.04 * height);
      for (int y = 0; y < 12; y++){
        for (int x = 0; x < 4; x++){
          if (y > 1){
            pushStyle();
            fill(shieldColor);
            rect(townPlacement[id].x - width * 0.014 + x * width * 0.04,townPlacement[id].y + height * 0.005 + y * height * 0.02, width * 0.01, height * 0.01);
            popStyle();
          }
          else{
            if(x == 3){
              continue;
            }
            pushStyle();
            fill(shieldColor);
            rect(townPlacement[id].x + width * 0.005 + x * width * 0.04,townPlacement[id].y + height * 0.005 + y * height * 0.02, width * 0.01, height * 0.01);
            popStyle();
          }
        }
      }
    }
    else{
      rect(townPlacement[id].x, townPlacement[id].y, 0.1 * width, height - townPlacement[id].y);
      for (int y = 0; y < 12; y++){
        for (int x = 0; x < 3; x++){
          pushStyle();
          fill(0);
          if(id < townPlacement.length/2){
            rect(townPlacement[id].x + width * 0.04 + x * width * 0.02,townPlacement[id].y + height * 0.005 + y * height * 0.02, width * 0.01, height * 0.01);
          }
          else if ( id > townPlacement.length/2 ){
            rect(townPlacement[id].x + width * 0.005 + x * width * 0.02,townPlacement[id].y + height * 0.005 + y * height * 0.02, width * 0.01, height * 0.01);
          }
          popStyle();
        }
      }
    }
  }
  // Central arc for the town
  stroke(255);
  /* fill(shieldColor); */
  if(activated) fill(shieldColor);
  if(!activated) noFill();
  arc(width/2, 0.82 * height, 0.1 * width, 0.02* height, PI, TWO_PI);

  popStyle();
}

void drawEnemy(){
  noStroke();
  fill(spaceshipColor);
  triangle(enemyX, enemyY + 0.6 * enemyHeight, enemyX + enemyWidth * 0.5, enemyY + 0.3 * enemyHeight, width - enemyX, enemyY + 0.6 * enemyHeight);
  rect(enemyX, enemyY + enemyHeight * 0.6, enemyWidth, enemyHeight * 0.3);
  arc(enemyX + enemyWidth * 0.5 , enemyY + enemyHeight * 0.9, 0.90 * width, height * 0.08, 0, PI);

}

void drawBomb(){
  fill(bombsColor);
  for (int id = 0; id < bombsPlacement.length; id++){
    circle(bombsPlacement[id].x, bombsPlacement[id].y, bombSize);
  }
}

void drawShield(){
  pushStyle();
  fill(shieldColor);
  if(activated) stroke(255);
  rect(shieldX, shieldY, shieldWidth, shieldHeight);
  popStyle();
}


// ===========================================================================
// Helper Functions ==========================================================
// ===========================================================================
String getStringColorDebug(color c){
 String text = "Color (HSB): ";
 colorMode(HSB, 360,100,100);
 text += hue(c) + "," + saturation(c) + "," + brightness(c);
 return text;
}

// [Circle x Rect intersect]
boolean intersect(float cx, float cy, float r, float rx, float ry, float rw, float rh){
  float testX = cx;
  float testY = cy;
  if (cx < rx) testX = rx; // left edge
  else if (cx > rx+rw) testX = rx + rw; // right edge
  if (cy < ry) testY = ry; // top edge
  else if (cy > ry+rh) testY = ry + rh; // bottom edge

  float distX = cx-testX;
  float distY = cy-testY;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= r){
    return true;
  }
  return false;
}

// [Rect x Rect intersect]
boolean intersect(float r1x, float r1y, float r1width, float r1height, float r2x, float r2y, float r2width, float r2height){
  if ( r1x + r1width < r2x ){
    return false;
  }
  if ( r2x + r2width < r1x ){
    return false;
  }
  if (r1y + r1height < r2y){
    return false;
  }
  if (r2y + r2height < r1y){
    return false;
  }
  return true;

}
// Color functions to generate apropriatted colorschemes
color getTriadicColor(color c, int option){
  float Hue = hue(c) + option * 120;
  if (Hue > 360){
    Hue -= 360;
  }
  int cor = color(Hue ,saturation(c),brightness(c));
  return cor;
}
color getComplementaryColor(color c){
  float Hue = hue(c) + 180;
  if (Hue > 360){
    Hue -= 360;
  }
  int cor = color(Hue ,saturation(c),brightness(c));
  return cor;
}

// Setup functions ========================================================
void setupColors(){
  colorMode(HSB, 360, 100, 100);
  referenceColor = color(232,66,56);

  // These are triadic colors from reference  3 is the same as referenceColor
  // we could optimize not calling getTriadicColor(color,3);
  atmosphereColor = getTriadicColor(referenceColor,1);
  planetColor = getTriadicColor(referenceColor,3);
  townColor = getTriadicColor(referenceColor,2);

  // Bombs are going to be black;
  bombsColor = color(0,0,0);

  // These are complementary colors
  /* spaceshipColor = color(0,100,67); */
  spaceshipColor = atmosphereColor;
  shieldColor = getComplementaryColor(spaceshipColor);
}

// Setup
void setup(){
size(400,800);
/* size(800,900); */
/* size(800,1200); */
setupColors();

createSpaceship();
createShield();
createBombs();
createTown(5);

frameRate(60);

gameEnd = false;
endString = "";

}


// Events functions ==========================================================
void mousePressed(){
  if (mouseButton == LEFT){
    if (mouseY >= shieldY && mouseY <= shieldY + shieldHeight){
      shoot();
    }
    else{
      recharge();
    }
  }
  if (mouseButton == RIGHT){
    restart();
  }
}

void mouseReleased(){
  if (mouseButton == LEFT){
    activated = false;
  }
}
