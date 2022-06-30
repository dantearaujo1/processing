class Board{

  Candy[][] m_candys;
  float m_x;
  float m_y;
  Frame m_backgroundTile;
  ArrayList<Candy> m_candysToDelete;
  boolean m_shouldUpdateGravity;


  Board(){
    init();
  }

  void init(){
    m_candys = new Candy[BOARD_ROWS][BOARD_COLUMNS];
    m_candysToDelete = new ArrayList<Candy>();
    generateCandys();
    m_x = width/2 - BOARD_COLUMNS * RECT_SIZE * g_scaleFactorX/2 ;
    m_y = height/2 - BOARD_ROWS * RECT_SIZE * g_scaleFactorY/2;
    m_backgroundTile = new Frame(0,0,32,32);
  }


  Board generateCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        CANDYTYPES type = CANDYTYPES.values()[int(random(CANDYTYPES.values().length - 1))];
        m_candys[y][x] = new Candy(x,y,type);
      }
    }
    return this;
  }

  void update(float dt){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        m_candys[y][x].update(dt);
      }
    }
    if(m_candysToDelete.size() > 0){
      m_shouldUpdateGravity = true;
    }
    deleteCandys();

    if(m_shouldUpdateGravity){
      updateGravity();
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
        if(m_candys[y][x].m_type != CANDYTYPES.EMPTY || m_candys[y][x].m_swapAnim){
          m_candys[posToFill][x].m_type = m_candys[y][x].m_type;
          m_candys[posToFill][x].m_endY = m_candys[y][x].m_y;
          m_candys[posToFill][x].m_endX = m_candys[y][x].m_x;
          m_candys[posToFill][x].m_gravityAnim = true;
          m_candys[posToFill][x].m_gravityCurrentDuration = 0.0;


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

    m_shouldUpdateGravity = false;
      if(g_debug){
        println("Updated Gravity");
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

      Candy temp = first.copy();

      first.m_endX = second.m_x;
      first.m_endY = second.m_y;
      first.m_startY = first.m_y;
      /* first.m_startX = first.m_x; */
      first.m_type = second.m_type;
      first.m_swapAnim = true;
      first.m_currentDuration = 0.0;

      second.m_endX = temp.m_x;
      second.m_endY = temp.m_y;
      second.m_startY = second.m_y;
      /* second.m_startX = second.m_x; */
      second.m_type = temp.m_type;
      second.m_currentDuration = 0.0;
      second.m_swapAnim = true;

      if(g_debug){
        println("Swapped");
      }

    }
  }

  void deleteCandys(){
    ArrayList<Candy> toDelete = new ArrayList<Candy>();
    for (Candy c : m_candysToDelete){
      if(c.m_type == CANDYTYPES.EMPTY && c.m_currentDuration >= c.m_deleteAnimDuration){
        toDelete.add(c);
        c.m_currentDuration = 0;
      }
    }
    for(Candy c : toDelete){
      m_candysToDelete.remove(c);
    }
    toDelete.clear();
  }

  void setCandysToDelete(ArrayList<Candy> candys){
    m_candysToDelete.addAll(candys);
    for(Candy c : m_candysToDelete){
      c.m_deleteAnim = true;
      c.m_currentDuration = 0.0;
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
        rect(m_x + x*RECT_SIZE*g_scaleFactorX, m_y + y*RECT_SIZE*g_scaleFactorY,RECT_SIZE*g_scaleFactorX,RECT_SIZE*g_scaleFactorY);
        Frame f = m_backgroundTile;
        image(g_backgroundTile, m_x + x*RECT_SIZE*g_scaleFactorX, m_y + y*RECT_SIZE*g_scaleFactorY,RECT_SIZE*g_scaleFactorX,RECT_SIZE*g_scaleFactorY,f.x,f.y,f.x + f.width, f.y + f.height);
      }
    }
  }


  void drawCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        Candy ourCandy = m_candys[y][x];
        ourCandy.draw(m_x,m_y);
        fill(255,255,255);
        if(g_debug){
          text(x + "," + y, m_x + x * RECT_SIZE + RECT_SIZE/4, m_y + (1+y) * RECT_SIZE);
        }
      }
    }
  }

}

