/*  Tennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Game game;
InputManager g_inputManager;


void setup(){
  size(800,800);
  g_inputManager = new InputManager();
  game = new Game();
}

void draw(){
  background(0,122,0);
  game.run();
}

void keyReleased(){
  game.updateKeysReleased(key);
}
void keyPressed(){
  game.updateKeysPressed(key);
  Ball b = game.getBall();

  if(g_inputManager.getContext("Debug").getAction("Debug")){
    game.changeDebug();
  }
  if(g_inputManager.getContext("Debug").getAction("Reset")){
    reset(game.getPlayer(1),game.getPlayer(2),b);
  }
  if(g_inputManager.getContext("Debug").getAction("Add Point")){
    game.setPoint(game.getPlayer(1),game.getPlayer(2),b);
  }
}

void reset(Player p1, Player p2, Ball b){
  b.init(0,640,15);
  p1.init(0,0,-1);
  p2.init(0,0,1);
  game.startServe(p2,p1,b);
}
float getDeltaTime(){
  return DT;
}
float getRealDeltaTime(){
  return game.m_deltaTime;
}
boolean getDebug(){
  return game.m_debug;
}




