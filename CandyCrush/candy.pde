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
  float m_x;
  float m_y;
  float m_startX;
  float m_startY;
  float m_endX;
  float m_endY;

  boolean m_selected;

  float m_initialAnimDuration;
  float m_swapAnimDuration;
  float m_deleteAnimDuration;
  float m_currentDuration;

  boolean m_initialAnim;
  boolean m_swapAnim;
  boolean m_deleteAnim;



  Candy(int x, int y, CandyCrush.CANDYTYPES type){
    m_x = x;
    m_y = -100;
    m_startX = x;
    m_startY = (-100);
    m_endX = x;
    m_endY = y;
    m_type = type;

    m_initialAnim = true;
    m_swapAnim = false;
    m_deleteAnim = false;
    m_initialAnimDuration = 1.5;
    m_swapAnimDuration = 0.4;
    m_currentDuration = 0.0;
    m_deleteAnimDuration = 1.0;
  }

  void update(float dt){
    if(m_initialAnim){
      initialAnimation(dt);
    }
    if(m_swapAnim){
      swapAnimation(dt);
    }
    if(m_deleteAnim){
      deleteAnimation(dt);
    }
    m_currentDuration += dt;
  }

  void draw(float offsetX, float offsetY){
    if(m_type != CANDYTYPES.EMPTY){
      if(m_deleteAnim){
        float a = interpolation(255,0,m_currentDuration/m_deleteAnimDuration);
        color c = COLORS.get(m_type.name());
        fill(COLORS.get(m_type.name()),a);
        noStroke();
      }
      else{
        fill(COLORS.get(m_type.name()));
      }
      circle((offsetX + m_x * RECT_SIZE + RECT_SIZE/2),(offsetY + m_y * RECT_SIZE + RECT_SIZE/2),CANDY_SIZE);
      stroke(0);
    }
  }

  void initialAnimation(float dt){
    if(m_currentDuration >= m_initialAnimDuration){
      m_initialAnim = false;
      m_startX = m_endX;
      m_startY = m_endY;
      m_currentDuration = m_initialAnimDuration;
    }
    m_y = interpolation(m_startY,m_endY,m_currentDuration/m_initialAnimDuration);
  }
  void deleteAnimation(float dt){
    if(m_currentDuration >= m_deleteAnimDuration){
      m_deleteAnim = false;
      m_type = CANDYTYPES.EMPTY;
      m_currentDuration = m_deleteAnimDuration;
    }
  }
  void swapAnimation(float dt){
    if(m_currentDuration >= m_swapAnimDuration){
      m_swapAnim = false;
      m_currentDuration = m_swapAnimDuration;
    }
    m_y = interpolation(m_startY,m_endY,flip(easeOut(m_currentDuration/m_swapAnimDuration)));
    m_x = interpolation(m_startX,m_endX,flip(easeOut(m_currentDuration/m_swapAnimDuration)));
  }

  Candy copy(){
    Candy newCandy = new Candy(int(m_x),int(m_y),m_type);
    newCandy.m_initialAnim = false;
    newCandy.m_swapAnim = false;
    newCandy.m_y = m_y;
    return newCandy;
  }

}

class SwapData{
  SwapData(Candy one, Candy two){
    if(one != null){
      m_first = one;
    }
    if(two != null){
      m_second = two;
    }
  }

  Candy m_first;
  Candy m_second;
}
