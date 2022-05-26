

class Player {
  float   m_x;
  float   m_y;
  PVector m_size;

  PVector m_target;

  int     m_facingDirection;
  int     m_side;
  int     m_score;
  int     m_games;
  int     m_sets;

  float   m_racketX;
  float   m_racketY;
  float   m_racketXOffset;
  float   m_racketYOffset;
  float   m_racketHeight;
  float   m_racketDiameter;

  PVector m_maxVel;
  PVector m_currentVel;
  float   m_power;
  float   m_maxShootPower;


  HashMap<PLAYER_MOV_STATES,Boolean>  m_movements;
  HashMap<PLAYER_STATES, Boolean>     m_states;


  Player(){
    m_x = width/2;
    m_y = height/2;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    setSide(1);

    m_maxVel = new PVector(100,200);
    m_currentVel = new PVector(0,0);
    m_size = new PVector(20,30);
    m_target = new PVector(width/2, height/2);
    m_power = 70;
    m_maxShootPower = 200;
    m_sets = 0;
    m_score = 0;

    m_movements = new HashMap<PLAYER_MOV_STATES,Boolean>();
    m_states = new HashMap<PLAYER_STATES,Boolean>();
    initStates();

  }
  Player(float x, float y, int side){
    m_x = x;
    m_y = y;
    m_racketXOffset = 15;
    m_racketYOffset = 10;
    m_racketX =  m_x - m_racketXOffset;
    m_racketY = m_y - m_racketYOffset;
    m_racketHeight = 35;
    m_racketDiameter = 30;
    setSide(side);

    m_size = new PVector(20,30);
    m_maxVel = new PVector(250,200);
    m_currentVel = new PVector(0,0);
    m_target = new PVector(width/2, height/2 - 100);
    m_maxShootPower = 225;
    m_power = 70;
    m_score = 0;
    m_sets = 0;

    m_movements = new HashMap<PLAYER_MOV_STATES,Boolean>();;
    m_states = new HashMap<PLAYER_STATES,Boolean>();
    initStates();
  }

  void init(float x, float y, int side){
    setSide(side);
    m_score = 0;
    m_sets = 0;
    m_x = x;
    m_y = y;
    initStates();
  }
  void initStates(){
    m_movements.put(PLAYER_MOV_STATES.PLAYER_LEFT,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_UP,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_DOWN,false);
    m_movements.put(PLAYER_MOV_STATES.PLAYER_RIGHT,false);
    m_states.put(PLAYER_STATES.PLAYER_SERVING,true);
    m_states.put(PLAYER_STATES.PLAYER_RECIEVING,false);
    m_states.put(PLAYER_STATES.PLAYER_PLAYING,false);
    m_states.put(PLAYER_STATES.PLAYER_WINNING,false);
    m_states.put(PLAYER_STATES.PLAYER_LOSING,false);
  }

  void hit(Ball b, Court c){
    if(checkHit(b)){

      // NEW HIT
      PVector direction = PVector.sub(m_target,new PVector(m_racketX,m_racketY)).normalize();

      // Getting ball get ball position
      // We're going to get the distance of the center of the ball
      // to the center of racket, the closer it gets, more power we will
      // push the ball up
      PVector bpos = b.getBallPosition();
      /* float angleFactor = tan(radians(c.getAngle())); */
      /* float distToCenterCourt = m_x - width/2; */

      float distToRacketCenter = dist(bpos.x,bpos.y,m_racketX,m_racketY);
      float percentage = distToRacketCenter*0.5/m_racketDiameter;
      float result = m_power * (1.1 - percentage);
      float forceY = m_maxShootPower * (1 - percentage);

      direction.mult(forceY);
      // -1 shoot towards out
      //  1 shoot towards in
      // So if we are in side 1. -1 will shoot with negative angulation
      // So if we are in side 2. -1 will shoot with positive angulation
      // Because we are multiplying with m_facingDireciton
      /* float perspectiveXOffset = forceY * angleFactor; */
      /* int dirX = (distToCenterCourt < 0 ? -1 : 1 ); */

      /* distToCenterCourt += perspectiveXOffset * m_facingDirection * dirX ; */
      /* distToCenterCourt *= -1; */

      // Multiplying with m_facingDirection of the player
      // will ensure that dispite of the side we're going to shoot
      // we gonna shoot in the perspective direction of the Court
      /* dirX = dirX * m_facingDirection; */


      // DEPRECATED
      // This will make we turn ball to the front direction of player
      /* float shootDir = PVector.dot(b.getVel().normalize(), new PVector(0,m_facingDirection,0)); */

      /* float x = perspectiveXOffset * dirX; // This value are compensating the perspective */
      /* float y = forceY * m_facingDirection; */
      // If we are in serve state but did not hit the ball yet we should go her
      if(b.isServed()){
        b.setVel(direction.x,direction.y);
        /* b.setVel(x,y); */
        b.setVelZ(result);
        b.m_state = BALL_STATES.BALL_PLAYING;
        m_states.put(PLAYER_STATES.PLAYER_PLAYING,true);
        return;
      }

      // When the serve end and they are playing
      b.setCurrentMaxHeight(b.getMaxHeight());
      b.setVelZ(result);
      b.setVel(direction.x,direction.y);
      b.setKickCount(0);
      b.setLastHit(this);
    }

  }

