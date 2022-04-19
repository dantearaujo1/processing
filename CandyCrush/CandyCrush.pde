Game CandyCrush;
void setup(){
  size(400,400);
  CandyCrush = new Game(0);
}

void draw(){
  background(0);
  CandyCrush.play();
}

void mousePressed(){
  if (mouseButton == LEFT){
    Board board = CandyCrush.m_board;
    Candy candy = board.getCandy(board.mouseToGridX(),board.mouseToGridY());
    if (candy != null && CandyCrush.m_choice1 == null){
      pushStyle();
      fill(255);
      circle(candy.m_x * board.m_rectSize + board.m_rectSize/2,candy.m_y * board.m_rectSize + board.m_rectSize/2, board.m_candySize);
      popStyle();
      CandyCrush.m_choice1 = candy;
    }
    else if (candy != null && CandyCrush.m_choice1 != null){
      CandyCrush.m_choice2 = candy;
      CandyCrush.swap();
    }
  }
}

void mouseReleased(){
}


class Game{
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
    if(difX >= -1 && difX <= 1 && difY >= -1 && difY <= 1){
      color temp = m_choice1.m_color;
      m_choice1.m_color = m_choice2.m_color;
      m_choice2.m_color = temp;
      println("Swap");
    }
    m_choice1 = null;
    m_choice2 = null;
  }

  int m_score;
  int m_level;
  Board m_board;
  Candy m_choice1;
  Candy m_choice2;

}

final int BOARD_ROWS = 12;
final int BOARD_COLUMNS = 10;
class Board{

  Board(int rectSize, int candySize){

    m_board = new Candy[BOARD_COLUMNS][BOARD_ROWS];
    for (int y = 0; y < BOARD_COLUMNS; y++){
      for (int x = 0; x < BOARD_ROWS; x++){
        m_board[y][x] = new Candy(x,y,color(random(0,255),random(0,255),random(0,255)));
      }
    }
    m_rectSize = rectSize;
    m_candySize = candySize;
    m_picked = false;
  }

  void update(){
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

  Candy[][] m_board;
  int m_rectSize;
  int m_candySize;
  boolean m_picked;
}

class Candy{
  Candy(int x, int y, color l_color){
    m_color = l_color;
    m_x = x;
    m_y = y;
  }

  color m_color;
  int m_x;
  int m_y;

}


class Swap{
  Swap(){

  }

  boolean satisfied(){
    return true;
  }

  Candy m_cookieA;
  Candy m_cookieB;
}
