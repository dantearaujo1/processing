// Setting Global Variables;
Game CandyCrush;
HashMap<CANDYTYPES,Integer> m_colors;

// Setup Initial State
void setup(){
  size(400,400);
  CandyCrush = new Game(0);
  m_colors = new HashMap<CANDYTYPES,Integer>();
}

// GameLoop
void draw(){
  background(0);
  CandyCrush.play();
}
//INPUT FUNCTIONS
void mousePressed(){
  if (mouseButton == LEFT){
    Board board = CandyCrush.m_board;
    Candy candy = board.getCandy(board.mouseToGridX(),board.mouseToGridY());
    if (candy != null && CandyCrush.m_choice1 == null){
      CandyCrush.m_choice1 = candy;
      candy.m_selected = true;
    }
    else if (candy != null && CandyCrush.m_choice1 != null){
      CandyCrush.m_choice2 = candy;
      candy.m_selected = true;
      CandyCrush.swap();
    }
  }
}

void keyPressed(){
  CandyCrush.handleInput(key);
}

