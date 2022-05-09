/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Ball b;
void setup(){
  size(800,800);
  b = new Ball(width/2,height/2,30);
}

void draw(){
  background(0);

  // Update Loop
  b.update();

  // Draw Loop
  b.draw();
}
