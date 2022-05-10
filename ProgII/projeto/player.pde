

class Player{
  float m_x;
  float m_y;
  int m_facingDirection;

  float m_racketX;
  float m_racketY;
  float m_racketHeight;
  PVector m_racketSize;

  PVector m_vel;
  float m_power;

  Player(){
    m_x = width/2;
    m_y = height/2;
    m_racketHeight = 35;
    m_racketSize = new PVector(15,25);
    m_facingDirection = -1;
  }

  void hit(Ball b){
    if(checkHit(b)){
      b.hit(this);
    }

  }

  void update(){

  }

  void draw(){
    fill(90,40,90);
    circle(m_x + 10, m_y - 15, 20);
    fill(0,0,150);
    rect(m_x, m_y, 20, 30);
    fill(122,0,0);
    pushMatrix();
    translate(m_x - 15,m_y - 10);
    rotate(-PI/6);
    ellipse(0, 0, m_racketSize.x, m_racketSize.y);
    popMatrix();
  }

  void move(int x, int y){
    m_x += x;
    m_y += y;
  }
  boolean checkHit(Ball p){
    return true;
  }
}
