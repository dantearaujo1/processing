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

  boolean m_selected;

  float m_animDuration;
  float m_currentDuration;
  boolean m_anim;


  Candy(int x, int y, CandyCrush.CANDYTYPES type){
    m_x = x;
    m_y = y;
    m_startX = x;
    m_startY = 0.0;
    m_type = type;

    m_anim = true;
    /* m_animDuration = random(0.5,4); */
    m_animDuration = 2-(y+1)/random(8,11.0);
    m_currentDuration = 0.0;
  }

  void update(float dt){
    if(m_anim){
      animate(dt);
      m_startY = interpolation(-2,m_y,m_currentDuration/m_animDuration);
    }
  }

  void draw(){
    if(m_type != CANDYTYPES.EMPTY){
      fill(COLORS.get(m_type.name()));
      circle((m_startX * RECT_SIZE + RECT_SIZE/2),(m_startY * RECT_SIZE + RECT_SIZE/2),CANDY_SIZE);
    }
  }

  void animate(float dt){
    m_currentDuration += dt;
    if(m_currentDuration >= m_animDuration){
      m_anim = false;
      m_currentDuration = m_animDuration;
    }
  }

  float interpolation(float st, float end, float percentage){
    return st + (end - st) * percentage;
  }
}

