//Game State
boolean debug = false;

// Constants
final float GRAVITY = 9.8; // m²/s;
final float INTERVALO = 1.0/60;

// Clock
float tAtual = 0.0;
float start = 0.0;

Weapon tank;
Material metal;
Block floor;
Trajectory tj;
ParticleSystem ps;
ShakeEffect screenEffect;

void setup(){
  size(1000,1000);

  tank = new Weapon(50,width/2);
  metal = new Material();
  floor = new Block();
  tj = new Trajectory();
  ps = new ParticleSystem(10, tank.m_x + 20, tank.m_y);
  screenEffect = new ShakeEffect(5,5,0.2);

  floor.getPosition().y = width/2 + 40;
  floor.getSize().x = width;

  // Creating the future trajectory points for bullets
  tj.addPoint(tank.m_bullets[tank.m_bullet].m_cx, tank.m_bullets[tank.m_bullet].m_cy, calculateFX(tank.m_angle,tank.m_power), calculateFY(tank.m_angle,tank.m_power), tank.m_bullets[tank.m_bullet].m_mass);
}


void draw(){
  background(0);



  // Update Functions
  floor.update();
  ps.update();
  tank.update();
  screenEffect.update();

  for (int i = 0; i < tank.m_bullets.length; i++){
    Projectile bullet = tank.m_bullets[i];
    if(i < tank.m_bullet + 1){

      bullet.update();

      if(collide(floor,bullet)){
        bullet.m_cy = floor.getPosition().y - bullet.m_height/2;
        bullet.m_vy = -bullet.m_vy;
        bullet.m_vy *= bullet.m_material.m_coefficient;
        bullet.m_vx *= bullet.m_material.m_coefficient;

        // This should stop horizontal velocity when its to small number
        if (bullet.m_vx > -0.00000009 && bullet.m_vx < 0.000000009){
          bullet.m_vx = 0;
        }

      }
    }
  }
  // Draw Functions

  screenEffect.draw();

  // Reference
  showGrid(50,50);

  tank.draw();
  floor.draw();
    // If have ammo then draw trajectory;
  if(tank.m_loaded){
    tj.draw();
  }

  ps.draw();
  // GUI
  if(debug){
    drawGUI();
  }

  // Sum 1/FPS to tAtual
  tAtual = tAtual + INTERVALO;
}

float calculateFX(float angle, float power){
  return  cos(radians(angle)) * power;
}
float calculateFY(float angle, float power){
  return sin(radians(angle)) * power;
}

void drawGUI(){
  pushStyle();
  fill(122,122,122);
  rect(0,0,width, 100 );
  int textSize = 16;
  textSize(textSize);
  fill(255,255,255);
  text("Tempo atual: " + nfs(tAtual,1,2), 12, textSize * 1);
  text("Start: " + start, 144, textSize * 1);

  fill(0,255,0);
  text("Tank Debug",12,textSize * 2);
  text("Angle: " + (-tank.m_angle), 12, textSize * 3);
  text("Power: " + tank.m_power + " N", 12,textSize * 4);
  text("Ammo: " + (tank.m_bullets.length - tank.m_bullet) + "/" + tank.m_bullets.length, 12,textSize * 5);
  text("Loaded: " + (tank.m_loaded) , 12,textSize * 6);

  fill(255,255,0);
  text("Bullet Debug",144,textSize * 2);
  if(tank.m_bullet > 0){
    text("Bullet ID: " + (tank.m_bullet - 1), 144,textSize * 3);
    text("Vy: " + tank.m_bullets[tank.m_bullet - 1].m_vy + " m/s", 144,textSize * 4);
    text("Vx: " + tank.m_bullets[tank.m_bullet - 1].m_vx + " m/s", 144,textSize * 5);
    text("Mass: " + tank.m_bullets[tank.m_bullet - 1].m_mass + " kg", 144,textSize * 6);
  }
  else{
    text("Bullet ID: " + tank.m_bullet , 144,textSize * 3);
    text("Vy: " + tank.m_bullets[tank.m_bullet].m_vy + " m/s", 144,textSize * 4);
    text("Vx: " + tank.m_bullets[tank.m_bullet].m_vx + " m/s", 144,textSize * 5);
    text("Mass: " + tank.m_bullets[tank.m_bullet].m_mass + " kg", 144,textSize * 6);

  }

  fill(255,0,255);
  text("Floor Debug",288,textSize * 2);
  text("Static: " + floor.getStatic(), 288,textSize * 3);
  text("Floor y: " + floor.getPosition().y , 288,textSize * 4);

  fill(0,255,255);
  text("Trajectory Debug",422,textSize * 2);
  text("VX0: " + calculateFX(tank.m_angle,tank.m_power), 422,textSize * 3);
  text("VY0: " + calculateFY(tank.m_angle, tank.m_power), 422,textSize * 4);

  fill(255,100,40);
  text("Screen Effec Debug",544,textSize * 2);
  text("Activated: " + screenEffect.m_activated, 544,textSize * 3);
  text("Time: " + screenEffect.m_currentTime + "/" + screenEffect.m_delayTime, 544,textSize * 4);
  popStyle();
}
void showGrid(int refX, int refY){
  noFill();
  stroke(255);
  for (int x = 0;x < width/refX; x++){
    for (int y = 0;y < width/refY; y++){
      rect(x * refX, y * refY, refX, refY);
    }
  }
}

