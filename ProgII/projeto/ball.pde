/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */

class Ball{

  float m_x;
  float m_y;
  float m_z;
  float m_newY;
  float m_oldY;
  int   m_diameter;
  color m_color;
  PVector m_vel;

  Ball(){
    m_x = 0;
    m_y = 0;
    m_oldY = 0;
    m_z = m_y + 100;
    m_diameter = 15;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);

  }
  Ball(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_oldY = y;
    m_z = m_y + 100;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);

  }

  void update(){
    simulateHeight();
  }
  void draw(){
    fill(140);
    circle(m_x,m_z ,m_diameter/2);
    fill(m_color);
    circle(m_x,m_y,m_diameter);
  }

  void simulateHeight(){
    m_y += m_vel.y;
    // if (m_y >= m_z){
    //   m_y = m_z;
    //   m_vel.y = - m_vel.y;
    //   m_newY = m_z - (m_oldY - m_z) * 0.8;
    // }
    // if (m_y < m_newY){
    //   m_y = m_newY;
    //   m_vel.y = - m_vel.y;
    //   m_oldY = m_newY;
    // }
  }
}
