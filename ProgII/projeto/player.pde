

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

  HashMap<PLAYER_MOV_STATES,Boolean> m_movements;

  int m_score;

  Player(){
    m_x = width/2;
    m_y = height/2;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_power = 2;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    m_vel = new PVector(0,0);
    m_facingDirection = -1;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
    m_score = 0;
    m_movements = new HashMap<PLAYER_MOV_STATES,Boolean>();
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);

  }
  Player(float x, float y, int facing){
    m_x = x;
    m_y = y;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_power = 2;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    m_facingDirection = facing;
    m_served = false;
    m_shouldServe = false;
    m_size = new PVector(20,30);
    m_vel = new PVector(0,0);
    m_score = 0;
    m_movements = new HashMap<PLAYER_MOV_STATES,Boolean>();;
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);
  }

  void init(float x, float y, int facing){
    m_facingDirection = facing;
    m_x = x;
    m_y = y;
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);
  }

  void hit(Ball b){
    if(checkHit(b)){

        float perspectiveDir = (m_x - width/2 < 0 ? -1 : 1 );
        perspectiveDir = perspectiveDir * m_facingDirection;
      // If we are in serve state but did not hit the ball yet we should go here
      // WARN: MAGIC NUMBERS: DIDN'T GET COURT ANGULATION AND SPEED OF BALL;
      if(b.isServed()){
        b.setVel(200 * tan(radians(20) * perspectiveDir),200 * m_facingDirection);
        b.setVelZ(m_power);
        b.m_states = STATES.GAME_PLAYING;
        return;
      }

      // Already Served the ball and hitted.
      // TODO: Make an formula when hit the ball
      PVector bpos = b.getBallPosition();
      float dist = dist(bpos.x,bpos.y,m_racketX,m_racketY);
      float result = m_power * (1.1 - dist/m_racketDiameter);
      b.setVelZ(m_power);
      b.setCurrentMaxHeight(b.getMaxHeight());


      // Change ball direction
      // Using dot product to shoot foward
      PVector ballNormalizedVel = b.getVel().normalize();
      PVector selfNormalizedVel = m_vel.normalize();
      float direction = ballNormalizedVel.dot(0,m_facingDirection,0);
      float angle = degrees(PVector.angleBetween(ballNormalizedVel,selfNormalizedVel));

      println("Direction: " + direction);
      println("Angle: " + angle);
      b.setVel(b.getVel().y * tan(radians(20) * perspectiveDir ) ,b.getVel().y * direction);

      // Reset our kickCount
      b.setKickCount(0);
      // Set the lastPlayer to hit the ball
      b.setLastHit(this);
    }

  }

  void update(){
    // WARN: MAGIC SPEED NUMBERS
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_LEFT)){
      m_vel.x = -300;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_RIGHT)){
      m_vel.x = 300;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_UP)){
      m_vel.y = -300;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_DOWN)){
      m_vel.y = 300;
    }

    m_x += m_vel.x * getDeltaTime();
    m_y += m_vel.y * getDeltaTime();
    m_racketX = m_x - 15;
    m_racketY = m_y - 15;
    checkWindowCollision();
    checkNetCollision();

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
      text("VelX: " + getVel().x, 300,45);
      text("VelY: " + getVel().y, 300,60);
      text("Key: " + key, 300,75);
      text("MOV_STATE: " + m_movements.get(PLAYER_MOV_STATES.PLAYER_LEFT), 300,90);
      noFill();
    }
    circle(m_racketX, m_racketY, m_racketDiameter);
  }

  void move(int x, int y){
    m_racketX += x * getDeltaTime();
    m_racketY += y * getDeltaTime();
    m_x += x * getDeltaTime();
    m_y += y * getDeltaTime();
  }
  void checkWindowCollision(){

    // This is our imaginary bounding box for player with rackets and head
    // Theses variables are offsets from our player X,Y top left corner rect
    float top = m_size.y/2 + m_size.x/2;
    float bottom = height - m_size.y;
    // BUG: Jittering motion because of left colliding with window X = 0
    float left = m_racketDiameter/2 -  m_racketX  ;
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
  // WARN: DIDN'T GET NET Y, PUTTING MAGIC NUMBERS CAREFULL
  void checkNetCollision(){
    if (m_facingDirection == 1){
      if(m_y > 400 - m_size.y ){
        setPos(m_x, 400 - m_size.y);
      }
    }
    else {
      if(m_y < 400 - m_size.y/2 ){
        setPos(m_x, 400 - m_size.y/2);
      }
    }
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
  float getRacketX(){
    return m_racketX;
  }
  float getRacketY(){
    return m_racketY;
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
