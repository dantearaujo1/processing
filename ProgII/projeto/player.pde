

class Player{
  float m_x;
  float m_y;
  PVector m_size;

  int m_facingDirection;

  float m_racketX;
  float m_racketY;
  float m_racketHeight;
  PVector m_racketSize;

  PVector m_vel;
  float m_power;

  boolean m_served;
  boolean m_shouldServe;

  Player(){
    m_x = width/2;
    m_y = height/2;
    m_racketX =  m_x - 15;
    m_racketY = m_y - 10;
    m_power = 10;
    m_racketHeight = 35;
    m_racketSize = new PVector(15,25);
    m_vel = new PVector(0,3);
    m_facingDirection = -1;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
  }
  Player(float x, float y, int facing){
    m_x = x;
    m_y = y;
    m_racketX =  m_x - 15;
    m_racketY = m_y - 10;
    m_power = 10;
    m_racketHeight = 35;
    m_racketSize = new PVector(15,25);
    m_facingDirection = facing;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
    m_vel = new PVector(0,3);

  }

  void hit(Ball b){
    if(checkHit(b)){
      
      // If we are in serve state we should shoot the ball at some speed and some Height
      if(!b.isServed()){
        b.setVel(0,3);        
      }
      else{
        // TODO: Make an formula when hit the ball
        // We should make an formula for this.
        b.setCurrentMaxHeight(b.getCurrentMaxHeight() + m_power);
        b.setCurrentHeight(b.getCurrentHeight());
      }
      // TODO: Correct this
      // Change ball direction
      float d = m_vel.dot(b.getVel());
      text(d,200,10);
      b.setVel(0,-b.getVel().y);
      if(b.getVelZ() < 0){
        // Player should push ball Z up always
        b.setVelZ(m_facingDirection * m_power);
      }
      // Reset our kickCount
      b.setKickCount(0);
      // Set the lastPlayer to hit the ball
      b.setLastHit(this);
      b.setServe(true);
      b.setKicking(true);
    }

  }
  
  void update(){
    if (m_x - 15 < 0){
      m_x = 15;
    }
    if (m_y - m_size.y/2 < 0){
      m_y = m_size.y/2;
    }
    if (m_x  > width - m_size.x){
      m_x = width - m_size.x;
    }
    if (m_y  > height - m_size.y){
      m_y = height - m_size.y;
    }
  }

  void draw(Ball b){
    stroke(255);
    fill(90,40,90);
    circle(m_x + m_size.x/2, m_y - m_size.y/2, m_size.x);
    fill(0,0,150);
    rect(m_x, m_y, m_size.x, m_size.y);
    fill(122,0,0);
    
    if(debug){
      if(checkHit(b)){
        fill(0,255,0);
      }
      
      stroke(255);
      rect(m_racketX,m_racketY, m_racketSize.x, m_racketSize.y);
    }

    ellipse(m_x-m_racketSize.x/2, m_y, m_racketSize.x, m_racketSize.y);

    
  }
  
  void move(int x, int y){
    m_racketX += x;
    m_racketY += y;
    m_x += x;
    m_y += y;
  }
  
  boolean checkHit(Ball b){
    float radius = b.getBallDiameter()/2;    
    if(CollisionCR(b.getBallPosition().x,b.getBallPosition().y, radius, m_racketX, m_racketY, m_racketSize.x, m_racketSize.y)){
      return true;
    }
    return false;
  }

  boolean isServed(){
    return m_served;
  }
  void setServe(boolean isAlreadyServed){
    m_served = isAlreadyServed;
  }
  float getPosX(){
    return m_x;
  }
  float getPosY(){
    return m_y;
  }
  PVector getSize(){
    return m_size;
  }
  int getFacing(){
    return m_facingDirection;
  }
  void setPos(float x, float y){
    m_x = x;
    m_y = y;
    m_racketX = m_x - 15;
    m_racketY = m_y - 13;
  }
}
