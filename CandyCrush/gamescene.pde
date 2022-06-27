class GameScene implements IScene{
  Board m_board;
  Player m_player;
  Level m_level;
  SceneManager m_director;
  ControlP5 m_controlGUI;

  float m_timerCounter;

  GameScene(SceneManager director, PApplet app){
    if (director != null){
      m_director = director;
    }
    if(app != null){
      m_controlGUI = new ControlP5(app);
    }

    m_board = new Board();
    m_player = new Player();
    m_player.setBoard(m_board);

  }

  void onInit(){
    textSize(8);
    m_timerCounter = 0.0;
    loadLevel("level.json",0);
    m_board = new Board();
    m_player = new Player();
    m_player.setBoard(m_board);
  }
  void onExit(){

  }
  void onResume(){
    textSize(8);
  }

  void onPause(){

  }
  void handleInput(int k){
    m_player.handleInput(k);
  }

  void run(float dt){
  }

  void update(float dt){
    m_player.update(dt);
    m_board.update(dt);
    m_timerCounter += dt;
  }
  void lateUpdate(float dt){

  }

  void loadLevel(String filename, int l){
    JSONObject obj = loadJSONObject(filename);
    JSONArray levels = obj.getJSONArray("Levels");
    JSONObject level = levels.getJSONObject(l);
    m_level = new Level(level.getInt("countdown"),level.getInt("goal"),level.getInt("maxMoves"));
  }

  void draw(){
    m_board.draw();
    m_player.draw();
    text(int(m_level.m_countDown - m_timerCounter), m_board.m_x + RECT_SIZE * BOARD_COLUMNS/2, m_board.m_y - 10);
  }

  void lateDraw(){
    m_board.lateDraw();
  }

}

