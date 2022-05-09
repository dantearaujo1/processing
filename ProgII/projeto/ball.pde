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
  PVector m_vel;

  int   m_diameter;
  float m_maxShadowDistance;
  color m_color;

  Ball(){
    m_x = 0;
    m_y = 0;
    m_oldY = 0;
    m_maxShadowDistance = 100;
    m_z = m_y + m_maxShadowDistance;
    m_diameter = 15;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);

  }
  Ball(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_oldY = y;
    m_maxShadowDistance = 100;
    m_z = m_y + m_maxShadowDistance;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);

  }

  void update(){
    simulateHeight();
    m_y += m_vel.y;
    /* m_vel.y += 1; */
  }
  void draw(){
    // Getting a percentage of maxShadowDistance to increase shadowDiameter
    float shadowIncreasePercentage = 1 - (m_z - m_y)/m_maxShadowDistance;
    float shadowFullSize = m_diameter * 0.7;
    float shadowSize = shadowFullSize * shadowIncreasePercentage;
    // Drawing shadow first so it go behind the ball
    fill(140);
    circle(m_x,m_z + shadowSize/2,shadowSize);

    // Drawing the ball
    fill(m_color);
    circle(m_x,m_y,m_diameter);
  }

  void simulateHeight(){
    // CAUTION: Positions of the circle are in the center

    // Checking if our new ball height is to low so we stop if it is
    if (m_z - m_newY < 1){
      m_vel.y = 0;
      return;
    }

    // Checking if our center hits the center of the shadow
    if (m_y >= m_z){
      m_y = m_z ;
      m_vel.y = - m_vel.y;
      m_newY = m_z - (m_z - m_oldY) * 0.8;
    }
    // Checking if ou center hits our new Simulated Height
    if (m_y < m_newY){
      m_y = m_newY;
      m_vel.y = - m_vel.y;
      m_oldY = m_newY;
    }

  }
}
