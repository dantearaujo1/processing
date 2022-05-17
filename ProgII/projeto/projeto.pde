/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
Player p;
Player p2;
boolean debug;
float duration;
float time;

void setup(){
  size(800,800);
  c = new Court();
  b = new Ball(0,640,15);
  p = new Player(width/2, 620, -1);
  p2 = new Player(0, 0, 1);
  setServe(p,p2,b);
  duration = 75;
  time = 0;
  debug = false;
}

void draw(){
  background(0);

  // Update Loop
  b.update();
  b.checkNet(c.getNet());
  b.setBallSide(c.getNet());
  p.update();
  p2.update();



  // Draw Loop
  c.draw();
  p2.draw(b);
  c.drawNet();
  b.draw();
  p.draw(b);
}

void reset(){
  setup();
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
      p.hit(b);
    }
    if(key == 'ç'){
      p2.hit(b);
    }
  }
  // PLAYER 1 INPUT
  if(key == 'd'){
    p.move(1,0);
  }
  if(key == 'a'){
    p.move(-1,0);
  }
  if(key == 's'){
    p.move(0,1);
  }
  if(key == 'w'){
    p.move(0,-1);
  }
  // PLAYER 2 INPUT
  if(key == 'l'){
    p2.move(5,0);
  }
  if(key == 'j'){
    p2.move(-5,0);
  }
  if(key == 'k'){
    p2.move(0,5);
  }
  if(key == 'i'){
    p2.move(0,-5);
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
    b.setPos(p1.getPosX() - 20, p1.getPosY() - 20);
    p2.setPos(width/2, 620);

  }
  else{
    p1.setPos(width/2, 620);
    b.setPos(p1.getPosX() - 20, p1.getPosY() + 20);
    p2.setPos(width/2, 130);

  }
}
