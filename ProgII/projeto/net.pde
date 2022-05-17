class Net{

  float   m_x;
  float   m_y;
  int     m_z; // This is the Z fake height
  PVector m_size;

  Net(){
    m_x = 0;
    m_y = 0;
    m_z = 7;
    m_size = new PVector();
  }

  void update(){
  }
  void draw(){
    fill(180);
    // We subtract m_size.y from m_y to put our bottom end in the middle of
    // points
    rect(m_x,m_y - m_size.y,m_size.x,m_size.y);
  }

  void setPos(float x, float y){
    m_x = x;
    m_y = y;
  }
  float getPosX(){
    return m_x;
  }
  float getPosY(){
    return m_y;
  }
  void setSize(float w, float h){
    m_size.x = w;
    m_size.y = h;
  }
  float getHeight(){
    return m_size.y;
  }
  float getWidth(){
    return m_size.x;
  }
  int getZ(){
    return m_z;
  }

}
