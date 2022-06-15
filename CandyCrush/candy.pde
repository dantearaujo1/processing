enum CANDYTYPES{
  RED,
  YELLOW,
  GREEN,
  BLUE,
  BLACK,
  CYAN,
  EMPTY,
};

class Candy{

  CANDYTYPES m_type;
  int m_x;
  int m_y;
  boolean m_selected;

  Candy(int x, int y, CandyCrush.CANDYTYPES type){
    m_x = x;
    m_y = y;
    m_type = type;
    m_selected = false;
  }
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
