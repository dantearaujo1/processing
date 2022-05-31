/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Game game;


void setup(){
  size(800,800);
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
  Court c = game.getCourt();

  for (int i = 1; i <= game.getPlayersLength(); i++){
    Player t = game.getPlayer(i);
    if (t != null){
      if(game.shouldStartServing()){
        if(game.m_inputManager.getContext(t.getName()).getAction("Hit") && game.getPlayerServing() == t){
          if(i % 2 == 0){
            game.startServing(t,b,game.getPlayer(i-1));
          }
          else{
            game.startServing(t,b,game.getPlayer(i+1));
          }
        }
      }
      else if (game.isServing()){
        if(game.m_inputManager.getContext(t.getName()).getAction("Hit")){
          t.hit(b,c);
          /* game.setState(GAME_STATES.GAME_FIRSTHIT); */
        }
      }
      else{
        if(game.m_inputManager.getContext(t.getName()).getAction("Hit")){
          t.hit(b,c);
          t.m_states.put(PLAYER_STATES.AIM, true);
        }
      }
    }
  }

  if(game.m_inputManager.getContext("Debug").getAction("Debug")){
    game.changeDebug();
  }
  if(game.m_inputManager.getContext("Debug").getAction("Reset")){
    reset(game.getPlayer(1),game.getPlayer(2),b);
  }
  if(game.m_inputManager.getContext("Debug").getAction("Add Point")){
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




