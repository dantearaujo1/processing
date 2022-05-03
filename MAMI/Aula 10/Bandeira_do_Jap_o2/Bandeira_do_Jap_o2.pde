float x,y,w,h;
float mod;
float cx,cy;
float d;
boolean escolhido;
String str_num = "";

void setup(){
  size(800,600);
  escolhido = false;
  mod = 0.0;
  x = 0.0;
  y = 0.0;
  w = 3.0 * mod;
  h = 2.0 * mod;
  cx = w/2.0;
  cy = h/2.0;
  d =  1.2 * mod;
}

void draw(){
  if (escolhido){
    fill(255,255,255);
    rect(x,y,w,h);
    fill(255,0,0);
    circle(cx,cy,d);    
  }
  else{
    text("Choose mod value", width/2, height/2);
    text(str_num, width/2 - textWidth(str_num), height/2 + 16);
  }
  
}

void keyPressed(){
 if(key >= '0' && key <='9' && str_num.length() < 3){
   str_num += key;
 }
 if (key == ENTER){
   mod = int(str_num); 
   escolhido = true;
 }
}
