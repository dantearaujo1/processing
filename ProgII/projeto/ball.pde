/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */

class Ball{

  // m_x and m_x are positions in the window plane 2D
  float   m_x;
  float   m_y;
  int     m_diameter;

  int     m_velZ;
  PVector m_vel;

  float   m_currentHeight;
  float   m_maxHeight;
  float   m_currentMaxHeight;
  int     m_kickCount;
  boolean m_kicking;
  Player  m_lastHit;
  // m_velZ will be used to make a fake height movement

  // m_vel will be used to move in the 2d plane x and y
  color   m_color;

  // Constructor
  Ball(){
    m_x = 0;
    m_y = 0;
    m_diameter = 15;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);
    m_velZ = 1;

    m_maxHeight = 70;
    m_currentMaxHeight = m_maxHeight;
    m_currentHeight = 0;
    m_kicking = true;
    m_kickCount = 0;
  }

  // Constructor 2 overload
  Ball(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,3);
    m_velZ = 1;

    m_maxHeight = 70;
    m_currentMaxHeight = m_maxHeight;
    m_currentHeight = 0;
    m_kicking = true;
    m_kickCount = 0;
  }

  void update(){
    if(m_kicking){
      simulateHeight();
      checkOutOfBounds();
      m_y += m_vel.y;
      m_x += m_vel.x;
    }
  }
  void draw(){

    // Getting a percentage of the distance between ball current fake height
    // and currentMaxHeight
    float shadowIncreasePercentage = 1 - m_currentHeight/m_maxHeight;
    float shadowFullSize = m_diameter * 0.6;
    float shadowSize = shadowFullSize * shadowIncreasePercentage;

    float ballIncreasePercentage = m_currentHeight/m_maxHeight <= 0.7 ? 0.7 : m_currentHeight/m_maxHeight;
    float ballFullSize = m_diameter;
    float ballSize = ballFullSize * ballIncreasePercentage;

    // Drawing shadow first so it go behind the ball fill(140);
    fill(0,100,100);
    circle(m_x,m_y + shadowSize/2,shadowSize);
    // Drawing the ball
    fill(m_color);
    circle(m_x,m_y - m_currentHeight,ballSize);
  }

  void simulateHeight(){
    if(m_kicking){
      m_currentHeight += m_velZ;
      if (m_currentMaxHeight <= 1){
        m_kicking = false;
        m_vel.x = 0;
        m_vel.y = 0;
        println("Stopped");
        return;
      }

      if(m_currentHeight <= 0){
        m_currentHeight = 0;
        m_currentMaxHeight = m_currentMaxHeight * 0.8;
        m_velZ = - m_velZ;
        m_kickCount += 1;
        println("Kick count: " + m_kickCount);
      }
      else if (m_currentHeight >= m_currentMaxHeight){
        m_currentHeight = m_currentMaxHeight;
        m_velZ = - m_velZ;
      }
    }
  }

  void checkOutOfBounds(){
    // We need to get our circle correct dimensions to check out of window
    // collision.
    float percentage = m_currentHeight/m_currentMaxHeight;
    float check = percentage < 0.7 ? 0.7 : percentage;

    if(m_y + check >= height){
      m_y = height - check;
      m_vel.y *= -1;
    }
    if(m_y - check <= 0){
      m_y = check;
      m_vel.y *= -1;
    }
    if(m_x + check >= width){
      m_x = width - check;
      m_vel.x *= -1;
    }
    if(m_x - check <= 0){
      m_x = check;
      m_vel.x *= -1;
    }
  }

  void move(int x){
    m_vel.x = x;
  }

  void hit(Player p){
    // Change ball direction
    m_vel.y *= -1;
    if(m_velZ < 0){
      // Player should push ball Z up always
      m_velZ *= p.m_facingDirection;
    }
    // Reset our kickCount
    m_kickCount = 0;

    // Set the lastPlayer to hit the ball
    m_lastHit = p;
    // We should make an formula for this.
    m_currentMaxHeight = 50;
  }

  void checkNet(Net n){
    if (n.getZ() >= m_currentHeight && m_kicking == true){
      float radius = (  m_diameter * m_currentHeight/m_currentMaxHeight ) * 2 ;
      if(m_x + radius < n.getPosX() || m_x - radius > n.getPosX() + n.getWidth()){
        return;
      }
      else if(m_y + radius < n.getPosY() - n.getHeight() || m_y - radius > n.getPosY()){
        return;
      }
      else{
        m_y = n.getPosY() - radius;
        m_kicking = false;
        m_currentMaxHeight = 0.1;
      }

    }
  }
}