void keyPressed(){
  if (key == 'd'){
    tank.increasePower(10);
    tj.addPoint(tank.m_bullets[tank.m_bullet].m_cx, tank.m_bullets[tank.m_bullet].m_cy, calculateFX(tank.m_angle,tank.m_power), calculateFY(tank.m_angle,tank.m_power), tank.m_bullets[tank.m_bullet].m_mass);
  }
  if (key == 'a'){
    tank.decreasePower(10);
    tj.addPoint(tank.m_bullets[tank.m_bullet].m_cx, tank.m_bullets[tank.m_bullet].m_cy, calculateFX(tank.m_angle,tank.m_power), calculateFY(tank.m_angle,tank.m_power), tank.m_bullets[tank.m_bullet].m_mass);
  }
  if (key == 'w'){
    tank.addAngle();
    tj.addPoint(tank.m_bullets[tank.m_bullet].m_cx, tank.m_bullets[tank.m_bullet].m_cy, calculateFX(tank.m_angle,tank.m_power), calculateFY(tank.m_angle,tank.m_power), tank.m_bullets[tank.m_bullet].m_mass);
  }
  if (key == 's'){
    tank.subAngle();
    tj.addPoint(tank.m_bullets[tank.m_bullet].m_cx, tank.m_bullets[tank.m_bullet].m_cy, calculateFX(tank.m_angle,tank.m_power), calculateFY(tank.m_angle,tank.m_power), tank.m_bullets[tank.m_bullet].m_mass);
  }
  if (key == 'r'){
    tank.reload();
  }
  if (key == 'q'){
    debug = !debug;
  }
  if (key == 'e'){
    floor.setStatic(!floor.getStatic());
  }
  if (key == ' '){
    if(tank.m_loaded && tank.m_canShoot){
      ps.restart(tank.m_x + 20, tank.m_y);
      screenEffect.m_activated = true;
    }
    tank.shoot();
  }
}


class Projectile{
  Projectile(){

    m_cx = 0;
    m_cy = 0;
    m_vx = 0;
    m_vy = 0;
    m_width = 15;
    m_height = 15;
    m_mass = 10;
    m_fired = false;

  }

  void draw(){
    if(m_fired){
      fill(255);
      noStroke();
      ellipse(m_cx,m_cy,m_width,m_height);
    }
  }
  void update(){
    if(m_fired){
      m_vy += GRAVITY * INTERVALO * m_mass;
      m_cx += m_vx * INTERVALO;
      m_cy += m_vy * INTERVALO;
    }
  }

  void addForce(float power, float angle){
    m_vx = calculateFX(angle,power);
    m_vy = calculateFY(angle,power);
  }

  float m_cx; // Mass Center X
  float m_cy; // Mass Center Y
  float m_vx; // Horizontal vel
  float m_vy; // Vertical vel
  float m_width;          // Pixels
  float m_height;         // Pixels
  float m_mass;          // this should be in KG
  boolean m_fired;        // Used to detect if the tank already fired this bullet
  Material m_material;    // Material for ground friction properties

}

class Material{
  Material(){
    m_coefficient = 0.75;
  }
  float m_coefficient;
}

class Weapon{

