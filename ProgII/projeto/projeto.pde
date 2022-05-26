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

void reset(Player p1, Player p2, Ball b){
  b.init(0,640,15);
  p1.init(0,0,-1);
  p2.init(0,0,1);
  game.startServe(p1,p2,b);
}

void keyReleased(){
  Player p = game.getPlayer(1);
  Player p2 = game.getPlayer(2);
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
  Player p = game.getPlayer(1);
  Player p2 = game.getPlayer(2);
  Ball b = game.getBall();
  Court c = game.getCourt();

  if(game.shouldStartServing()){
    if(key == ' '){
      game.startServing(p,b);
    }
    if(key == 'n'){
      game.startServing(p2,b);
    }
  }
  else if (game.isServing()){
    if(key == ' '){
      p.hit(b,c);
      game.setState(GAME_STATES.GAME_FIRSTHIT);
    }
    if(key == 'n'){
      p2.hit(b,c);
      game.setState(GAME_STATES.GAME_FIRSTHIT);
    }
  }
  else{
    if(key == ' '){
      p.hit(b,c);
    }
    if(key == 'n'){
      p2.hit(b,c);
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
    game.changeDebug();
  }
  if(key == 'r'){
    reset(p,p2,b);
  }
  if(key == 'e'){
    game.setPoint(p,p2,b);
  }
  if(key == 'f'){
    game.setPoint(p,p2,b);
  }
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




