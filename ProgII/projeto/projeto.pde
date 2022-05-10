/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
Player p;
void setup(){
  size(800,800);
  b = new Ball(width/2,0,15);
  c = new Court();
  p = new Player();
}

void draw(){
  background(0);

  // Update Loop
  b.update();
  /* b.move(new PVector(0,-1)); */
  // Draw Loop
  c.draw();
  b.draw();
  p.draw();
}


void keyPressed(){
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
  if(key == ' '){
    p.hit(b);
  }
}
