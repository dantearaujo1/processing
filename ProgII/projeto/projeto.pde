/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
Court c;
void setup(){
  size(800,800);
  b = new Ball(width/2,height/2,15);
  c = new Court();
}

void draw(){
  background(0);

  // Update Loop
  b.update();
  // Draw Loop
  c.draw();
  b.draw();
}
