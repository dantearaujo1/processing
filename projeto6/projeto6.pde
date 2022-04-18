float x = 0;
float vx = 0;
float distanciaPercorrida = 0;

//Game State
boolean fired = false;
boolean get = false;


// Clock
final float INTERVALO = 1.0/60;
final float GRAVITY = 9.8;
float tAtual = 0.0;
float duracao = 0.0;

Block floor;


void setup(){
  size(1000,1000);

  floor = new Block();
  vx = 50.0f;

  floor.getPosition().y = width/2 + 40;
  floor.getSize().x = width;
  floor.getSize().y = 10;

  fired = false;

}


void draw(){
  background(0);

  // GUI
  drawGUI();

  // Reference
  showGrid(50,50);
  fill(0,0,122);
  rect(width/2,height/2, 60,45);
  fill(122,122,122);
  rect(width/2,height/2 , 60,15);
  if (!get){
    fill(0,255,0);
    circle(width/2 + 15,height/2 + 30 , 15);
    fill(255,0,0);
    line (x - 7, height/2 - 2, x + 15, height/2 - 2);
    triangle(x + 15, height/2 - 4, x + 15, height/2, x + 19, height/2 -2);
    pushStyle();
    textSize(12);
    text("vx: " + vx + " m/s", x + 25, height/2 - 2);
    popStyle();
    circle(x,height/2 + 30, 15);
  }
  else{
    fill(0,255,0);
    circle(x,height/2 + 30, 15);
    line (x - 7, height/2 - 2, x + 15, height/2 - 2);
    triangle(x -7, height/2 - 4, x -7, height/2, x -11, height/2 -2);
    pushStyle();
    textSize(12);
    text("vx: " + vx + " m/s", x + 25, height/2 - 2);
    popStyle();
  }
  fill(255,0,0);
  pushStyle();
  textSize(16);
  text("PADARIA", width/2, height/2);
  popStyle();


  if(fired){
    x += vx * INTERVALO;
    duracao += INTERVALO;
    distanciaPercorrida += abs(vx* INTERVALO);
  }
  if (x > width/2 + 15){
    vx = -vx;
    get = true;
  }
  if (x < 0 ){
    fired = false;
    vx = 0;
  }
  floor.draw();

  tAtual = tAtual + INTERVALO;
}

void drawGUI(){
  fill(0,255,0);
  textSize(16);
  text("Tempo atual: " + tAtual + " seg", 15,16);
  text("Duração: " + duracao + " seg", 15,32);
  text("Posição: " + x + " m", 15,48);
  text("Distância Percorrida: " + distanciaPercorrida + " m", 15,64);
  text("Velocidade: " + vx + " m/s", 15,80);
}

void showGrid(int refX, int refY){
  noFill();
  stroke(255);
  for (int x = 0;x < width/refX; x++){
    for (int y = 0;y < width/refY; y++){
      fill(0);
      if (refY * y > height/2 && refY * y < height/2 +  2 * refY){
        rect(x * refX, y * refY, refX, refY);
        fill(255,0,0);
        textSize(18);
        text(refX * x + "m", x * refX, (y+1) * refY);
      }
    }
  }
}

void keyPressed(){
  if (key == 'd'){
  }
  if (key == 'a'){
  }
  if (key == 'w'){
  }
  if (key == 's'){
  }
  if (key == 'r'){
    setup();
  }
  if (key == 'e'){
    floor.setStatic(!floor.getStatic());
  }
  if (key == ' '){
    fired = true;
  }
}





class Block{
  Block(){
    m_pos = new PVector(0,0);
    m_size = new PVector(20,20);
    m_vel = new PVector(0,0);
    m_static = true;
    m_color = color(122,122,122);
  }

  PVector getPosition() { return m_pos; }
  PVector getSize() { return m_size; }
  PVector getVel() { return m_vel; }
  boolean getStatic() { return m_static; }

  void setStatic(boolean value){ m_static = value; }
  void setPosition(float x, float y) { m_pos.x = x; m_pos.y = y; }
  void setVelocity(float vx, float vy) { m_vel.x = vx; m_vel.y = vy; }
  void setSize(int w, int h) { m_size.x = w; m_size.y = h; }

  void draw(){
    fill(m_color);
    rect(m_pos.x, m_pos.y, m_size.x, m_size.y);
  }

  void update(){
    if(m_static){

    }
    else{
      m_vel.y += GRAVITY * INTERVALO;
      m_pos.y += m_vel.y;
    }
  }

  private PVector m_pos;
  private PVector m_size;
  private PVector m_vel;
  private boolean m_static;
  private color m_color;
}


