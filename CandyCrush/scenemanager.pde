interface ITransition{
    void update(float dt);
    void draw();
    void init();
    boolean isStarted();
}

class FadeIn implements ITransition{
  float   m_duration;
  float   m_currentDuration;
  PImage  m_transitionImage;
  boolean m_started;

  FadeIn(float duration){
    m_duration = duration;
    m_currentDuration = 0;
    m_started = true;
    m_transitionImage = createImage(width,height,ARGB);
    /* for ( int x = 0; x < width; x++){ */
    /*   for ( int y = 0; y < height; y++){ */
    /*     m_transitionImage.set(x,y,color(0,0,0)); */
    /*   } */
    /* } */
  }
  boolean isStarted(){
      return m_started;
  }
  void init(){
    m_started = true;
    m_currentDuration = 0;
  }

  void update(float dt){
    if(m_started){
      m_currentDuration += dt;
      if(m_currentDuration >= m_duration){
        m_started = false;
        m_currentDuration = m_duration;
      }
      for ( int x = 0; x < width; x++){
        for ( int y = 0; y < height; y++){
          m_transitionImage.set(x,y,color(0,0,0,interpolation(255,0,m_currentDuration/m_duration)));

        }
      }
    }
  }

  void draw(){
    image(m_transitionImage,0,0);
  }
}
class SceneManager{
  IScene m_currentScene;
  ArrayList<IScene> m_scenes;
  ITransition m_transition;

  SceneManager(){
    m_scenes = new ArrayList<IScene>();
    m_currentScene = null;
    m_transition = new FadeIn(0.3);
  }

  void changeScene(IScene scene){
    if(scene != null){
      for(IScene s : m_scenes){
        if(s == scene){
          m_currentScene.onPause();
          m_transition.init();
          m_currentScene = scene;
          m_currentScene.onResume();
          return;
        }
      }
      addScene(scene);
    }
  }

  void addScene(IScene scene){
    if(scene != null){
      for(IScene s : m_scenes){
        if(s == scene){
          m_currentScene = scene;
          m_currentScene.onResume();
          return;
        }
      }
      m_scenes.add(scene);
      m_currentScene = scene;
      m_currentScene.onInit();

    }
  }

  void deleteScene(IScene scene){
    if(scene != null){
      for(IScene s : m_scenes){
        if(s == scene){
          s.onExit();
          m_scenes.remove(s);
          if(s == m_currentScene){
            m_currentScene = m_scenes.get(m_scenes.size()-1);
          }
          return;
        }
      }
    }
  }

  void update(float dt){
      m_transition.update(dt);
      m_currentScene.update(dt);
  }
  void lateUpdate(float dt){
    m_currentScene.lateUpdate(dt);
  }
  void draw(){
    m_currentScene.draw();
  }
  void lateDraw(){
    m_currentScene.lateDraw();
  }

  IScene getScene(){
    return m_currentScene;
  }

  void run(float dt){
    this.update(dt);
    this.draw();

    this.lateUpdate(dt);
    this.lateDraw();
    if(m_transition.isStarted()){
      m_transition.draw();
    }

  }
}
