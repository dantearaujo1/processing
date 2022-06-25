// Setting Global Variables;
Game CandyCrush;
boolean g_debug;
HashMap<String,Integer> COLORS = new HashMap<String,Integer>();

// Setup Initial State
void setup(){
  size(600,600);
  g_debug = false;
  CandyCrush = new Game(0,this);
  COLORS.put("RED",color(200,0,0));
  COLORS.put("GREEN",color(0,200,0));
  COLORS.put("YELLOW",color(200,200,0));
  COLORS.put("BLUE",color(0,0,200));
  COLORS.put("BLACK",color(0,0,0));
  COLORS.put("CYAN",color(0,200,200));
  COLORS.put("EMPTY",color(255,255,255));
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
}


PApplet getPApplet(){
  return this;
}


