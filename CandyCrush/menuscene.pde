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
    m_controlGUI.addButton("Start")
      .setSize(int(200*g_scaleFactorX),int(50*g_scaleFactorY))
      .plugTo(this)
      .setColorBackground(color(0,0,0,150))
      .setColorForeground(color(122,122,0))
      .setColorActive(color(255,0,0,100))
      .getCaptionLabel()
      .setFont(new ControlFont(g_gameFont,int(20*g_scaleFactorX)));
    loadImages();
    textFont(g_gameFont,56 * g_scaleFactorX);
    textAlign(CENTER,CENTER);
  }

  void onExit(){
    m_controlGUI.getController("Start").hide();
  }
  void onResume(){
    m_titleAnimation = true;
    m_titleAnimationDuration = 2.0;
    m_titleAnimationCurrentDuration = 0.0;
    textFont(g_gameFont);
    textSize(56 * g_scaleFactorX);
    textAlign(CENTER,CENTER);
    m_controlGUI.getController("Start").show();
  }

  void onPause(){

  }

  void loadImages(){
    m_background = loadImage("game_background.png");
    m_background.resize(width,height);
  }


  void Start(){
    controlP5.Controller c = m_controlGUI.getController("Start");
    c.hide();
    m_director.addScene(new GameScene(m_director,getPApplet()));
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
    m_backgroundPosition.x += -50 * dt * g_scaleFactorX;
    if(m_titleAnimationCurrentDuration >= m_titleAnimationDuration){
      m_titleAnimationCurrentDuration = m_titleAnimationDuration;
      m_titleAnimation = false;
    }
    if(m_titleAnimation){
      m_titlePosition.y = interpolation(-100*g_scaleFactorY,
          height/2+0*g_scaleFactorY,
          m_titleAnimationCurrentDuration/m_titleAnimationDuration);

      controlP5.Controller c = m_controlGUI.getController("Start");
      c.setPosition(width/2 - c.getWidth()/2,m_titlePosition.y + 50 * g_scaleFactorY);
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
