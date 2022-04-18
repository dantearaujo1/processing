Game CandyCrush;
void setup(){
  size(400,400);
  CandyCrush = new Game(0);
}

void draw(){
  background(0);
  CandyCrush.play();
}


class Game{
  Game(int level){
    m_level = level;
    m_score = 0;
    m_board = new Board(25,15);
  }

  void play(){
    m_board.update();
    m_board.draw();
  }

  int m_score;
  int m_level;
  Board m_board;

}

final int BOARD_ROWS = 13;
final int BOARD_COLUMNS = 16;
class Board{

  Board(int rectSize, int candySize){

    m_board = new Candy[BOARD_COLUMNS][BOARD_ROWS];
    for (int y = 0; y < BOARD_COLUMNS; y++){
      for (int x = 0; x < BOARD_ROWS; x++){
        m_board[y][x] = new Candy(color(random(0,255),random(0,255),random(0,255)));
      }
    }
    m_rectSize = rectSize;
    m_candySize = candySize;
    m_picked = false;
  }

  void update(){
    if(mouseButton == LEFT){
      text("PRESSED",100,100);
    }

  }

  void draw(){
    drawBoard();
    drawCandys();
  }

  void drawBoard(){
    for (int y = 0; y < BOARD_COLUMNS; y++){
      for (int x = 0; x < BOARD_ROWS; x++){
        fill(122,122,122);
        rect(x*m_rectSize,y*m_rectSize,m_rectSize,m_rectSize);
      }
    }
  }

  void drawCandys(){
    for (int y = 0; y < BOARD_COLUMNS; y++){
      for (int x = 0; x < BOARD_ROWS; x++){
        fill(m_board[y][x].m_color);
        circle((x * m_rectSize + m_rectSize/2),(y * m_rectSize + m_rectSize/2),m_candySize);
      }
    }
    if (m_picked){
      fill(255);
      // circle((x * m_rectSize + m_rectSize/2),(y * m_rectSize + m_rectSize/2),m_candySize);
      
    }
  }

  Candy getCandy(int gridX, int gridY){
    return m_board[gridY][gridX];
  }

  int mouseToGridX(){
    return int(mouseX/m_rectSize);
  }
  int mouseToGridY(){
    return int(mouseY/m_rectSize);
  }

  Candy[][] m_board;
  int m_rectSize;
  int m_candySize;
  boolean m_picked;
}

class Candy{
  Candy(color l_color){
    m_color = l_color;
  }

  Action m_action;
  color m_color;

}

class Action{
  Action(){

  }

  void doIt(){

  }

  ArrayList<Condition> m_conditions;
}

class Condition{
  Condition(){

  }

  boolean satisfied(){
    return true;
  }
}
