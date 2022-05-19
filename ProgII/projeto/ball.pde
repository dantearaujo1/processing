/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */

class Ball{

  float   m_x;
  float   m_y;
  int     m_diameter;

  PVector m_vel;
  float   m_velZ;

  float   m_currentHeight;
  float   m_maxHeight;
  float   m_currentMaxHeight;
  int     m_kickCount;
  Player  m_lastHit;

  // Ball States
  boolean m_kicking;
  boolean m_served;
  int     m_side;

  float serveKickDuration;
  float elapsedTime;

  color   m_color;

  // Constructor
  Ball(){
    m_x = 0;
    m_y = 0;
    m_diameter = 10;
    m_color = color(190,190,0);
    m_vel = new PVector(0,1);
    m_velZ = 1;

    m_maxHeight = 70;
    m_currentMaxHeight = m_maxHeight;
    m_currentHeight = 0;
    m_kicking = false;
    m_served = false;
    m_kickCount = 0;

    serveKickDuration = 0.6;
    elapsedTime = 0;
  }

  // Constructor 2 overload
  Ball(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,0);
    m_velZ = 70;

    m_maxHeight = 100;
    m_currentMaxHeight = m_maxHeight;
    m_currentHeight = 0;
    m_kicking = false;
    m_served = false;
    m_kickCount = 0;

    serveKickDuration = 0.6;
    elapsedTime = 0;
  }

  void update(){
    if(!m_served){
      startServing();
    }
    else if (!m_kicking && m_served){
      simulateThrow(); // This makes the ball Z thrust up and start our game going
    }
    else if(m_kicking && m_served){
      simulateHeight();
      m_y += m_vel.y * getDeltaTime();
      m_x += m_vel.x * getDeltaTime();
      checkOutOfBounds();
    }
  }
  void draw(){

    // Getting a percentage of the distance between ball current fake height
    // and currentMaxHeight
    float shadowPercentage = m_currentHeight/m_maxHeight;
    float shadowFullSize = m_diameter * 0.7;
    /* float shadowSize = shadowFullSize + shadowFullSize/2 * shadowPercentage; */
    float shadowSize = shadowFullSize ;

    /* float ballIncreasePercentage = m_currentHeight/m_maxHeight <= 0.6 ? 0.6 : m_currentHeight/m_maxHeight; */
    float ballIncreasePercentage = 0.7 + m_currentHeight/m_maxHeight;
    float ballFullSize = m_diameter;
    float ballSize = ballFullSize * ballIncreasePercentage;

    // Drawing shadow first so it go behind the ball fill(140);
    pushStyle();
    noStroke();
    fill(100,100,100,(1-m_currentHeight/m_maxHeight) * 255);
    circle(m_x,m_y+ shadowSize/2,shadowSize);

    // Drawing the ball
    fill(m_color);
    circle(m_x,m_y - m_currentHeight,ballSize);
    popStyle();

    // Debug ball information
    if(debug){
      debug();
    }
  }

  void simulateHeight(){
    if(m_kicking){
      m_velZ -= GRAVITY * getDeltaTime();
      m_currentHeight += m_velZ * getDeltaTime();

      // We to low, we should stop
      if (m_currentMaxHeight <= 1 || m_kickCount >= 2){
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
  void simulateThrow(){
    m_velZ = 116; // MAGIC NUMBER
    m_kicking = true;
  }

  void startServing(){
      float t = elapsedTime/serveKickDuration;
      if (t <= 0.70){
        m_currentHeight = (m_currentHeight) + (35 - m_currentHeight) * (t*t);
      }
      else if (t >  0.70){
        m_currentHeight = (0) + (m_currentHeight) * (1 - (t*t*t));
      }
      if (t >= 1.0){
        elapsedTime = 0;
      }
      elapsedTime += getDeltaTime();
  }

  // We need to get our circle correct dimensions to check out of window
  // collision.
  void checkOutOfBounds(){
    float percentage = m_currentHeight/m_currentMaxHeight;
    /* float check = percentage < 0.7 ? 0.7 : percentage; */
    PVector ballPos = getBallPosition();
    float check = getBallDiameter()/2;

    if(ballPos.y + check > height){
      setBallPosition(m_x, height - check);
      /* m_y = height - check - m_currentHeight; */
      m_vel.y *= -1;
    }
    if(ballPos.y - check < 0){
      setBallPosition(m_x, check);
      /* m_y =  check + m_currentHeight; */
      m_vel.y *= -1;
    }
    if(ballPos.x + check > width){
      setBallPosition(width - check, m_y + m_currentHeight);
      /* m_x = width - check; */
      m_vel.x *= -1;
    }
    if(ballPos.x - check < 0){
      setBallPosition(check, m_y + m_currentHeight);
      m_x = check;
      m_vel.x *= -1;
    }
  }

  void checkNet(Net n){

    if (n.getZ() >= m_currentHeight && m_kicking == true){
      float radius = getBallDiameter() / 2 ;
      if(!CollisionCR(m_x,m_y,radius,n.getPosX(),n.getPosY()-n.getHeight(),n.getWidth(),n.getHeight())){
        return;
      }
      else{
        m_currentHeight = 0;
        m_y = n.getPosY() - radius;
        m_kicking = false;
        m_currentMaxHeight = 0.1;
      }
    }
  }
  void setBallSide(Net n){
    if(m_y < n.getPosY()){
      m_side = 1;
  }
    else if (m_y > n.getPosY()){
      m_side = 2;
    }
  }
  void debug(){
      pushStyle();
      fill(0,255,0);
      text("Ball Position: " + m_x + "," + (m_y - m_currentHeight) , 100,15);
      text("Fake height: " + m_currentHeight, 100,30 );
      text("MaxCurrentHeight: " + m_currentMaxHeight, 100,45);
      text("Vel Z: " + m_velZ, 100, 60);
      text("Ball Radius: " + getBallDiameter()/2, 100,75);
      text("KickCount: " + m_kickCount, 0, 15);
      text("Ball Served: " + m_served, 0, 30);
      text("Side: " + m_side, 0, 45);
      text("DeltaTime: " + getDeltaTime(), 0, 45);
      text("TotalTime: " + currentTime, 0, 60);
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
  float getMaxHeight(){
    return m_maxHeight;
  }
  void setCurrentHeight(float c){
    m_currentHeight = c;
  }
  void setCurrentMaxHeight(float c){
    m_currentMaxHeight = c;
  }
  PVector getVel(){
    return m_vel.copy();
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
  void setBallPosition(float x, float y){
   m_x = x;
   m_y = y + m_currentHeight;
  }
  void setShadowPosition(float x, float y){
   m_x = x;
   m_y = y;
  }
  float getBallDiameter(){
    float check = 0.7 + m_currentHeight/m_maxHeight;
    /* return (check < 0.7) ? (m_diameter * 0.7) : (m_diameter * check); */
    return check;
  }
}
