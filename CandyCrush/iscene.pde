import controlP5.*;

interface IScene {


  void onInit();
  void onResume();
  void onPause();
  void onExit();
  void handleInput(int k);
  void update(float dt);
  void lateUpdate(float dt);
  void draw();
  void lateDraw();
  void run(float dt);


}



