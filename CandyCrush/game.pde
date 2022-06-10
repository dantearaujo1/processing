class Game{

  int m_score;
  int m_level;
  Board m_board;
  Candy m_choice1;
  Candy m_choice2;

  Game(int level){
    m_level = level;
    m_score = 0;
    m_board = new Board(37,31);
  }

  void play(){
    m_board.update();
    m_board.draw();
  }

  void swap(){
    int difX = m_choice1.m_x - m_choice2.m_x;
    int difY = m_choice1.m_y - m_choice2.m_y;
    if(difX >= -1 && difX <= 1 && difY == 0){
      color temp = m_choice1.m_color;
      m_choice1.m_color = m_choice2.m_color;
      m_choice2.m_color = temp;
      println("Swap");
    }
    else if(difX == 0 &&  difY >= -1 && difY <= 1){
      color temp = m_choice1.m_color;
      m_choice1.m_color = m_choice2.m_color;
      m_choice2.m_color = temp;
      println("Swap");
    }
    m_choice1.m_selected = false;
    m_choice2.m_selected = false;
    m_choice1 = null;
    m_choice2 = null;
  }

  void handleInput(int k){
    if (keyPressed == true && k == 's') m_board.move(2);
    if (keyPressed == true && k == 'w') m_board.move(1);
    if (keyPressed == true && k == 'd') m_board.move(3);
    if (keyPressed == true && k == 'a') m_board.move(4);
  }


  void select(int id){

  }


}
