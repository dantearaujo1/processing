class EndScene implements IScene{
  SceneManager  m_director;
  ControlP5     m_controlGUI;
  EndScene(SceneManager director, PApplet app){
    if (director != null){
      m_director = director;
    }
    if(app != null){
      m_controlGUI = new ControlP5(app);
    }

  }

  void onInit(){
    m_controlGUI.addButton("Menu")
      .plugTo(this)
      .setPosition(width*0.70,height*0.9)
      .setSize(int(width * 0.1),int(height * 0.083))
      .setColorBackground(color(255,255,0,0))
      .setColorActive(color(255,255,0,0))
      .getCaptionLabel()
      .setFont(new ControlFont(g_gameFont,int(9*g_scaleFactorX)));
    m_controlGUI.addButton("Exit")
      .plugTo(this)
      .setPosition(width*0.80,height*0.9)
      .setSize(int(width * 0.1),int(height * 0.083))
      .setColorBackground(color(255,255,0,0))
      .setColorActive(color(255,255,0,0))
      .getCaptionLabel()
      .setFont(new ControlFont(g_gameFont,int(9*g_scaleFactorX)));

  }
  void onPause(){

  }
  void onResume(){

  }
  void onExit(){

  }

  void Exit(){
    exit();
  }

  void Menu(){
    m_director.changeScene(0);
    m_controlGUI.getController("Menu").hide();
    m_controlGUI.getController("Exit").hide();
  }

  void handleInput(int k){

  }

  void update(float dt){

  }

  void lateUpdate(float dt){

  }

  void draw(){
    fill(255,255,0);
    rect(0,0,30,30);
  }

  void lateDraw(){

  }

  void run(float dt){
    update(dt);
    lateUpdate(dt);
    draw();
    lateDraw();

  }

}
