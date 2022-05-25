

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
  float m_maxShootPower;


  HashMap<PLAYER_MOV_STATES,Boolean> m_movements;
  PLAYER_STATES m_states;

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
    m_facingDirection = -1;
    m_vel = new PVector(0,0);
    m_size = new PVector(20,30);
    m_maxShootPower = 200;
    m_score = 0;
    m_states = PLAYER_STATES.PLAYER_SERVING;
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
    m_racketHeight = 35;
    m_racketDiameter = 30;
    m_facingDirection = facing;
    m_size = new PVector(20,30);

    m_vel = new PVector(0,0);
    m_maxShootPower = 200;
    m_score = 0;

    m_movements = new HashMap<PLAYER_MOV_STATES,Boolean>();;
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);
    m_states = PLAYER_STATES.PLAYER_SERVING;
  }

  void init(float x, float y, int facing){
    m_facingDirection = facing;
    m_x = x;
    m_y = y;
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);
    m_states = PLAYER_STATES.PLAYER_SERVING;
  }

  void hit(Ball b){
    if(checkHit(b)){

        float perspectiveDir = (m_x - width/2 < 0 ? -1 : 1 );
        float shootDir = PVector.dot(b.getVel().normalize(), new PVector(0,m_facingDirection,0));

        // Getting ball get ball position
        // We're going to get the distance of the center of the ball
        // to the center of racket, the closer it gets, more power we will
        // push the ball up
        PVector bpos = b.getBallPosition();
        float dist = dist(bpos.x,bpos.y,m_racketX,m_racketY);
        float result = m_power * (1.1 - dist/m_racketDiameter);

        // Multiplying with m_facingDirection of the player
        // will ensure that dispite of the side we're going to shoot
        // in the perspective direction of the Court
        perspectiveDir = perspectiveDir * m_facingDirection;

      // If we are in serve state but did not hit the ball yet we should go here
      // WARN: MAGIC NUMBERS: DIDN'T GET COURT ANGULATION AND SPEED OF BALL;
      if(b.isServed()){
        b.setVel(m_maxShootPower * tan(radians(20)) * perspectiveDir,m_maxShootPower * m_facingDirection);
        b.setVelZ(m_power);
        b.m_states = STATES.GAME_PLAYING;
        m_states = PLAYER_STATES.PLAYER_PLAYING;
        return;
      }


      b.setVelZ(m_power);
      b.setVel(m_maxShootPower * tan(radians(20)) * perspectiveDir  ,b.getVel().y * shootDir);
      b.setCurrentMaxHeight(b.getMaxHeight());
      b.setKickCount(0);
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
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_UP) && m_states != PLAYER_STATES.PLAYER_SERVING){
      m_vel.y = -300;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_DOWN) && m_states != PLAYER_STATES.PLAYER_SERVING){
      m_vel.y = 300;
    }

    m_x += m_vel.x * getDeltaTime();
    m_y += m_vel.y * getDeltaTime();
    m_racketX = m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    checkWindowCollision();

  }

  void draw(){
    stroke(255);
    fill(90,40,90);
    circle(m_x + m_size.x/2, m_y - m_size.y/2, m_size.x);

    fill(0,0,150);
    rect(m_x, m_y, m_size.x, m_size.y);

    fill(122,0,0);
    circle(m_x - m_racketXOffset, m_y - m_racketYOffset, m_racketDiameter);
  }

  void checkWindowCollision(){

    // This is our imaginary bounding box for player with rackets and head
    // Theses variables are offsets from our player X,Y top left corner rect
    float top = m_size.y/2 + m_size.x/2; // m_size.x is the head diameter and m_size.y/2 is the offset from topleft rect
    float bottom = height - m_size.y ;
    float left = m_racketDiameter;
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

  void checkNetCollision(Net n){
    if (m_facingDirection == 1){
      if(m_y > n.getPosY() - m_size.y ){
        setPos(m_x, n.getPosY() - m_size.y);
      }
    }
    else {
      if(m_y < n.getPosY() - m_size.y/2 ){
        setPos(m_x, n.getPosY() - m_size.y/2);
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
  // GETTERST AND SETTERS ====================================================
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
  PVector getVel(){
    return m_vel.copy();
  }
  int getScore(){
    return m_score;
  }
  void setPos(float x, float y){
    m_x = x;
    m_y = y;
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
  void setScore(int score){
    m_score = score;
  }
  void setServeStatus(){
    m_states = PLAYER_STATES.PLAYER_SERVING;
  }
  void setRecieveStatus(){
    m_states = PLAYER_STATES.PLAYER_RECIEVING;
  }
  void addScore(int amount){
    m_score += amount;
  }
}
