class GameScene implements IScene{
  Board m_board;
  Player m_player;
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
    textSize(8);

  }

  void onInit(){
    textSize(8);
    m_timerCounter = 0.0;
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
    this.update(dt);
    this.draw();

    this.lateUpdate(dt);
    this.lateDraw();
    m_timerCounter += dt;
  }

  void update(float dt){
    m_player.update(dt);
    m_board.update(dt);
  }
  void lateUpdate(float dt){

  }

  void draw(){
    m_board.draw();
    m_player.draw();
  }

  void lateDraw(){
    m_board.lateDraw();
  }

}

