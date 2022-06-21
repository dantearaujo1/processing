class Board{

  Candy[][] m_candys;
  float m_x;
  float m_y;
  ArrayList<Candy> m_candysToDelete;

  Board(){
    init();
  }

  void init(){
    m_candys = new Candy[BOARD_ROWS][BOARD_COLUMNS];
    m_candysToDelete = new ArrayList<Candy>();
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        CANDYTYPES type = CANDYTYPES.values()[int(random(CANDYTYPES.values().length - 1))];
        m_candys[y][x] = new Candy(x,y,type);
      }
    }
    m_x = width * 0.15;
    m_y = height * 0.05;
  }

  void update(float dt){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        m_candys[y][x].update(dt);
      }
    }
    updateGravity();
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

  boolean hasMatch(){
    if(m_candysToDelete.size() > 0){
      return true;
    }
    return false;
  }

  void swap(SwapData playerSwap){
    if (hasMatch()){

      Candy first = playerSwap.m_first;
      Candy second = playerSwap.m_second;
      int px1 = first.m_gridX;
      int px2 = second.m_gridX;
      int py1 = first.m_gridY;
      int py2 = second.m_gridY;

      Candy temp = first.copy();

      m_candys[py1][px1].m_gridX = m_candys[py2][px2].m_gridX;
      m_candys[py1][px1].m_gridY = m_candys[py2][px2].m_gridY;
      m_candys[py1][px1].m_type = m_candys[py2][px2].m_type;
      m_candys[py1][px1].m_swapAnim = true;
      m_candys[py1][px1].m_currentDuration = 0.0;

      m_candys[py2][px2].m_gridX = temp.m_gridX;
      m_candys[py2][px2].m_gridY = temp.m_gridY;
      m_candys[py2][px2].m_type = temp.m_type;
      m_candys[py2][px2].m_swapAnim = true;
      m_candys[py2][px2].m_currentDuration = 0.0;
    }
  }

  void deleteCandys(){
    m_candysToDelete.clear();
  }

  void setCandysToDelete(ArrayList<Candy> candys){
    m_candysToDelete.addAll(candys);
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
        rect(m_x + x*RECT_SIZE, m_y + y*RECT_SIZE,RECT_SIZE,RECT_SIZE);
      }
    }
  }


  void drawCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        Candy ourCandy = m_candys[y][x];
        ourCandy.draw(m_x,m_y);
        fill(255,255,255);
        text(x + "," + y, m_x + x * RECT_SIZE + RECT_SIZE/4, m_y + (1+y) * RECT_SIZE);
      }
    }
  }

}

