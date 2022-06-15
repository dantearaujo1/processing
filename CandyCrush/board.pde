
class Board{

  Candy[][] m_candys;
  int m_rectSize;
  int m_candySize;
  boolean m_animationEnd;

  Board(int rectSize, int candySize){

    m_candys = new Candy[BOARD_ROWS][BOARD_COLUMNS];
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        CANDYTYPES type = CANDYTYPES.values()[int(random(CANDYTYPES.values().length))];
        m_candys[y][x] = new Candy(x,y,type);
      }
    }
    m_rectSize = rectSize;
    m_candySize = candySize;
    m_animationEnd = false;
  }

  void update(){

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
        rect(x*m_rectSize,y*m_rectSize,m_rectSize,m_rectSize);
      }
    }
  }


  void drawCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        Candy ourCandy = getCandy(x,y,m_candys);
        if(ourCandy.m_type != CANDYTYPES.EMPTY){
          fill(COLORS.get(ourCandy.m_type.name()));
          circle((x * m_rectSize + m_rectSize/2),(y * m_rectSize + m_rectSize/2),m_candySize);
        }
        fill(255,255,255);
        text(x + "," + y, x * m_rectSize + m_rectSize/4, (1+y) * m_rectSize);
      }
    }
  }

  int getRectSize(){
    return m_rectSize;
  }



}

