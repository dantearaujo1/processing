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
    if (keyPressed == true && k == 'q') resetBoard();
    if (keyPressed == true && k == 'b') changeDebug();

  }

  void update(float dt){
    if(checkSwap()){
      swap();
    }
  }

  void draw(){
    PVector p = convert1Dto2D(m_position);
    PVector p1 = convert1Dto2D(m_selectionOne);
    PVector p2 = convert1Dto2D(m_selectionTwo);
    drawSelection(color(200,200,0));
    drawPosition(p.x,p.y,color(0,220,50));
    fill(255,0,0);
    if(g_debug){
      text("Selection one: " + p1.x + "," + p1.y,0, height - 90);
      text("Selection two: " + p2.x + "," + p2.y,0, height - 75);
    }
  }
  void drawSelection(color selectionColor){
    if(m_board != null){
      PVector pos1 = convert1Dto2D(m_selectionOne);
      PVector pos2 = convert1Dto2D(m_selectionTwo);
      pushStyle();
      fill(selectionColor);
      if(pos1.x >= 0 && pos1.y >= 0){
        rect(m_board.m_x + pos1.x * RECT_SIZE, m_board.m_y + pos1.y * RECT_SIZE, RECT_SIZE, RECT_SIZE);
      }
      if(pos2.x >=0 && pos2.y >= 0){
        rect(m_board.m_x + pos2.x * RECT_SIZE, m_board.m_y + pos2.y * RECT_SIZE, RECT_SIZE, RECT_SIZE);
      }

      popStyle();
    }
  }
  void drawPosition(float x, float y, color positionColor){
    if(m_board != null){
      pushStyle();
      fill(positionColor);
      rect(m_board.m_x + x*RECT_SIZE,m_board.m_y + y*RECT_SIZE,RECT_SIZE,RECT_SIZE);
      stroke(255,0,0);
      if(g_debug){
        text(getCandy(m_position,m_board.m_candys).m_type.name(),0,height-100);
        text("GridX: " + int(getCandy(m_position,m_board.m_candys).m_x),35,height-100);
        text("GridY: " + int(getCandy(m_position,m_board.m_candys).m_y),90,height-100);
        text("X: " + getCandy(m_position,m_board.m_candys).m_x,130,height-100);
        text("Y: " + getCandy(m_position,m_board.m_candys).m_y,170,height-100);
      }
      popStyle();
    }
  }

  void setBoard(Board b){
    m_board = b;
  }

  void move(int direction){
    switch(direction){
      case 1:
        if (m_position > BOARD_COLUMNS-1){
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
    if(m_selectionOne >= 0){
      if(m_position == offset(m_selectionOne,"North",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"South",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"East",BOARD_COLUMNS) || m_position == offset(m_selectionOne,"West",BOARD_COLUMNS)){
        m_selectionTwo = m_position;
        m_shouldTest = true;
        return;
      }
      resetSelection();
      return;
    }
    m_selectionOne = m_position;
  }

  void swap(){

    Candy first = getCandy(m_selectionOne, m_board.m_candys);
    Candy second = getCandy(m_selectionTwo, m_board.m_candys);

    SwapData data = new SwapData(first,second);
    m_board.swap(data);

    m_selectionOne = -1;
    m_selectionTwo = -1;
    m_startSwap = false;
  }

  boolean checkSwap(){
    if(m_shouldTest){
      m_startSwap = false;
      m_shouldTest = false;

      Candy first = getCandy(m_selectionOne, m_board.m_candys);
      Candy second = getCandy(m_selectionTwo, m_board.m_candys);

      ArrayList<Candy> targetMatches = new ArrayList<Candy>();
      ArrayList<Candy> swappedMatches = new ArrayList<Candy>();
      targetMatches = hasMatch(int(first.m_x),int(first.m_y),int(second.m_x),int(second.m_y));
      swappedMatches = hasMatch(int(second.m_x),int(second.m_y),int(first.m_x),int(first.m_y));

      if(swappedMatches.size() > 0 || targetMatches.size()>0){
        m_board.setCandysToDelete(swappedMatches);
        m_board.setCandysToDelete(targetMatches);

        m_startSwap = true;
        return m_startSwap;
      }
      else{
        resetSelection();
        return m_startSwap;
      }
    }
    return m_startSwap;
  }

  ArrayList<Candy> hasMatch(int posx, int posy, int targetx, int targety){
    Candy current = getCandy(posx,posy,m_board.m_candys);
    Candy target = getCandy(targetx,targety, m_board.m_candys);

    if(g_debug){
      println("================================");
      println("Current type: " + current.m_type);
      println("Target type: " + target.m_type);
      println("================================");
    }

    // First we will swap our candy's type so we can check matches
    // In the end we will unswap them if there are no matches
    CANDYTYPES temp = target.m_type;
    target.m_type = current.m_type;
    current.m_type = temp;

    // Creating an List of Candy's that Matche so we can iterate over and destroy them
    // later
    ArrayList<Candy> matchedCandys = new ArrayList<Candy>();

    if(target.m_type == current.m_type){
      return matchedCandys;
    }

    // Creating an horizontal candy list for inserting candy's that are next to us
    ArrayList<Candy> horizontalMatches = findMatchHorizontal(targetx,targety,target.m_type,m_board);
    // Adding our target position to the matches list so we can check him later
    horizontalMatches.add(target);


    // If we have 3 or more candy with the same type in horizontal we should add a match
    // This counts with the one we are looking for
    // We should look for each candy in vertical direction after they are okay in horizontal
    if(horizontalMatches.size() >= 3 ){
      int repeatTime = horizontalMatches.size();

      for(int side = 0; side < repeatTime; side++){
        Candy sideCandy = horizontalMatches.get(side);
        horizontalMatches.addAll(findMatchVertical(int(sideCandy.m_x),int(sideCandy.m_y),target.m_type,m_board));
      }
      matchedCandys.addAll(horizontalMatches);
    }

    // Creating an vertical candy list for inserting candy's that are next to us
    ArrayList<Candy> verticalMatches = findMatchVertical(targetx,targety,target.m_type,m_board);
    verticalMatches.add(target);

    // If we have 3 or more candy with the same type in vertical we should add a match
    if(verticalMatches.size() >= 3){
      int repeatTime = verticalMatches.size();
      for(int side = 0; side < repeatTime; side++){
        Candy sideCandy = verticalMatches.get(side);
        verticalMatches.addAll(findMatchHorizontal(int(sideCandy.m_x),int(sideCandy.m_y),target.m_type,m_board));
      }

      matchedCandys.addAll(verticalMatches);
    }

    temp = target.m_type;
    target.m_type = current.m_type;
    current.m_type = temp;

    for (Candy c : matchedCandys){
      c.m_deleteAnim = true;
      c.m_currentDuration = 0.0;
    }
    return matchedCandys;
  }


  ArrayList<Candy> findMatchHorizontal(int column, int row,CANDYTYPES type,Board b){
      ArrayList<Candy> result = new ArrayList<Candy>();

      for (int i = column + 1; i < BOARD_COLUMNS; i++){
        Candy next = getCandy(i,row,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        result.add(next);
      }

      for (int i = column - 1; i >= 0; i--){
        Candy next = getCandy(i,row,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        result.add(next);
      }

      return result;
  }

  ArrayList<Candy> findMatchVertical(int column, int row, CANDYTYPES type, Board b){
      ArrayList<Candy> result = new ArrayList<Candy>();

      for (int i = row + 1; i < BOARD_ROWS; i++){
        Candy next = getCandy(column,i,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        result.add(next);
      }


      for (int i = row - 1; i >= 0; i--){
        Candy next = getCandy(column,i,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        result.add(next);
      }

      return result;
  }


  void resetSelection(){
    m_selectionOne = -1;
    m_selectionTwo = -1;
    m_shouldTest = false;
    m_startSwap = false;
  }

  void reset(){
    m_position = 0;
    m_points = 0;
    resetSelection();
  }
  void resetBoard(){
    m_board.init();
  }

}
