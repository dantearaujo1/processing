
class Board{

  Candy[][] m_board;
  int m_rectSize;
  int m_candySize;
  int m_playerPosition;

  Board(int rectSize, int candySize){

    m_playerPosition = 0;
    m_board = new Candy[BOARD_COLUMNS][BOARD_ROWS];
    for (int y = 0; y < BOARD_COLUMNS; y++){
      for (int x = 0; x < BOARD_ROWS; x++){
        m_board[y][x] = new Candy(x,y,color(random(0,255),random(0,255),random(0,255)));
      }
    }
    m_rectSize = rectSize;
    m_candySize = candySize;
  }

  void update(){

    println(getPlayerPos().x + "," + getPlayerPos().y);
  }

  void draw(){
    PVector pos = getPlayerPos();
    drawBoard();
    drawSelection(pos.x,pos.y,color(140,0,0));
    drawCandys();
  }

  void drawBoard(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        if(m_board[x][y].m_selected){
          fill(255);
        }
        else{
          fill(122,122,122);
        }
        rect(x*m_rectSize,y*m_rectSize,m_rectSize,m_rectSize);
      }
    }
  }

  void drawSelection(float x, float y, color selectionColor){
    pushStyle();
    fill(selectionColor);
    rect(x*m_rectSize,y*m_rectSize,m_rectSize,m_rectSize);
    popStyle();
  }

  void drawCandys(){
    for (int y = 0; y < BOARD_ROWS; y++){
      for (int x = 0; x < BOARD_COLUMNS; x++){
        fill(m_board[x][y].m_color);
        circle((x * m_rectSize + m_rectSize/2),(y * m_rectSize + m_rectSize/2),m_candySize);
      }
    }
  }

  Candy getCandy(int gridX, int gridY){
    if(gridX < BOARD_ROWS && gridY < BOARD_COLUMNS){
      return m_board[gridY][gridX];
    }
    return null;
  }

  int mouseToGridX(){
    return int(mouseX/m_rectSize);
  }
  int mouseToGridY(){
    return int(mouseY/m_rectSize);
  }
  void setPlayerPos(int x, int y){
    if (x >= 0 && y >= 0){
      m_playerPosition = ((x * y < BOARD_ROWS * BOARD_COLUMNS)) ? (x + y * BOARD_COLUMNS) : 0;
    }
    else{
      // TODO: If lesser than 0 should put in 0 coordinate
      /* m_playerPosition */
    }
  }

  void setPlayerPos(int id){
    if (id < 0){
      m_playerPosition = 0;
      return;
    }
    if (id > BOARD_ROWS * BOARD_COLUMNS - 1){
      m_playerPosition = BOARD_ROWS * BOARD_COLUMNS - 1;
      return;
    }
    m_playerPosition = id;


  }
  
  void move(int direction){
    switch(direction){
      case 1:
        m_playerPosition -= BOARD_COLUMNS;
        break;
      case 2:
        m_playerPosition += BOARD_COLUMNS;
        break;
      case 3:
        m_playerPosition += 1;
        break;
      case 4:
        m_playerPosition -= 1;
        break;
    }
  }

  PVector getPlayerPos(){
    return new PVector(m_playerPosition % BOARD_COLUMNS, m_playerPosition / BOARD_COLUMNS);
  }

}

