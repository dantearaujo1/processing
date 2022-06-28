class Level{
  Player  m_player;
  Board   m_board;
  float   m_countDown;
  int     m_goalPoints;
  int     m_maxMoves;

  Level(float time, int points, int moves){
    m_countDown = time;
    m_goalPoints = points;
    m_maxMoves = moves;
  }

  void update(float dt){
    if(m_countDown <= 0){
      m_countDown = 0;
    }
    else{
      m_player.update(dt);
      m_board.update(dt);
      m_countDown -= dt;
    }

  }

  void draw(){
    m_board.draw();
    m_player.draw();
    pushStyle();
    textSize(16);
    text(int(m_countDown), m_board.m_x + RECT_SIZE * BOARD_COLUMNS/2, m_board.m_y - 10);
    text(int(m_player.m_points), m_board.m_x + 5 , m_board.m_y - 10);
    popStyle();
  }

  boolean hasEnded(){
    return (m_countDown <= 0);
  }

  void lateDraw(){
    m_board.lateDraw();
    if(m_countDown <= 0){
      fill(0,0,0,100);
      rect(0,0,width,height);
      fill(155,155,155);
      rect(0,height/2-30,width,60);
    }
  }

  void setPlayer(Player p){
    if(p==null)return;
    m_player = p;
  }
  void setBoard(Board b){
    if(b==null)return;
    m_board = b;
  }


}
