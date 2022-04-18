int state;
int eHoriz;
int eVert;

int w;
int h;

color one;
color two;


void setup(){
  size(800,800);
  state = 0;
  eHoriz = 10;
  eVert = 10;
  w = width/eHoriz;
  h = height/eVert;
  one = color(255,255,255);
  two = color(0,0,0);

}

void draw(){
  background(255);
  switch(state){
    case 0:
      Pattern1();
      break;
    case 1:
      Pattern2();
      break;
    default:
      break;
  }

}

void Pattern1(){
  noStroke();
  for (int y = 0; y <= eVert; y++){
    for (int x = 0; x <= eHoriz; x++){
      if(x%2==1){
        if(y%2==1){
          rightDrawing(x,y,w,h);
        }
        else{
          leftDrawing(x,y,w,h);
        }
      }
      else{
        if(y%2==1){
          leftDrawing(x,y,w,h);
        }
        else{
          rightDrawing(x,y,w,h);
        }
      }
    }
  }
}
void Pattern2(){
  noStroke();
  for (int y = 0; y <= eVert; y++){
    for (int x = 0; x <= eHoriz; x++){
      if(x%2==1){
        if(y%2==1){
          blackDrawing(x,y,w,h);
        }
        else{
          whiteDrawing(x,y,w,h);
        }
      }
      else{
        if(y%2==1){
          whiteDrawing(x,y,w,h);
        }
        else{
          blackDrawing(x,y,w,h);
        }
      }
    }
  }
}

void leftDrawing(int x, int y, int w, int h){
      rectMode(CENTER);
      fill(one);
      rect(x * w + w/2, y * h + h/2, w, h);
      fill(two);
      rect(x * w + w/2 + w/4, y * h + h/2, w/2, h);
      fill(two);
      arc(x * w + w/2, y * h + h/2, w, h, HALF_PI, PI + HALF_PI);
      fill(one);
      arc(x * w + w , y * h, w, h, HALF_PI, PI);
      arc(x * w + w , y * h + h , w, h, PI,  PI + HALF_PI);
}
void rightDrawing(int x, int y, int w, int h){
      fill(two);
      rect(x * w + w/2, y * h + h/2, w, h);
      fill(one);
      rect(x * w + w/2 + w/4, y * h + h/2, w/2, h);
      fill(one);
      arc(x * w, y * h, w, h, 0, HALF_PI);
      arc(x * w, y * h + h, w, h, PI + HALF_PI, TWO_PI);
      fill(two);
      arc(x * w + w/2, y * h + h/2, w, h, PI + HALF_PI, TWO_PI + HALF_PI);
}

void blackDrawing(int x, int y, int w, int h){
  fill(two);
  rect(x * w + w/2,y * h + h/2,w,h);
  fill(one);
  circle(x * w + w/2,y * h + h/2,w);
  fill(two);
  circle(x * w + w/2,y * h + h/2,w * 0.7);
  fill(one);
  circle(x * w + w/2,y * h + h/2,w * 0.4);
  fill(two);
  circle(x * w + w/2,y * h + h/2,w * 0.2);
}

void whiteDrawing(int x, int y, int w, int h){
  fill(one);
  rect(x * w + w/2,y * h + h/2,w,h);
  fill(two);
  circle(x * w + w/2,y * h + h/2,w);
  fill(one);
  circle(x * w + w/2,y * h + h/2,w * 0.7);
  fill(two);
  circle(x * w + w/2,y * h + h/2,w * 0.4);
  fill(one);
  circle(x * w + w/2,y * h + h/2,w * 0.2);

}

void mousePressed(){
  if (mouseButton == LEFT){
    state = 0;
  }
  if (mouseButton == RIGHT){
    state = 1;
  }
  if (mouseButton == CENTER){
    Colorize();
  }
}

void keyPressed(){
}
void Colorize(){
  one = color((int)random(255),(int)random(255),(int)random(255));
  two = color(red(one),green(one),blue(one));
  colorMode(HSB,360,100,100);
  if (hue(two) - 120 < 0){
    float c = 360 + hue(two) - 120;
    two = color(c,saturation(two),brightness(two));
  }
  else{
    two = color(hue(two)-120,saturation(two),brightness(two));
  }
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if (e < 0){
    eHoriz++;
    eVert++;
  }
  else{
    eHoriz--;
    if(eHoriz <=1){
      eHoriz=1;
    }
    eVert--;
    if(eVert <=1){
      eVert=1;
    }
  }
  w = width/eHoriz;
  h = height/eVert;
}
