/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */

class Ball{

  float   m_x;
  float   m_y;
  int     m_diameter;

  float   m_velZ;
  PVector m_vel;

  float   m_currentHeight;
  float   m_maxHeight;
  float   m_currentMaxHeight;
  int     m_kickCount;
  Player  m_lastHit;

  // Ball States
  boolean m_kicking;
  boolean m_served;
  int     m_side;

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
    m_kicking = false;
    m_served = false;
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
    m_currentHeight = 70;
    m_kicking = false;
    m_served = false;
    m_kickCount = 0;
  }

  void update(){
    if(m_kicking && m_served){
      m_velZ -= 0.08;
      simulateHeight();
      checkOutOfBounds();
      m_y += m_vel.y;
      m_x += m_vel.x;
    }
    if(!m_served){
      startServing();
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
    circle(m_x,m_y+ shadowSize/2,shadowSize);
    // Drawing the ball
    fill(m_color);
    circle(m_x,m_y - m_currentHeight,ballSize);

    // Debug ball information
    if(debug){
      debug();
    }
  }

  void simulateHeight(){
    if(m_kicking){
      m_currentHeight += m_velZ;
      if (m_currentMaxHeight <= 1){
        m_kicking = false;
        m_vel.x = 0;
        m_vel.y = 0;
        return;
      }

      if(m_currentHeight <= 0){
        m_currentHeight = 0;
        m_currentMaxHeight = m_currentMaxHeight * 0.8;
        m_velZ = - m_velZ * 0.8;
        m_kickCount += 1;
      }
      else if (m_currentHeight >= m_currentMaxHeight){
        m_currentHeight = m_currentMaxHeight;
      }
    }
  }

  void startServing(){
      float t = time/duration;
      /* if (t <= 0.70){ */
      /*   m_currentHeight = (m_currentHeight) + (35 - m_currentHeight) * ((t)); */
      /* } */
      /* else if (t >  0.70){ */
      /*   m_currentHeight = (0) + (m_currentHeight) * (1 - (t*t*t)); */
      /* } */
      /* if (t >= 1.0){ */
      /*   time = 0; */
      /* } */
      text("TIME: " + time, 20,20);
      text("Duration: " + duration, 20,40);
      text("T: " + t, 20,60);
      time += 2;
  }

  // We need to get our circle correct dimensions to check out of window
  // collision.
  void checkOutOfBounds(){
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

  void hit(Player p){
  }

  void checkNet(Net n){
    if (n.getZ() >= m_currentHeight && m_kicking == true){
      float radius = (  m_diameter * m_currentHeight/m_currentMaxHeight ) / 2 ;
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
    if(m_y < n.getPosY()){
      m_side = 1;
    }
    else if (m_y > n.getPosY()){
      m_side = 2;
    }
    else{
      // IMPOSSIBRU
    }
  }
  void debug(){
      pushStyle();
      fill(0,255,0);
      text("Position: " + m_x + "," + (m_y - m_currentHeight) , m_x, m_y - 20);
      text("Z height: " + m_currentHeight, m_x + 30, m_y );
      text("MaxCurrentHeight: " + m_currentMaxHeight, m_x + 30,  m_y + 20);
      text("Vel Z: " + m_velZ, m_x + 30,  m_y + 40);
      text("Radius: " + getBallDiameter()/2, m_x + 30, m_y + 60);
      text("KickCount: " + m_kickCount, 100, 16);
      text("Served: " + m_served, 100, 30);
      text("Side: " + m_side, 100, 60);
      popStyle();

  }
  // SOME GETTERS AND SETTERS ======================================================
  void setPos(float x, float y){
    m_x = x;
    m_y = y;
  }
  float getCurrentMaxHeight(){
    return m_currentMaxHeight;
  }
  float getCurrentHeight(){
    return m_currentHeight;
  }
  void setCurrentHeight(float c){
    m_currentHeight = c;
  }
  void setCurrentMaxHeight(float c){
    m_currentMaxHeight = c;
  }
  PVector getVel(){
    return m_vel;
  }
  void setVel(float x, float y){
    m_vel.x = x;
    m_vel.y = y;
  }
  float getVelZ(){
    return m_velZ;
  }
  void setVelZ(float c){
    m_velZ = c;
  }
  int getKickCount(){
    return m_kickCount;
  }
  void setKickCount(int i){
    m_kickCount = i;
  }
  Player getLastHit(){
    return m_lastHit;
  }
  void setLastHit(Player p){
    m_lastHit = p;
  }
  boolean isServed(){
    return m_served;
  }
  void setServe(boolean alreadyServed){
    m_served = alreadyServed;
  }
  boolean isKicking(){
    return m_kicking;
  }
  void setKicking(boolean shouldKick){
    m_kicking = shouldKick;
  }
  // ==========================================================================
  // Helpers =================================================================
  PVector getBallPosition(){
    return new PVector(m_x,m_y - m_currentHeight);
  }
  float getBallDiameter(){
   return (m_diameter * m_currentHeight/m_maxHeight);
  }
}


