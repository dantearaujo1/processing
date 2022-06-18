class Game{

  Board m_board;
  Player m_player;
  Candy m_choice1;
  Candy m_choice2;

  float           m_currentTime;
  float           m_deltaTime;
  float           m_lastTime;
  final float     DT = 1.0/60.0;

  Game(int level){
    m_board = new Board();
    m_player = new Player();
    m_player.setBoard(m_board);
  }

  void play(){
    m_currentTime = millis()/1000.0f;
    m_deltaTime += m_currentTime - m_lastTime;
    m_lastTime = m_currentTime;

    if (m_deltaTime >= DT){
      m_deltaTime -= DT;

      m_player.update(DT);
      m_board.update(DT);

      m_board.draw();
      m_player.draw();
      m_board.lateDraw();

    }
  }

  void loadLevel(){

  }

  Player getPlayer(){
    return m_player;
  }

}
