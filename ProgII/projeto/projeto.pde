/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
Player p;
Player p2;
/* final float GRAVITY = 9.8; */
final float GRAVITY = 98;
boolean debug;

final float FRAME_RATE = 60.0f;
final float DT = 1.0/FRAME_RATE;
float deltaTime = 0.0f;
float currentTime = 0.0f;
float lastTime = 0.0f;

PVector score;
String scoreText;

void setup(){
  size(800,800);
  c = new Court();
  b = new Ball(0,640,15);
  p = new Player(width/2, 620, -1);
  p2 = new Player(0, 0, 1);
  score = new PVector(0,0);

  setServe(p2,p,b);
  /* setServe(p,p2,b); */
  debug = false;
}

void draw(){
  background(0);

  currentTime = millis()/1000.0f;
  deltaTime += currentTime - lastTime;
  lastTime = currentTime;
  p.handleInput();
  // Update Loop
  if(deltaTime >= DT){
    deltaTime -= DT;
    b.update();
    b.checkNet(c.getNet());
    b.setBallSide(c.getNet());
    p.update();
    p2.update();
  }

  // Draw Loop
  c.draw();
  p2.draw();
  c.drawNet();
  b.draw();
  p.draw();

  pushStyle();
  textSize(36);
  scoreText = int(score.x) + " : " + int( score.y );
  text(scoreText, width/2 - textWidth(scoreText)/2, textDescent() + textAscent());
  textSize(15);
  popStyle();
}

void reset(){
  setup();
}

void keyReleased(){
      if(key == 'd'){
        p.setVelX(0);
      }
      if(key == 'a'){
        p.setVelX(0);
      }
      if(key == 'w'){
        p.setVelY(0);
      }
      if(key == 's'){
        p.setVelY(0);
      }
}
void keyPressed(){
  if(b.isServed()){
    if(key == ' '){
      p.hit(b);
    }
    if(key == 'ç'){
      p2.hit(b);
    }
  }
  else{
    if(key == ' '){
      /* p.hit(b); */
      b.setServe(true);
    }
    if(key == 'ç'){
      /* p2.hit(b); */
      b.setServe(true);
    }
  }
  // PLAYER 1 INPUT
  // PLAYER 2 INPUT
  if(key == 'l'){
    p2.move(50,0);
  }
  if(key == 'j'){
    p2.move(-50,0);
  }
  if(key == 'k'){
    p2.move(0,50);
  }
  if(key == 'i'){
    p2.move(0,-50);
  }

  if(key == 'q'){
    debug = !debug;
  }
  if(key == 'r'){
    reset();
  }
}

void setServe(Player p1, Player p2, Ball p){
  b.setServe(false);
  b.setKicking(false);
  p1.setServe(false);
  p2.setServe(true);
  if(p1.getFacing() == 1){
    p1.setPos(width/2, 130);
    b.setPos(p1.getPosX() - 20, p1.getPosY() + 20);
    p2.setPos(width/2, 620);

  }
  else{
    p1.setPos(width/2, 620);
    b.setPos(p1.getPosX() - 20, p1.getPosY() + 20);
    p2.setPos(width/2, 130);

  }
}

float getDeltaTime(){
  return DT;
}
float getRealDeltaTime(){
  return deltaTime;
}

PVector getScore(Player p1, Player p2){
  PVector result = new PVector(p1.m_score,p2.m_score);
  return result;
}

void setPoint(Player p1, Player p2, Ball b){
    if (!b.isKicking() && b.isServed()){
      
    }
}
