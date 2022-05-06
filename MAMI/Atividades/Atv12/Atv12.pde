import processing.svg.*;

float A;
float B;
float C;
float D;
float E;
float F;
float G;
float H;
float I;
float J;
float K;
float L;
float M;
boolean showReference;

void setup(){
  setReferences(1000);
  size(1000,1000,SVG,"dropboxReference.svg");
  showReference = true;
}

void draw(){
  //background(0);
  createLogo(mouseX,mouseY);
  exit();

}

void setReferences(float mod){
  A = mod;
  B = 0.05 * A;
  C = 0.15 * A;
  D = 0.16 * A;
  E = 0.17 * A;
  F = 0.20 * A;
  G = 0.22 * A;
  H = 0.25 * A;
  I = 0.27 * A;
  J = 0.32 * A;
  K = 0.37 * A;
  L = 0.50 * A;
  M = 0.85 * A;
}

void createLogo(float atX, float atY){
  fill(0);
  noStroke();
  losango(atX + 0,atY + D, atX + H, atY + 0, atX + L, atY + D, atX + H, atY + 2 * D);
  losango(atX + L,atY + D, atX + H + L, atY + 0, atX + L * 2, atY + D, atX + H + L, atY + 2 * D);
  losango(atX + 0,atY + D + J, atX + H, atY + 0 + J, atX + L, atY + D + J, atX + H, atY + 2 * D + J);
  losango(atX + L,atY + D + J, atX + H + L, atY + 0 + J, atX + L * 2, atY + D + J, atX + H + L, atY + 2 * D + J);
  losango( atX + H, atY + M - J/2, atX + A/2, atY + M - J, atX + A - H, atY + M - J/2,atX +  A/2, atY + M);

  if(showReference){
    pushStyle();
    noFill();
    stroke(0,255,0);
    // Outside rect
    rect(atX,atY,A,M);

    for(int x =0 ; x < 4; x++){
      line(atX + H * x,atY + 0,atX + H * x,atY + M);
    }
    line(atX, atY + D, atX + A, atY + D);
    line(atX, atY + D + J, atX + A, atY + D + J);
    // Following reference F is not correct
    line(atX, atY + M - F, atX + A, atY + M - F);

    // Diagonal Lineas
    line(atX,atY + M, atX + A, atY + M - 2 * J);
    line(atX,atY + M - 2 * J, atX + A, atY + M);
    line(atX,atY + M - B, atX + A, atY + M - 2 * J - B);
    line(atX,atY + M - 2 * J - B, atX + A, atY + M - B);
    popStyle();
  }
}

void losango(float x1, float y1,float x2, float y2,float x3, float y3,float x4, float y4){
  triangle(x1,y1,x2,y2,x2,y1);
  triangle(x2,y2,x3,y3,x2,y3);
  triangle(x3,y3,x4,y4,x4,y3);
  triangle(x4,y4,x1,y1,x4,y1);
}


void keyPressed(){
  if(key == 'd'){
    showReference =! showReference;
  }
}
