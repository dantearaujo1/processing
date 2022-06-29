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
    m_playing = false;
    textSize(8 * g_scaleFactorX);
    m_board = new Board();
    m_player = new Player();
    m_player.setBoard(m_board);
    loadLevel("level.json",1);
    if(m_level != null){
      m_level.setPlayer(m_player);
    }
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
      if(k == '\n'){
        onInit();
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
    if(!m_playing){
      m_level.update(dt);
    }

  }
  void lateUpdate(float dt){

  }

  void loadLevel(String filename, int l){
    JSONObject obj = loadJSONObject(filename);
    JSONArray levels = obj.getJSONArray("Levels");
    JSONObject level = levels.getJSONObject(l);
    m_level = new Level(level.getInt("countdown"),level.getInt("goal"),level.getInt("maxMoves"));
    m_level.setBoard(m_board);
    m_level.setBoardBackground(BACKTILES.get(level.getString("background")));
  }

  void draw(){
    m_level.draw();
  }

  void lateDraw(){
    m_level.lateDraw();
    /* if(!m_playing){ */
    /*   fill(0,0,0,100); */
    /*   rect(0,0,width,height); */
    /* } */
  }

}

