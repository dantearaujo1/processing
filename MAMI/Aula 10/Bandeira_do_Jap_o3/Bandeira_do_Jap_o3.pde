float x,y,w,h;
float mod;
float cx,cy;
float d;
boolean escolhido;
boolean iniciado;
String str_num;

void setup(){
  size(800,600);
  escolhido = false;
  iniciado = false;
  mod = 0.0;
  str_num = "";
  x = 0.0;
  y = 0.0;
  w = 3.0 * mod;
  h = 2.0 * mod;
  cx = w/2.0;
  cy = h/2.0;
  d =  1.2 * mod;
}

void draw(){
  background(0);
  if (escolhido){
    if (!iniciado){
      x = 0.0;
      y = 0.0;
      w = 3.0 * mod;
      h = 2.0 * mod;
      cx = w/2.0;
      cy = h/2.0;
      d =  1.2 * mod;
      iniciado = true;
    }
    fill(255,255,255);
    rect(x,y,w,h);
    fill(255,0,0);
    circle(cx,cy,d);
  }
  else{
    fill(255);
    text("Choose mod value", width/2 - textWidth("Choose mod value")/2, height/2);
    textSize(16);
    text(str_num, width/2 - textWidth(str_num)/2, height/2 + 16);
  }

}

void keyPressed(){
 if(key >= '0' && key <='9' && str_num.length() < 3){
   str_num += key;
 }
 if (key == ENTER){
   mod = float(str_num);
   escolhido = true;
 }
 if (key == 'r'){
   setup();
 }
}

void getNumber(float armazenar, int casas, String sArmazenar){
 if(key >= '0' && key <='9' && str_num.length() < 3){
   sArmazenar += key;
 }
 if (key == ENTER){
   armazenar = float(str_num);
   escolhido = true;
 }
}
