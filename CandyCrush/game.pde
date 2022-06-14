class Game{

  Board m_board;
  Player m_player;
  Candy m_choice1;
  Candy m_choice2;

  Game(int level){
    m_board = new Board(37,31);
    m_player = new Player();
    m_player.setBoard(m_board);
  }

  void play(){
    m_board.update();
    m_player.update(m_board);
    m_board.draw();
    m_player.draw();
    m_board.lateDraw();
  }

  void loadLevel(){

  }

  void swap(){
    int difX = m_choice1.m_x - m_choice2.m_x;
    int difY = m_choice1.m_y - m_choice2.m_y;
    if(difX >= -1 && difX <= 1 && difY == 0){
      /* color temp = m_choice1.m_color; */
      /* m_choice1.m_color = m_choice2.m_color; */
      /* m_choice2.m_color = temp; */
      println("Swap");
    }
    else if(difX == 0 &&  difY >= -1 && difY <= 1){
      /* color temp = m_choice1.m_color; */
      /* m_choice1.m_color = m_choice2.m_color; */
      /* m_choice2.m_color = temp; */
      println("Swap");
    }
    m_choice1.m_selected = false;
    m_choice2.m_selected = false;
    m_choice1 = null;
    m_choice2 = null;
  }

  Player getPlayer(){
    return m_player;
  }

}
