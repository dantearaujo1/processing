class Player{
  int     m_position;
  int     m_selectionOne;
  int     m_selectionTwo;
  int     m_points;
  boolean m_shouldTest;
  boolean m_startSwap;
  Board   m_board;
  ArrayList<Candy> m_test;

  Player(){
    m_position = 0;
    m_selectionOne = -1;
    m_selectionTwo = -1;
    m_points = 0;
    m_board = null;
    m_shouldTest = false;
    m_startSwap = false;
  }

  void handleInput(int k){
    if (keyPressed == true && k == 's') move(2);
    if (keyPressed == true && k == 'w') move(1);
    if (keyPressed == true && k == 'd') move(3);
    if (keyPressed == true && k == 'a') move(4);
    if (keyPressed == true && k == ' ') select();
    if (keyPressed == true && k == 'r') reset();

  }

  void update(Board b){
    if(checkSwap(b)){
      swap(b);
    }
  }

  void draw(){
    PVector p = convert1Dto2D(m_position);
    drawSelection(color(200,200,0));
    drawPosition(p.x,p.y,color(0,220,50));
  }
  void drawSelection(color selectionColor){
    if(m_board != null){
      int size = m_board.getRectSize();
      PVector pos1 = convert1Dto2D(m_selectionOne);
      PVector pos2 = convert1Dto2D(m_selectionTwo);
      pushStyle();
      fill(selectionColor);
      rect(pos1.x * size, pos1.y * size, size, size);
      rect(pos2.x * size, pos2.y * size, size, size);
      popStyle();
    }
  }
  void drawPosition(float x, float y, color positionColor){
    if(m_board != null){
      int size = m_board.getRectSize();
      pushStyle();
      fill(positionColor);
      rect(x*size,y*size,size,size);
      popStyle();
    }
  }

  void setBoard(Board b){
    m_board = b;
  }

  void move(int direction){
    switch(direction){
      case 1:
        if (m_position > BOARD_COLUMNS){
          m_position -= BOARD_COLUMNS;
        }
        break;
      case 2:
        if (m_position < BOARD_COLUMNS * (BOARD_ROWS-1)){
          m_position += BOARD_COLUMNS;
        }
        break;
      case 3:
        if (m_position < BOARD_COLUMNS * BOARD_ROWS - 1){
          m_position += 1;
        }
        break;
      case 4:
        if (m_position > 0){
          m_position -= 1;
        }
        break;
    }
  }

  void select(){
    if(m_selectionOne > 0){
      if(m_position == offset(m_selectionOne,"North",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"South",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"East",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"West",BOARD_COLUMNS)){
        m_selectionTwo = m_position;
        m_shouldTest = true;
        println("Selected second at " + m_position);
        return;
      }
      println("None selected ");
      return;
    }
    m_selectionOne = m_position;
    println("Selected first at " + m_position);
  }
  void swap(Board b){
    Candy first = getCandy(m_selectionOne, b.m_candys);
    Candy second = getCandy(m_selectionTwo, b.m_candys);
    CANDYTYPES temp = first.m_type;
    println("Ohh boys we swapped at (" + first.m_x + "," + first.m_y + ") with (" + second.m_x + "," + second.m_y + ")");
    first.m_type = second.m_type;
    second.m_type = temp;
    m_selectionOne = -1;
    m_selectionTwo = -1;
    m_startSwap = false;
  }
  boolean checkSwap(Board b){
    if(m_shouldTest){
      Candy first = getCandy(m_selectionOne, b.m_candys);
      Candy second = getCandy(m_selectionTwo, b.m_candys);
      if(hasMatch(first,second,b) >= 2){
        m_shouldTest = false;
        m_startSwap = true;
        return true;
      }
    }
    return false;
  }

  int hasMatch(Candy one, Candy two, Board b){
    int matchs=0;
    for (int x = two.m_x - 1; x >= 0; x--){
      Candy next = getCandy(x,two.m_y,b.m_candys);
      if(next.m_type == two.m_type){
        matchs+=1;
      }
    }
    for (int x = two.m_x + 1; x < BOARD_COLUMNS; x++){
      Candy next = getCandy(x,two.m_y,b.m_candys);
      if(next.m_type == two.m_type){
        matchs+=1;
      }
    }
    println("How many matchs: " + matchs);
    return matchs;
  }

  void reset(){
    m_position = 0;
    m_selectionOne = -1;
    m_selectionTwo = -1;
    m_points = 0;
    m_shouldTest = false;
    m_startSwap = false;
  }

}
