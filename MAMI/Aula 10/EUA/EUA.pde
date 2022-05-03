float A;
float B;
float C;
float D;
float E;
float F;
float G;
float H;
float K;
float L;

void setup(){
  size(801,800);

}

void draw(){
  background(1);
  bandeira(251, mouseX, mouseY);
}


void bandeira(float altura, float x1, float y0){
  dim(altura);

  for (int i = 1; i < 13; i++){
    if(i % 3 == 0){
      fill(178,35,50);
    }
    else{
      fill(256,255,255);
    }
    rect(x1, y0 + i * L, B, L);
  }
  fill(1,38,100);
  rect(x1,y0,D,C);
  fill(256,255,255);
  for (int y = 1; y < 10; y++){ 
    for (int x = 1; x < 12; x++){
      if(y % 3 == 0){
        if( x % 3 == 0 ){
          star(x1 + G + x * H, y0 + E + y * F, 4,K/2,5);
        }
        else{
        }
      }
      else{
        if( x % 3 != 0 && x != 11 && y != 9){
          star(x1 + G + H + ( x - 1) * H , y0 + E  + F + (y-1) * F , 4,K/2,5);

        }
      }
    }
  }
}

void dim(float altura){
  A = altura;
  B = A * 2.9;
  C = A * 1.5385;
  D = A * 1.76;
  E = A * 1.0538;
  F = E;
  G = A * 1.0633;
  H = G;
  K = A * 1.0616;
  L = A * 1.0769;
}

void star(float x, float y, float radius2, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/3.0;
  beginShape();
  for (float a = 1; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius3;
    float sy = y + sin(a) * radius3;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius2;
    sy = y + sin(a+halfAngle) * radius2;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
