/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

Game game;

KeyboardState m_keys;
InputContext m_p1Context;
InputContext m_debugContext;
InputContext m_p2Context;
InputManager m_mappings;

void setup(){
  size(800,800);
  /* frameRate(20); */
  game = new Game();
  m_keys = new KeyboardState();
  m_debugContext = new InputContext(m_keys);
  m_p1Context = new InputContext(m_keys);
  m_p2Context = new InputContext(m_keys);

  m_p1Context.mapAction("Hit", int(' '));
  m_p1Context.mapState("Aim", int(' '));
  m_p1Context.mapState("Move Up", int('w'));
  m_p1Context.mapState("Move Down", int('s'));
  m_p1Context.mapState("Move Left", int('a'));
  m_p1Context.mapState("Move Right", int('d'));

  m_p2Context.mapAction("Hit", int('n'));
  m_p2Context.mapState("Aim", int(' '));
  m_p2Context.mapState("Move Up", int('i'));
  m_p2Context.mapState("Move Down", int('k'));
  m_p2Context.mapState("Move Left", int('j'));
  m_p2Context.mapState("Move Right", int('l'));

  m_debugContext.mapAction("Debug", int('q'));
  m_debugContext.mapAction("Add Point", int('e'));
  m_debugContext.mapAction("Reset", int('r'));

  m_mappings = new InputManager();
  m_mappings.addContext("Player 1",m_p1Context);
  m_mappings.addContext("Player 2",m_p2Context);
  m_mappings.addContext("Debug", m_debugContext);
}
void draw(){
  background(0,122,0);
  m_keys.update();

  game.run();
}

void reset(Player p1, Player p2, Ball b){
  b.init(0,640,15);
  p1.init(0,0,-1);
  p2.init(0,0,1);
  game.startServe(p2,p1,b);
}

void keyReleased(){
  m_keys.updateKeyReleased(key);
}
void keyPressed(){
  m_keys.updateKeyPressed(key);
  Ball b = game.getBall();
  Court c = game.getCourt();

  for (int i = 1; i <= game.getPlayersLength(); i++){
    Player t = game.getPlayer(i);
    if (t != null){
      if(game.shouldStartServing()){
        if(m_mappings.getContext(t.getName()).getAction("Hit") && game.getPlayerServing() == t){
          if(i % 2 == 0){
            game.startServing(t,b,game.getPlayer(i-1));
          }
          else{
            game.startServing(t,b,game.getPlayer(i+1));
          }
        }
      }
      else if (game.isServing()){
        if(m_mappings.getContext(t.getName()).getAction("Hit")){
          t.hit(b,c);
          game.setState(GAME_STATES.GAME_FIRSTHIT);
        }
      }
      else{
        if(m_mappings.getContext(t.getName()).getAction("Hit")){
          t.hit(b,c);
          t.m_states.put(PLAYER_STATES.AIM, true);
        }
      }
    }
  }

  if(m_mappings.getContext("Debug").getAction("Debug")){
    game.changeDebug();
  }
  if(m_mappings.getContext("Debug").getAction("Reset")){
    reset(game.getPlayer(1),game.getPlayer(2),b);
  }
  if(m_mappings.getContext("Debug").getAction("Add Point")){
    game.setPoint(game.getPlayer(1),game.getPlayer(2),b);
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




