class GameScene implements IScene{
  Board         m_board;
  Player        m_player;
  Level         m_level;
  SceneManager  m_director;
  ControlP5     m_controlGUI;
  boolean       m_playing;


  GameScene(SceneManager director, PApplet app){
    if (director != null){
      m_director = director;
    }
    if(app != null){
      m_controlGUI = new ControlP5(app);
    }

  }

  void onInit(){
    m_playing = true;
    m_board = new Board();
    m_player = new Player();
    m_player.setBoard(m_board);
    loadLevel("level.json",1);
    textSize(8 * g_scaleFactorX);
  }
  void onExit(){

  }
  void onResume(){
    textSize(8 * g_scaleFactorX);
  }

  void onPause(){
    m_playing = false;
  }
  void handleInput(int k){
    if(m_level.hasEnded()){
      if(m_level.didGoalReach()){
        if(k == '\n'){
          loadLevel("level.json",m_level.m_id+1);
          m_player.m_initPoints = m_player.m_points;
        }
      }
      else if(k == '\n'){
        resetLevel();
      }
      if(k == ESC){
        m_director.changeScene(m_director.m_scenes.get(0));
        key = 0;
      }
    }
    else{
      m_player.handleInput(k);
    }
  }

  void run(float dt){
  }

  void update(float dt){
    if(m_playing){
      m_level.update(dt);
    }

  }
  void lateUpdate(float dt){

  }

  void loadLevel(String filename, int l){
    JSONObject obj = loadJSONObject(filename);
    JSONArray levels = obj.getJSONArray("Levels");
    JSONObject level = levels.getJSONObject(l-1);
    m_level = new Level(l,level.getInt("countdown"),level.getInt("goal"),level.getInt("maxMoves"));
    onLevelInit(level);
  }

  void onLevelInit(JSONObject level){
    m_level.setBoard(m_board.reuseBoard());
    m_level.setBoardBackground(BACKTILES.get(level.getString("background")));
    m_level.setPlayer(m_player);
    m_player.setBoard(m_board);
  }

  void resetLevel(){
    m_level.reset();
  }

  void draw(){
    m_level.draw();
  }

  void lateDraw(){
    m_level.lateDraw();
  }

}

