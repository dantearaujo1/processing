class Tween{
  float   m_clock;
  float   m_duration;
  int     m_from;
  int     m_to;
  boolean m_loop;

  Tween(float duration, int from, int to){
    set(0);
    m_duration = duration;
    m_from = from;
    m_to = to;
    m_loop = false;
  }

  void set(float clock){
    if (clock <= 0){
      m_clock = 0;
      return;
    }
    m_clock = clock;
  }

  void setLoop(boolean lp){
    m_loop = lp;
  }

  void setDuration(float d){
    if (d >= 0){
      m_duration = d;
    }
  }

  float getPosition(){
    return (m_from + (m_to - m_from) * m_clock/m_duration);
  }

  void update(float dt){
    if(hasEnded()){
      if(m_loop){
        m_clock = 0;
      }
      else{
        m_clock = m_duration;
      }
    }
    else{
      m_clock += dt;
    }
  }

  boolean hasEnded(){
    return (m_clock >= m_duration);
  }
}
