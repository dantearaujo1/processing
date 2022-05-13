

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

  }

  void hit(Ball b){
    if(checkHit(b)){
      if(!b.isServed()){
        b.setVel(0,3);
        b.setCurrentHeight(2 * b.getCurrentHeight());
      }
      else{
        // TODO: Make an formula when hit the ball
        // We should make an formula for this.
        b.setCurrentMaxHeight(b.getCurrentMaxHeight() + m_power);
        b.setCurrentHeight(b.getCurrentHeight());
      }
      // TODO: Correct this
      // Change ball direction
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

  void update(Ball b){
  }

  void draw(Ball b){
    fill(90,40,90);
    circle(m_x + m_size.x/2, m_y - m_size.y/2, m_size.x);
    fill(0,0,150);
    rect(m_x, m_y, m_size.x, m_size.y);
    text(m_x + "," + m_y, m_x, m_y);
    text(( m_x + m_size.x) + "," + ( m_y + m_size.y ), ( m_x + m_size.x), ( m_y + m_size.y ));
    fill(122,0,0);
    pushMatrix();
    translate(m_x - 15,m_y - 10);
    rotate(-PI/6);
    if(debug){
      if(checkHit(b)){
        fill(0,255,0);
      }
    }
    ellipse(0, 0, m_racketSize.x, m_racketSize.y);
    popMatrix();
    if(debug){
      noFill();
      stroke(255);
      rect(m_racketX - 12,m_racketY - 15, m_racketSize.x + 7, 30);
    }
  }
  void move(int x, int y){
    m_racketX += x;
    m_racketY += y;
    m_x += x;
    m_y += y;
  }
  boolean checkHit(Ball b){
    float radius = b.getBallDiameter()/2;
    float adjustmentX = m_racketX - 12;
    float adjustmentY = m_racketY - 15;
    if(adjustmentX + m_racketSize.x + 6<= b.getBallPosition().x - radius || adjustmentX >= b.getBallPosition().x + radius ){
      return false;
    }
    if(adjustmentY  + m_racketSize.y <= b.getBallPosition().y || adjustmentY  >= b.getBallPosition().y + radius ){
      return false;
    }
    return true;
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
    m_racketY = m_y - 12;
  }
}

