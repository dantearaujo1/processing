// Setting Global Variables;
Game    CandyCrush;
boolean g_debug;
float   g_scaleFactorX;
float   g_scaleFactorY;
PFont   g_debugFont;
PFont   g_gameFont;
PImage  g_image;
PImage  g_backgroundTile;
Frame[] g_frames;

HashMap<String,Frame> BACKTILES = new HashMap<String,Frame>();
HashMap<String,Frame> CANDYS = new HashMap<String,Frame>();


void settings(){
  /* fullScreen(P2D); */
  size(900,600);
  noSmooth();
}
// Setup Initial State
void setup(){
  g_scaleFactorX = width/600.0;
  g_scaleFactorY = height/600.0;
  g_debug = false;

  g_debugFont = createFont("Serif",9);
  g_gameFont = createFont("./Atari-Classic/AtariClassic-Regular.ttf",56);
  g_image= loadImage("candys.png");
  g_backgroundTile = loadImage("background_tile.png");

  g_frames = new Frame[7];
  int w = 32;
  int h = 32;
  for(int i = 0; i < 7; i++){
    g_frames[i] = new Frame(i*32, 0, w, h);
  }

  CANDYS.put("RED",g_frames[0]);
  CANDYS.put("GREEN",g_frames[2]);
  CANDYS.put("YELLOW",g_frames[1]);
  CANDYS.put("BLUE",g_frames[3]);
  CANDYS.put("MAGENTA",g_frames[4]);
  CANDYS.put("ORANGE",g_frames[5]);
  CANDYS.put("EMPTY",new Frame(0,0,0,0));

  BACKTILES.put("LAVA",g_frames[3]);
  BACKTILES.put("ICE",g_frames[1]);
  BACKTILES.put("ACID",g_frames[2]);
  BACKTILES.put("GROUND",g_frames[0]);


  CandyCrush = new Game(0,this);
}

// GameLoop
void draw(){
  background(0);
  CandyCrush.play();
  noTint();
}

void keyPressed(){
  CandyCrush.getDirector().getScene().handleInput(int(key));
}

void changeDebug(){
  g_debug = !g_debug;
  if(g_debug){
    textFont(g_debugFont);
    textAlign(CORNER,CORNER);
  }
  else{
    textFont(g_gameFont);
    textAlign(CENTER,CENTER);
  }
}


PApplet getPApplet(){
  return this;
}


