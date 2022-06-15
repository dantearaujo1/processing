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
    /* else{ */
    /*   resetSelection(); */
    /* } */
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

      if(hasMatch(first.m_x,first.m_y,second.m_x,second.m_y)) {
        m_shouldTest = false;
        m_startSwap = true;
      }
      if(hasMatch(second.m_x,second.m_y,first.m_x,first.m_y)){
        m_shouldTest = false;
        m_startSwap = true;
      }
      return m_startSwap;
    }
    return m_startSwap;
  }
  boolean hasMatch(int posx, int posy, int targetx, int targety){
    Candy current = getCandy(posx,posy,m_board.m_candys);
    Candy target = getCandy(targetx,targety, m_board.m_candys);

    // First we will swap our candy's so we can check matches
    // In the end we will unswap them if there are no matches
    CANDYTYPES temp = target.m_type;
    target.m_type = current.m_type;
    current.m_type = temp;

    // Creating an Map of Candy Matches so we can iterate over and destroy them
    // later
    HashMap<Candy,ArrayList<Candy>> matchedCandys = new HashMap<Candy,ArrayList<Candy>>();
    println("=======LOOKING FOR MATCH STARTING AT: " + targetx + "," + targety + "=======");
    println("================WITH COLOR: " + target.m_type + "=============");
    // Creating an horizontal candy list for inserting candy's that are next to us
    ArrayList<Candy> horizontalMatches = findMatchHorizontal(targetx,targety,target.m_type,m_board);
    // Creating an vertical candy list for inserting candy's that are next to us
    ArrayList<Candy> verticalMatches = findMatchVertical(targetx,targety,target.m_type,m_board);


    // If we have 2 or more candy with the same type in horizontal we should add a match
    if(horizontalMatches.size() >= 2 ){
      matchedCandys.put(target,horizontalMatches);
    }

    // If we have 2 or more candy with the same type in vertical we should add a match
    if(verticalMatches.size() >= 2){
        matchedCandys.put(target,verticalMatches);
    }

    // Going for everyMatch entry and changing candy types to empty
    // This will change other candy's than the current and target
    // We need to solve them later
    for(HashMap.Entry<Candy,ArrayList<Candy>> candyEntry : matchedCandys.entrySet()){
      for (int i = 0; i < candyEntry.getValue().size(); i++){
        Candy candy = candyEntry.getValue().get(i);
        candy.m_type = CANDYTYPES.EMPTY;
      }
    }

    // If we have matches return true
    if(matchedCandys.size() > 0){
      // We are unswapping our target candy's to another test
      // If we have more than one matches we should empty our current type
      target.m_type = current.m_type;
      current.m_type = CANDYTYPES.EMPTY;
      return true;
    }
    // We should unswap even if there are no matches
    println("NO MATCHES FOUND");
    temp = target.m_type;
    target.m_type = current.m_type;
    current.m_type = temp;
    return false;
  }


  ArrayList<Candy> findMatchHorizontal(int column, int row,CANDYTYPES type,Board b){
      ArrayList<Candy> result = new ArrayList<Candy>();
      println("After Horizontal ==============");
      for (int i = column + 1; i < BOARD_COLUMNS; i++){
        Candy next = getCandy(i,row,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        print("[Position: " + next.m_x + "," + next.m_y);
        println(" Color: " + next.m_type + "]");
        result.add(next);
        println(" Added an Candy: " + next.m_type + " at: " + next.m_x + "," + next.m_y + " total candys found in horizontal: " + result.size());
      }
      println("Before Horizontal =============");
      for (int i = column - 1; i >= 0; i--){
        Candy next = getCandy(i,row,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        print("[Position: " + next.m_x + "," + next.m_y);
        println(" Color: " + next.m_type + "]");
        result.add(next);
        println(" Added an Candy: " + next.m_type + " at: " + next.m_x + "," + next.m_y + " total candys found in horizontal: " + result.size());
      }
      return result;
  }
  ArrayList<Candy> findMatchVertical(int column, int row, CANDYTYPES type, Board b){
      ArrayList<Candy> result = new ArrayList<Candy>();
      println("After Vertical =============");
      for (int i = row + 1; i < BOARD_ROWS; i++){
        Candy next = getCandy(column,i,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        print("[Position: " + next.m_x + "," + next.m_y);
        println(" Color: " + next.m_type + "]");
        result.add(next);
        println(" Added an Candy: " + next.m_type + " at: " + next.m_x + "," + next.m_y + " total candys found in vertical: " + result.size());
      }
      println("Before Vertical =============");
      for (int i = row - 1; i >= 0; i--){
        Candy next = getCandy(column,i,b.m_candys);
        if(next.m_type != type || next.m_type == CANDYTYPES.EMPTY){
          break;
        }
        print("[Position: " + next.m_x + "," + next.m_y);
        println(" Color: " + next.m_type + "]");
        result.add(next);
        println(" Added an Candy: " + next.m_type + " at: " + next.m_x + "," + next.m_y + " total candys found in vertical: " + result.size());
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

}
