/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
Player p;
boolean debug;
float duration;
float time;
void setup(){
  size(800,800);
  b = new Ball(width/2,100,15);
  c = new Court();
  p = new Player();
  duration = 75;
  time = 0;
  debug = false;
}

void draw(){
  background(0);

  // Update Loop
  b.update();
  c.update();
  b.checkNet(c.getNet());

  // Draw Loop
  c.draw();
  b.draw();
  p.draw();
}


void keyPressed(){
  if(b.m_serve){
    if(key == ' '){
      b.m_serve = false;
      b.m_kicking = true;
      p.hit(b);
    }
  }
  if(key == 'd'){
    p.move(5,0);
  }
  if(key == 'a'){
    p.move(-5,0);
  }
  if(key == 's'){
    p.move(0,5);
  }
  if(key == 'w'){
    p.move(0,-5);
  }
  else{
    if(key == ' '){
      p.hit(b);
    }
  }
  if(key == 'q'){
    debug = !debug;
  }
}