  void update(){
    boolean condition = (!m_states.get(PLAYER_STATES.PLAYER_SERVING) || m_states.get(PLAYER_STATES.PLAYER_PLAYING));
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_LEFT)){
      m_currentVel.x = -m_maxVel.x;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_RIGHT)){
      m_currentVel.x = m_maxVel.x;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_UP) && condition){
      m_currentVel.y = -m_maxVel.y;
    }
    if (m_movements.get(PLAYER_MOV_STATES.PLAYER_DOWN) && condition){
      m_currentVel.y = m_maxVel.y;
    }

    m_x += m_currentVel.x * getDeltaTime();
    m_y += m_currentVel.y * getDeltaTime();
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
    pushStyle();
    stroke(0,0,255);
    strokeWeight(4);
    line(m_x - m_racketXOffset/2, m_y - m_racketYOffset/6, m_x, m_y + 12);
    popStyle();
    noFill();
    circle(m_x - m_racketXOffset, m_y - m_racketYOffset, m_racketDiameter);
    circle(m_target.x,m_target.y, 5);

  }

  void drawDebug(int atX, int atY){
    text("Side: " + m_side , atX, atY + 15);
    text("Points: " + m_score , atX, atY + 30);
    text("Games: " + m_games , atX, atY + 45);
    text("Sets: " + m_sets , atX, atY + 60);
    text("Serving: " + m_states.get(PLAYER_STATES.PLAYER_SERVING) , atX, atY + 75);
    text("Recieving: " + m_states.get(PLAYER_STATES.PLAYER_RECIEVING) , atX, atY + 90);
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
  int getSide(){
    return m_side;
  }
  boolean getState(PLAYER_STATES state){
    return m_states.get(state);
  }
  int getFacing(){
    return m_facingDirection;
  }
  PVector getCurrentVel(){
    return m_currentVel.copy();
  }
  PVector getMaxVel(){
    return m_maxVel.copy();
  }
  int getScore(){
    return m_score;
  }
  void setSide(int i){
    if(i==1){
      m_side=i;
      setFacing(1);
    }
    else {
      m_side=2;
      setFacing(-1);
    }
  }
  void setFacing(int i){
    if(i == 1 || i==-1) m_facingDirection=i;
  }
  void setPos(float x, float y){
    m_x = x;
    m_y = y;
  }
  void setVel(float vx, float vy){
    m_currentVel.x = vx;
    m_currentVel.y = vy;
  }
  void setVelX(float vx){
    m_currentVel.x = vx;
  }
  void setVelY(float vy){
    m_currentVel.y = vy;
  }
  void setScore(int score){
    m_score = score;
  }
  void setTarget(float x, float y){
    if(x > 0 && x < width){
      m_target.x = x;
    }
    else{
      m_target.x = width/2;
    }
    if(y > 0 && y < height){
      m_target.y = y;
    }
    else{
      m_target.y = height/2;
    }
  }
  void setServeStatus(){
    m_states.put(PLAYER_STATES.PLAYER_SERVING,true);
    m_states.put(PLAYER_STATES.PLAYER_RECIEVING,false);
    m_states.put(PLAYER_STATES.PLAYER_PLAYING,false);
  }
  void setRecieverStatus(){
    m_states.put(PLAYER_STATES.PLAYER_SERVING,false);
    m_states.put(PLAYER_STATES.PLAYER_RECIEVING,true);
    m_states.put(PLAYER_STATES.PLAYER_PLAYING,false);
  }
  void addScore(int amount){
    m_score += amount;
  }
  void addSet(){
    m_sets++;
  }
  void addGame(){
    m_games++;
    if(m_games == 7){
      addSet();
    }
  }
}
