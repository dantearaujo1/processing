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
