class Level{
  Player  m_player;
  Board   m_board;
  float   m_countDown;
  int     m_goalPoints;
  int     m_maxMoves;
  Tween   m_tween;
  String  m_endText;
  String  m_endInfoText;

  Level(float time, int points, int moves){
    m_countDown = time;
    m_goalPoints = points;
    m_maxMoves = moves;
    m_tween = new Tween(2,0,height/2);
    m_endText = "You lose!";
    m_endInfoText = "Press ESC to go back or press Enter play again";
  }

  void update(float dt){
    if(hasEnded()){
      m_countDown = 0;
      if(didGoalReach()){
        m_endText = "You won!";
        m_endInfoText = "Press ESC to go to menu or press Enter to play next level";
      }
      m_tween.update(dt);
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
    textSize(16 * g_scaleFactorX);
    text(int(m_countDown), m_board.m_x + RECT_SIZE  * g_scaleFactorX * BOARD_COLUMNS/2, m_board.m_y - 10 * g_scaleFactorY);
    text(int(m_player.m_points) + "/" + m_goalPoints, m_board.m_x + textWidth(str(m_player.m_points) + "/" + str(m_goalPoints))/2 , m_board.m_y - 10 * g_scaleFactorY);
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
      rect(0,m_tween.getPosition(),width,60*g_scaleFactorY);
      fill(0,0,0);
      pushStyle();
      textAlign(CENTER);
      text(m_endText,width/2,m_tween.getPosition() + 25*g_scaleFactorY);
      text(m_endInfoText,width/2,m_tween.getPosition() + 40*g_scaleFactorY);
      popStyle();
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

  void setBoardBackground(Frame f){
    if(f != null){
      m_board.m_backgroundTile = f;
    }
  }

  boolean didGoalReach(){
    if(m_player.m_points >= m_goalPoints){
      return true;
    }
    else{
      return false;
    }
  }


}
