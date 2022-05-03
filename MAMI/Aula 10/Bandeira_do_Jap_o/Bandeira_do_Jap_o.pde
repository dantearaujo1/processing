int x,y,w,h;
int mod;
int cx,cy;
float d;

void setup(){
  size(800,600);
  mod = 100;
  x = 0;
  y = 0;
  w = 3 * mod;
  h = 2 * mod;
  cx = w/2;
  cy = h/2;
  d =  1.2 * mod;
}

void draw(){
  fill(255,255,255);
  rect(x,y,w,h);
  fill(255,0,0);
  circle(cx,cy,d);
  
  
  
  
  
  
  
  
  
}