  Weapon(float x, float y){

    m_canShoot = true;
    m_x = x;
    m_y = y;
    m_power = 0;
    m_angle = -45.0;
    m_angleRate = -1.0;
    m_bullet = 0;
    m_delayTime = 0.8;
    m_currentTime = 0;
    m_bullets = new Projectile[20];
    m_size = new PVector(40,40);

    for (int i = 0 ; i < m_bullets.length; i++){
      m_bullets[i] = new Projectile();
      m_bullets[i].m_cx = this.m_x + 20;
      m_bullets[i].m_cy = this.m_y;
      m_bullets[i].m_material = new Material();
    }

    m_loaded = true;
  }

  void draw(){

    pushStyle();

    noFill();
    stroke(0,233,233);
    ellipse(m_x + m_size.x/2,m_y,m_size.x/2,m_size.y/2);

    fill(120,0,0);
    noStroke();
    rect(m_x, m_y, m_size.x, m_size.y);

    stroke(0,255,0);
    line(m_x + 20,m_y, m_x + 20 + cos(radians(m_angle)) * 50, m_y + sin(radians(m_angle)) * 50);

    for (int i = 0 ; i < m_bullets.length; i++){
      m_bullets[i].draw();
    }

    popStyle();

  }

  void update(){
    if(!m_canShoot){
      m_currentTime += INTERVALO;
      if(m_currentTime >= m_delayTime){
        m_canShoot = true;
        m_currentTime -= m_delayTime;
      }
    }
  }
  void addAngle(){
    m_angle += m_angleRate;
    if(m_angle >= 360){
      m_angle = 0;
    }
  }
  void subAngle(){
    m_angle -= m_angleRate;
    if(m_angle <= -360){
      m_angle = 0;
    }
  }
  void setAngle(float angle){
    if(angle < 360 || angle > -360){
      m_angle = angle;
    }
    else{
      m_angle = 0;
    }
  }
  void increasePower(float power){
    m_power += power;
  }
  void decreasePower(float power){
    m_power -= power;
    if(m_power <= 0){
      m_power = 0;
    }
  }
  void setTurnAngleRate(float rate){
    m_angleRate = rate;
  }

  void shoot(){
    if(m_loaded && m_canShoot){
      m_bullets[m_bullet].addForce(m_power,m_angle);
      m_bullets[m_bullet].m_fired = true;
      m_bullet++;
      m_canShoot = false;
    }
    if(m_bullet >= m_bullets.length){
      m_loaded = false;
      m_bullet--;
    }
  }

  void reload(){
    for (int i = 0 ; i < m_bullets.length; i++){
      m_bullets[i].m_cx = this.m_x + 20;
      m_bullets[i].m_cy = this.m_y;
      m_bullets[i].m_vx = 0;
      m_bullets[i].m_vy = 0;
      m_bullets[i].m_fired = false;
    }
    m_loaded = true;
    m_canShoot = true;
    m_bullet = 0;
  }

  int getProjectil(){ return m_bullet; }

  float m_x;
  float m_y;
  float m_power;
  float m_angle;
  float m_angleRate;
  PVector m_size;
  float m_delayTime;
  private float m_currentTime;
  private int m_bullet;
  private boolean m_loaded;
  private boolean m_canShoot;
  private Projectile[] m_bullets;

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
    pushStyle();
    fill(m_color);
    rect(m_pos.x, m_pos.y, m_size.x, m_size.y);
    popStyle();
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


boolean collide(Block f, Projectile p){
  if (p.m_cx + p.m_width/2 < f.getPosition().x || p.m_cx - p.m_width/2 > f.getPosition().x + f.getSize().x){
    return false;
  }
  else if (p.m_cy + p.m_height/2 < f.getPosition().y || p.m_cy - p.m_height/2 > f.getPosition().y + f.getSize().y){
    return false;
  }
  else{
    return true;
  }

}


class Trajectory{
  Trajectory(){
    m_points = new PVector[8];
    m_size = 15;
    for (int i = 0; i < m_points.length; i++){
      m_points[i] = new PVector();
    }
  }

  void draw(){
    pushStyle();
    for (int i = 1; i < m_points.length; i++){
      noFill();
      stroke(233,233,50);
      circle(m_points[i].x ,m_points[i].y , m_size);
    }
    popStyle();
  }

