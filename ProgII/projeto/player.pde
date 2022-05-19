

class Player {
  float m_x;
  float m_y;
  PVector m_size;

  int m_facingDirection;

  float m_racketX;
  float m_racketY;
  float m_racketXOffset;
  float m_racketYOffset;
  float m_racketHeight;
  float m_racketDiameter;

  PVector m_vel;
  float m_power;

  boolean m_served;
  boolean m_shouldServe;

  int m_score;

  Player(){
    m_x = width/2;
    m_y = height/2;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_power = 100;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    m_vel = new PVector(0,0);
    m_facingDirection = -1;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
    m_score = 0;
  }
  Player(float x, float y, int facing){
    m_x = x;
    m_y = y;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_power = 100;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    m_facingDirection = facing;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
    m_vel = new PVector(0,0);
    m_score = 0;
  }

  void handleInput(){
    /* if(keyPressed && key == 'd'){ */
    /*   setVelX(100); */
    /* } */
    /* else if(keyPressed && key == 'a'){ */
    /*   setVelX(-100); */
    /* } */
    /* if(keyPressed && key == 'w'){ */
    /*   setVelY(-100); */
    /* } */
    /* else if(keyPressed && key == 's'){ */
    /*   setVelY(100); */
    /* } */
  }

  void hit(Ball b){
    if(checkHit(b)){

      // If we are in serve state but did not hit the ball yet we should go here
      if(b.isServed() && !isServed()){
        b.setVel(0,200 * m_facingDirection);
        b.setVelZ(m_power);
        setServe(true);
        return;
      }
      // Already Served the ball and hitted.

      // TODO: Make an formula when hit the ball
      PVector bpos = b.getBallPosition();
      float dist = dist(bpos.x,bpos.y,m_racketX,m_racketY);
      float result = m_power * (1 - dist/m_racketDiameter);
      println("Shoot with: " + result + " power");
      println("Dist: " + dist);
      println("Percentage: " + dist/m_racketDiameter);
      b.setVelZ(m_power);
      b.setCurrentMaxHeight(b.getMaxHeight());


      // TODO: Correct this
      // Change ball direction
      // Using dot product to shoot foward
      // Direction should be -1;
      float direction = b.getVel().normalize().dot(0,m_facingDirection,0);
      float angle = b.getVel().normalize().dot(m_vel)/(m_vel.mag()*b.getVel().mag());

      println("Direction: " + direction);
      println("Angle: " + angle);
      b.setVel(0,b.getVel().y * direction);

      // Reset our kickCount
      b.setKickCount(0);
      // Set the lastPlayer to hit the ball
      b.setLastHit(this);
    }

  }

  void update(){

    m_x += m_vel.x * getDeltaTime();
    m_y += m_vel.y * getDeltaTime();
    m_racketX = m_x - 15;
    m_racketY = m_y - 15;
    // This is our imaginary bounding box for player with rackets and head
    // Theses variables are offsets from our player X,Y top left corner rect
    float top = m_size.y/2 + m_size.x/2;
    float bottom = height - m_size.y;
    // BUG: Jittering motion because of left colliding with window X = 0
    float left = m_racketDiameter -  m_racketX  ;
    float right = width - m_size.x;

    if (m_x < left){
      setPos(left,m_y);
    }
    if (m_y < top){
      setPos(m_x,top);
    }
    if (m_x  > right){
      setPos(right,m_y);
    }
    if (m_y  > bottom){
      setPos(m_x,bottom);
    }
  }

  void draw(){
    stroke(255);
    fill(90,40,90);
    circle(m_x + m_size.x/2, m_y - m_size.y/2, m_size.x);
    fill(0,0,150);
    rect(m_x, m_y, m_size.x, m_size.y);
    fill(122,0,0);

    if(debug && m_facingDirection == -1){
      fill(255);
      stroke(255);
      text("Player Served: " + isServed(), 300,30);
      text("VelX: " + 100, 300,45);
      text("VelY: " + getVel().y, 300,60);
      text("Key: " + key, 300,75);
      noFill();
    }
    /* ellipse(m_racketX, m_racketY, m_racketDiameter.x, m_racketSize.y); */
    circle(m_racketX, m_racketY, m_racketDiameter);


  }

  void move(int x, int y){
    m_racketX += x * getDeltaTime();
    m_racketY += y * getDeltaTime();
    m_x += x * getDeltaTime();
    m_y += y * getDeltaTime();
  }

  boolean checkHit(Ball b){
    float radius = b.getBallDiameter()/2;
    if(CollisionCC(b.getBallPosition().x,b.getBallPosition().y, radius, m_racketX, m_racketY, m_racketDiameter/2)){
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
    return m_size.copy();
  }
  int getFacing(){
    return m_facingDirection;
  }
  void setPos(float x, float y){
    m_x = x;
    m_y = y;
    m_racketX = m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
  }
  void setVel(float vx, float vy){
    m_vel.x = vx;
    m_vel.y = vy;
  }
  void setVelX(float vx){
    m_vel.x = vx;
  }
  void setVelY(float vy){
    m_vel.y = vy;
  }
  PVector getVel(){
    return m_vel.copy();
  }
}
