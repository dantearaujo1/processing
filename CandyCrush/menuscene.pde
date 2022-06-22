class MenuScene implements IScene{
  SceneManager m_director;

  PImage m_background;
  PVector m_backgroundPosition;
  PFont m_menuFont;
  PVector m_titlePosition;

  boolean m_titleAnimation;
  float m_titleAnimationDuration;
  float m_titleAnimationCurrentDuration;

  ControlP5 m_controlGUI;


  MenuScene(SceneManager director,PApplet app){
    if(director != null){
      m_director = director;
    }
    if (app != null){
      m_controlGUI = new ControlP5(app);
    }
  }
  void onInit(){
    m_backgroundPosition = new PVector();
    m_titlePosition = new PVector();
    m_titleAnimation = true;
    m_titleAnimationDuration = 2.0;
    m_titleAnimationCurrentDuration = 0.0;
    m_controlGUI.addButton("Start").plugTo(this).setColorBackground(color(0,0,0,150)).setColorForeground(color(122,122,0)).setColorActive(color(255,0,0,100));
    loadImages();
    loadFonts();
  }

  void onExit(){
    m_controlGUI.getController("Start").hide();
  }
  void onResume(){

  }

  void onPause(){

  }

  void loadImages(){
    m_background = loadImage("game_background.png");
  }

  void loadFonts(){
    m_menuFont = createFont("./Atari-Classic/AtariClassic-Regular.ttf",56);
    textFont(m_menuFont);
    textAlign(CENTER,CENTER);
  }

  void Start(){
    Controller c = m_controlGUI.getController("Start");
    c.hide();
    m_director.changeScene(CandyCrush.m_gameScene);
  }

  void handleInput(int k){
  }
  void run(float dt){
    this.update(dt);
    this.draw();

    this.lateUpdate(dt);
    this.lateDraw();
  }

  void update(float dt){
    m_backgroundPosition.x += -50 * dt;
    if(m_titleAnimationCurrentDuration >= m_titleAnimationDuration){
      m_titleAnimationCurrentDuration = m_titleAnimationDuration;
      m_titleAnimation = false;
    }
    if(m_titleAnimation){
      m_titlePosition.y = - 100 + (height/2 + 100) * m_titleAnimationCurrentDuration/m_titleAnimationDuration;
      Controller c = m_controlGUI.getController("Start");
      c.setPosition(width/2 - c.getWidth()/2,m_titlePosition.y + 100);
    }

    if(m_backgroundPosition.x <= -m_background.width){
      m_backgroundPosition.x = 0;
    }

    m_titleAnimationCurrentDuration += dt;
  }
  void lateUpdate(float dt){

  }

  void draw(){
    tint(0,53,105);
    image(m_background,m_backgroundPosition.x,m_backgroundPosition.y);
    image(m_background,m_backgroundPosition.x + m_background.width,m_backgroundPosition.y);
    fill(random(0,244),244,0);
    text("MAMICRUSH",width/2, m_titlePosition.y);
  }

  void lateDraw(){

  }
}