  void addPoint(float x, float y, float vx, float vy, float mass){
    for (int i = 0; i < m_points.length; i++){
      float interval = i/2.0;
      m_points[i].x = x + vx * interval;
      // We multiplied Gravity with mass because we are addeding Gravity * mass in bullet.m_vy
      m_points[i].y = y + vy * interval + GRAVITY * mass * interval * interval/2;
    }

  }

  private PVector[] m_points;
  int m_size;

}


class Particle{
  Particle(float x, float y){
    m_pos = new PVector(x, y);
    m_vel = new PVector(random(-5,5),random(-5,5));
    m_acc = new PVector(random(-5,5),random(-5,5));
    m_size = new PVector(random(0,10),random(0,10));
    m_lifeSpan = random(0,2);
    m_currentTime = 0;
  }

  void draw(){
    if(!isDead()){
      pushStyle();
      fill(122, (1-m_currentTime/m_lifeSpan) * 255);
      stroke(122, (1-m_currentTime/m_lifeSpan) * 255);
      circle(m_pos.x,m_pos.y, m_size.x);
      popStyle();
    }
  }

  void update(){
    if(!isDead()){
      m_currentTime += INTERVALO;
      /* m_vel.add(m_acc.mult(INTERVALO * INTERVALO)); */
      /* m_pos.add(m_vel.mult(INTERVALO)); */
      m_vel.add(m_acc.mult(INTERVALO * INTERVALO));
      m_pos.add(m_vel);
    }
  }

  boolean isDead(){
    if (m_lifeSpan <= m_currentTime){
      return true;
    }
    else{
      return false;
    }
  }
  void restart(float x, float y){
    m_pos = new PVector(x, y);
    m_vel = new PVector(random(-5,5),random(-5,5));
    m_acc = new PVector(random(-5,5),random(-5,5));
    m_size = new PVector(random(0,10),random(0,10));
    m_lifeSpan = random(0,2);
    m_currentTime = 0;
  }

  PVector m_pos;
  PVector m_vel;
  PVector m_acc;
  PVector m_size;
  float m_lifeSpan;
  float m_currentTime;
}


class ParticleSystem{
  ParticleSystem(int quantity, float x, float y){
    m_particles = new ArrayList<Particle>();
    for (int i = 0; i < quantity; i++){
      m_particles.add(new Particle(x, y));
    }
    m_alive = false;
  }

  void update(){
    for (int i = 0; i < m_particles.size(); i++){
      if (m_alive) m_particles.get(i).update();
    }
  }

  void draw(){
    for (int i = 0; i < m_particles.size(); i++){
      if (m_alive) m_particles.get(i).draw();
    }
  }
  void restart(float x, float y){
    for (int i = 0; i < m_particles.size(); i++){
      m_particles.get(i).restart(x, y);
    }
    m_alive = true;
  }

  ArrayList<Particle> m_particles;
  boolean m_alive;
}


class Wind{
  Wind(){
    m_direction = new PVector(round(random(-1,1)), round(random(-1,1)));
    m_vel = int(random(0,10));
  }

  void update(){

  }

  void draw(){

  }
  PVector m_direction;
  int m_vel;
}

class ScreenEffect{
  ScreenEffect(){
    m_activated = false;
    m_currentTime = 0.0;
    m_delayTime = 1.0;
  }

  void update(){
    if(m_activated){
      m_currentTime += INTERVALO;
      if (m_currentTime >= m_delayTime){
        m_activated = false;
        m_currentTime = 0.0;
      }
    }
  }

  void draw(){

  }
  boolean m_activated;
  float m_currentTime;
  float m_delayTime;
}

class ShakeEffect extends ScreenEffect{

  ShakeEffect(int x, int y, float duration){
    super();
    m_shakingFactor = new PVector(x,y);
    m_delayTime = duration;
  }
  void update(){
    if(m_activated){
      m_currentTime += INTERVALO;
      if (m_currentTime >= m_delayTime){
        m_activated = false;
        m_currentTime = 0.0;
      }
    }
  }
  void draw(){
    if(m_activated){
      translate(random(-m_shakingFactor.x,m_shakingFactor.x), random(-m_shakingFactor.y,m_shakingFactor.y));
    }
  }

  PVector m_shakingFactor;
}
