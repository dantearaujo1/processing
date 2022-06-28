// Setting Global Variables;
Game CandyCrush;
boolean g_debug;
HashMap<String,Integer> COLORS = new HashMap<String,Integer>();

PFont g_debugFont;
PFont g_gameFont;

// Setup Initial State
void setup(){
  size(600,600);
  g_debug = false;

  g_debugFont = createFont("Serif",9);
  g_gameFont = createFont("./Atari-Classic/AtariClassic-Regular.ttf",56);

  COLORS.put("RED",color(200,0,0));
  COLORS.put("GREEN",color(0,200,0));
  COLORS.put("YELLOW",color(200,200,0));
  COLORS.put("BLUE",color(0,0,200));
  COLORS.put("BLACK",color(0,0,0));
  COLORS.put("CYAN",color(0,200,200));
  COLORS.put("EMPTY",color(255,255,255));

  CandyCrush = new Game(0,this);
}

// GameLoop
void draw(){
  background(0);
  CandyCrush.play();
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


