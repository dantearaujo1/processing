float x,y,w,h; // Quadrado Externo
float lx1, ly1; // Ponto1 Losango
float lx2, ly2; // Ponto2 Losango
float lx3, ly3;
float lx4, ly4;
float mod; // Modulo
float cx,cy; // Centro do Círculo
float d; // Diametro do círculo
int estrelas;
int lines;
PVector[] estrelasPosition;
PVector[] faixaPosition;


void setup(){
  size(800,600);

  lines = 18;
  //Definição da Altura e Largura
  h = 300;
  mod = h/14;
  w = mod * 20;

  x = 0;
  y = 0;

  // Definição dos Pontos do Losango
  lx1 = x + 1.7 * mod; // ( lx1 , ly1 ) ponto esquerdo
  ly1 = h/2;
  lx2 = w - 1.7 * mod; // ( lx2 , ly2 ) ponto direito
  ly2 = h/2;
  ly3 = y + 1.7 * mod; // ( lx3 , ly3 ) ponto superior
  lx3 = w/2;
  ly4 = h - 1.7 * mod; // ( lx4 , ly4 ) ponto inferior
  lx4 = w/2;

  // Definição do Círculo
  d = 6 * mod;
  cx = w/2;
  cy = h/2;

  estrelas = 28;
  estrelasPosition = new  PVector[estrelas];
  for (int i = 0; i < estrelas; i++){
    estrelasPosition[i] = new PVector();
    if (i != 26){
      estrelasPosition[i].x = random(w/2 - d/2 + 20, xTangCircle(d/2 - 2,cx, radians(0)) - 20 );
      estrelasPosition[i].y = random(h/2 + 10, yTangCircle(d/2 - 2,cy,radians(90)) - 10);
    }
    else{
      estrelasPosition[i].x = random(w/2, xTangCircle(d/2 - 2,cx, radians(360)));
      estrelasPosition[i].y = random(h/2 - d/4 + 10, yTangCircle(d/2 - 2,cy, radians(360))) - 10;
    }
  }
  faixaPosition = new PVector[lines];
  for (int i = 0; i < lines; i++){
    faixaPosition[i] = new PVector();
    if(i < lines/2){
      faixaPosition[i].x = xTangCircle(d/2,cx,radians(200 - i ));
      faixaPosition[i].y = yTangCircle(d/2,cy,radians(200 - i ));
    }
    else{
      faixaPosition[i].x = xTangCircle(d/2,cx,radians(360 + lines/2 - i));
      faixaPosition[i].y = yTangCircle(d/2,cy,radians(360 + lines/2 - i));
    }
  }
}

void draw(){
  noStroke();

  //Desenhar Bandeira Externa
  fill(0,122,0);
  rect(x,y,w,h);

  // Desenhar Losango
  fill(255,255,0);
  triangle(lx1,ly1,lx3,ly3,lx2,ly2);
  triangle(lx1,ly1,lx4,ly4,lx2,ly2);

  // Desenhar Circulo
  fill(0,0,122);
  circle(cx,cy,d);

  // Desenhar Faixa
  for (int i = 0; i < lines/2; i++){
    pushStyle();
      stroke(255);
      strokeWeight(3);
      line(faixaPosition[i].x,faixaPosition[i].y, faixaPosition[lines-i-1].x, faixaPosition[lines-i - 1].y);
    }
    popStyle();
  }

  // Desenhar Estrelas
  for (int i = 0; i < estrelas; i++){
    pushStyle();
    fill(255);
    star(estrelasPosition[i].x, estrelasPosition[i].y, 1,3,5);
    popStyle();
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}


float xTangCircle(float r, float cx, float angle){
  return cx + r * cos(angle);
}
float yTangCircle(float r, float cy, float angle){
  return cy + r * sin(angle);
}
