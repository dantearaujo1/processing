/*
   This is the Ball class responsible for create an illusion of
   the ball height in a 2D canvas
   */

enum STATES{
    GAME_POINT,
    GAME_PLAYING,
    GAME_SERVING,
    GAME_FIRSTHIT,
    ANIM_SERVE,
}

class Ball{

  float   m_x;
  float   m_y;
  int     m_diameter;

  PVector m_vel;
  float   m_velZ;

  float   m_currentHeight;
  float   m_currentMaxHeight;
  int     m_kickCount;
  Player  m_lastHit;

  // Ball States
  int     m_side;
  boolean m_showShadow;
  STATES  m_states;

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

    m_currentMaxHeight = BALL_MAX_HEIGHT;
    m_currentHeight = 0;
    m_kickCount = 0;

    serveKickDuration = 0.6;
    elapsedTime = 0;
    m_states = STATES.GAME_SERVING;
  }

  // Constructor 2 overload
  Ball(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,0);
    m_velZ = 2;

    m_currentMaxHeight = BALL_MAX_HEIGHT;
    m_currentHeight = 0;
    m_kickCount = 0;

    serveKickDuration = 0.6;
    elapsedTime = 0;
    m_states = STATES.GAME_SERVING;
  }

  void init(float x, float y, int d){
    m_x = x;
    m_y = y;
    m_diameter = d;
    m_color = color(190,190,0);
    m_vel = new PVector(0,0);
    m_velZ = 70;

    m_currentMaxHeight = BALL_MAX_HEIGHT;
    m_currentHeight = 0;
    m_kickCount = 0;

    serveKickDuration = 0.6;
    elapsedTime = 0;
    m_states = STATES.GAME_SERVING;
  }

  void update(){
    if(m_states == STATES.GAME_SERVING){
      kickBallAnimation();
    }
    else if (m_states == STATES.ANIM_SERVE){
      simulateThrow(); // This makes the ball Z thrust up and start our game going
    }
    else if(m_states == STATES.GAME_PLAYING || m_states == STATES.GAME_FIRSTHIT){
      simulateHeight();
      m_y += m_vel.y * getDeltaTime();
      m_x += m_vel.x * getDeltaTime();
      checkOutOfBounds();
    }
  }
  // GERAL LOGIC UPDATE FUNCTIONS ==================================================
  void kickBallAnimation(){
      float t = elapsedTime/serveKickDuration;
      if (t <= BALL_ANIMATION_KICK_UP){
        m_currentHeight = (m_currentHeight) + (BALL_ANIMATION_END_OFFSET_Y - m_currentHeight) * (t*t);
      }
      else if (t >  BALL_ANIMATION_KICK_DOWN){
        m_currentHeight = (0) + (m_currentHeight) * (1 - (t*t*t));
      }
      if (t >= 1.0){
        elapsedTime = 0;
      }
      elapsedTime += getDeltaTime();
      Player p = m_lastHit;
      m_x = p.getRacketX();
      m_y = p.getPosY() + 20;
  }

  void simulateThrow(){
    m_velZ = 116; // MAGIC NUMBER
    m_states = STATES.GAME_FIRSTHIT;
  }

  void simulateHeight(){

      m_velZ -= GRAVITY * getDeltaTime();
      m_currentHeight += m_velZ * getDeltaTime();

      // We to low, we should stop
      // Probably m_currentMaxHeight never going down to 1
      // With small numbers of BALL_MAX_KICKS
      if (m_currentMaxHeight <= 1 || m_kickCount >= BALL_MAX_KICKS){
        m_states = STATES.GAME_POINT;
        m_kickCount = 0;
        return;
      }
      if(m_currentHeight <= 0){
        m_currentHeight = 0;
        m_currentMaxHeight = m_currentMaxHeight * BALL_MAXHEIGHT_DECREASE_PERCENTAGE;
        m_velZ = - m_velZ * BALL_Z_DECREASE_PERCENTAGE;
        m_kickCount += 1;
      }
      else if (m_currentHeight >= m_currentMaxHeight){
        m_currentHeight = m_currentMaxHeight;
      }
  }
  // ===============================================================================

  void draw(){

    // Getting a percentage of the distance between ball current fake height
    // and currentMaxHeight
    float shadowPercentage = m_currentHeight/BALL_MAX_HEIGHT;
    float shadowFullSize = m_diameter * SHADOW_FULL_PERCENTAGE;
    float shadowSize = shadowFullSize ;

    float ballIncreasePercentage = BALL_MINIMUM_PERCENTAGE + m_currentHeight/70;
    float ballFullSize = m_diameter;
    float ballSize = ballFullSize * ballIncreasePercentage;

    // Drawing shadow first so it go behind the ball fill(140);
    pushStyle();
    noStroke();
    /* fill(100,100,100,(1-m_currentHeight/BALL_ANIMATION_MAX_HEIGHT) * 255); */
    fill(100,100,100,(1-m_currentHeight/(BALL_MAX_HEIGHT + BALL_ANIMATION_MAX_HEIGHT)) * 255);
    fill(0,0,0);
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



  // We need to get our circle correct dimensions to check out of window
  // collision.
  void checkOutOfBounds(){

    float percentage = m_currentHeight/m_currentMaxHeight;
    PVector ballPos = getBallPosition();
    float check = getBallDiameter()/2;

    if(ballPos.y + check > height){
      setBallPosition(m_x, height - check);
      m_vel.y *= -1;
    }
    if(ballPos.y - check < 0){
      setBallPosition(m_x, check);
      m_vel.y *= -1;
    }
    if(ballPos.x + check > width){
      setBallPosition(width - check, m_y + m_currentHeight);
      m_vel.x *= -1;
    }
    if(ballPos.x - check < 0){
      setBallPosition(check, m_y + m_currentHeight);
      m_x = check;
      m_vel.x *= -1;
    }
  }

  void checkNet(Net n){

    if (n.getZ() >= m_currentHeight && m_states == STATES.GAME_PLAYING){
      float radius = getBallDiameter() / 2 ;
      if(!CollisionCR(m_x,m_y,radius,n.getPosX(),n.getPosY()-n.getHeight(),n.getWidth(),n.getHeight())){
        return;
      }
      else{
        m_currentHeight = 0;
        m_y = n.getPosY() - radius;
        m_currentMaxHeight = 0.1;
        m_states = STATES.GAME_POINT;
      }
    }
  }

  void checkCourt(Court c){
    PVector pos = getBallPosition();
    if(!CollisionPTrapeze(pos.x,pos.y,c.getAngle(),c.getVertices()) && m_currentHeight == 0){
      if(m_states == STATES.GAME_PLAYING){
        m_states = STATES.GAME_POINT;
      }
    }
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
    return BALL_MAX_HEIGHT;
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
  void setBallSide(Net n){
    if(m_y < n.getPosY()){
      m_side = 1;
  }
    else if (m_y > n.getPosY()){
      m_side = 2;
    }
  }
  int getSide(){
    return m_side;
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
    float check = BALL_MINIMUM_PERCENTAGE + m_currentHeight/BALL_MAX_HEIGHT;
    return check;
  }
  boolean checkEnd(){
    return (m_states == STATES.GAME_POINT);
  }
  boolean isInGame(){
    return (m_states == STATES.GAME_PLAYING);
  }
  boolean isServed(){
    return (m_states == STATES.GAME_FIRSTHIT);
  }
  void startServeAnimation(){
    m_states = STATES.ANIM_SERVE;
  }
  void startServing(){
    init(0,640,15);
  }

  void debug(){
      pushStyle();
      fill(0,255,0);
      text("Ball Position: " + m_x + "," + (m_y - m_currentHeight) , 100,15);
      text("Fake height: " + m_currentHeight, 100,30 );
      text("MaxCurrentHeight: " + m_currentMaxHeight, 100,45);
      text("Vel Z: " + m_velZ, 100, 60);
      text("Ball Radius: " + getBallDiameter()/2, 100,75);
      text("Ball END: " + checkEnd(), 0, 30);
      text("Ball STATE: " + m_states, 0, 90);
      text("KickCount: " + m_kickCount, 0, 15);
      text("Side: " + m_side, 0, 45);
      text("DeltaTime: " + nfs(getDeltaTime(),0,3), 0, 60);
      text("TotalTime: " + currentTime, 0, 75);
      popStyle();

  }
}

