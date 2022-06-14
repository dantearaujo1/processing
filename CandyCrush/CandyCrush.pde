// Setting Global Variables;
Game CandyCrush;
HashMap<String,Integer> COLORS = new HashMap<String,Integer>();

// Setup Initial State
void setup(){
  size(600,600);
  CandyCrush = new Game(0);
  COLORS.put("RED",color(200,0,0));
  COLORS.put("GREEN",color(0,200,0));
  COLORS.put("YELLOW",color(200,200,0));
  COLORS.put("BLUE",color(0,0,200));
  COLORS.put("BLACK",color(0,0,0));
  COLORS.put("CYAN",color(0,200,200));
}

// GameLoop
void draw(){
  background(0);
  CandyCrush.play();
}

void keyPressed(){
  if(CandyCrush.getPlayer() != null){
    CandyCrush.getPlayer().handleInput(key);
  }
}

