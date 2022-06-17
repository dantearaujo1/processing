class Board{

  Candy[][] m_candys;
  boolean m_animationEnd;

  Board(){

    m_candys = new Candy[BOARD_ROWS][BOARD_COLUMNS];
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        CANDYTYPES type = CANDYTYPES.values()[int(random(CANDYTYPES.values().length - 1))];
        m_candys[y][x] = new Candy((x),(y),type);
      }
      m_animationEnd = false;
    }
  }

  void update(float dt){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        m_candys[y][x].update(dt);
      }
    }
  }

  void updateGravity(){
    // Doing for all columns - X direction
    for (int x = 0; x < BOARD_COLUMNS; x++){
      // Creating an variable to store the position that should be EMPTY
      // When find a row empty
      int posToFill = BOARD_ROWS - 1;

      // Going thru all the rows looking for empty spaces
      // If we find an candy in an row we decrease our posToFill
      for (int y = BOARD_ROWS - 1; y > -1; y--){
        if(m_candys[y][x].m_type != CANDYTYPES.EMPTY){
          m_candys[posToFill][x].m_type = m_candys[y][x].m_type;
          posToFill -= 1;
        }
      }

      // Now that we our swap our candys with our "empty"
      // We should empty from our last position to Fill to the
      // First row
      for (int y = posToFill; y > -1; y--){
          m_candys[y][x].m_type = CANDYTYPES.EMPTY;
      }
    }

  }

  void draw(){
    drawBoard();
  }

  void lateDraw(){
    drawCandys();
  }

  void drawBoard(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        fill(122,122,122);
        rect(x*RECT_SIZE,y*RECT_SIZE,RECT_SIZE,RECT_SIZE);
      }
    }
  }


  void drawCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        Candy ourCandy = getCandy(x,y,m_candys);
        ourCandy.draw();
        fill(255,255,255);
        text(x + "," + y, x * RECT_SIZE + RECT_SIZE/4, (1+y) * RECT_SIZE);
      }
    }
  }

}

