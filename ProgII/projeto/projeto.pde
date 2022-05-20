/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
Player p;
Player p2;
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

  // Update Loop
  if(deltaTime >= DT){
    deltaTime -= DT;

    b.update();
    b.checkCourt(c);
    b.checkNet(c.getNet());
    b.setBallSide(c.getNet());

    p.update();
    p2.update();

    if(b.checkEnd()){
      setPoint(p,p2,b);
    }
  }

  // Draw Loop
  c.draw();
  p2.draw();
  if(b.m_side == 1){
    b.draw();
    c.drawNet();
  }
  else{
    c.drawNet();
    b.draw();
  }
  p.draw();


  pushStyle();
  textSize(36);
  score.x = p.m_score;
  score.y = p2.m_score;
  scoreText = int(score.x) + " : " + int( score.y );
  text(scoreText, width/2 - textWidth(scoreText)/2, textDescent() + textAscent());
  textSize(12);
  popStyle();
}

void reset(Player p1, Player p2, Ball b){
  b.init(0,640,15);
  p1.init(0,0,-1);
  p2.init(0,0,1);
  setServe(p1,p2,b);
}

void keyReleased(){
  if(key == 'd'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT, false);
    p.setVelX(0);
  }
  if(key == 'a'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT, false);
    p.setVelX(0);
  }
  if(key == 's'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN, false);
    p.setVelY(0);
  }
  if(key == 'w'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_UP, false);
    p.setVelY(0);
  }
  if(key == 'l'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT, false);
    p2.setVelX(0);
  }
  if(key == 'j'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT, false);
    p2.setVelX(0);
  }
  if(key == 'k'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN, false);
    p2.setVelY(0);
  }
  if(key == 'i'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_UP, false);
    p2.setVelY(0);
  }
}
void keyPressed(){
  if(b.isInGame() || b.isServed()){
    if(key == ' '){
      p.hit(b);
    }
    if(key == 'ç'){
      p2.hit(b);
    }
  }
  else{
    if(key == ' '){
      b.startServeAnimation();
    }
    if(key == 'ç'){
      b.startServeAnimation();
    }
  }
  // PLAYER 1 INPUT
  if(key == 'd'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT, true);
  }
  if(key == 'a'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT, true);
  }
  if(key == 's'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN, true);
  }
  if(key == 'w'){
    p.m_movements.put(PLAYER_MOV_STATES.PLAYER_UP, true);
  }
  // PLAYER 2 INPUT
  if(key == 'l'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT, true);
  }
  if(key == 'j'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT, true);
  }
  if(key == 'k'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN, true);
  }
  if(key == 'i'){
    p2.m_movements.put(PLAYER_MOV_STATES.PLAYER_UP, true);
  }

  if(key == 'q'){
    debug = !debug;
  }
  if(key == 'r'){
    reset(p,p2,b);
  }
}

void setServe(Player p1, Player p2, Ball p){
  p1.setServe(false);
  p2.setServe(true);
  b.startServing();
  b.setLastHit(p1);
  if(p1.getFacing() == 1){
    p1.setPos(width/2, 130);
    p2.setPos(width/2, 620);

  }
  else{
    p1.setPos(width/2, 620);
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
  float side = b.getSide();
  if (side == 1){
    p1.m_score += 15;
  }
  else  {
    p2.m_score += 15;
  }
  setServe(p1,p2,b);
}


