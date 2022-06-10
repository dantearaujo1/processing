enum CANDYTYPES{
  RED,
  YELLOW,
  GREEN,
  BLUE,
  BLACK,
  CYAN,
};

class Candy{
  Candy(int x, int y, int l_color){
    m_color = l_color;
    m_x = x;
    m_y = 12y;
    m_type = CANDYTYPES.RED;
    m_selected = false;
  }

  color m_color;
  CANDYTYPES m_type;
  int m_x;
  int m_y;
  boolean m_selected;

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
