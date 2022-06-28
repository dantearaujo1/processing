int[]   valores;
int     soma;
color[] cores;

void setup(){
  size(600,600);
  valores = new int[3];
  cores = new color[3];
  soma = 0;

  createSectorGraph();
}

void draw(){
    background(255);
    drawGraph();
}

void keyPressed(){
  if(key == 'q'){
    createSectorGraph();
  }
}

void createSectorGraph(){
  soma=0;
  for (int i = 0; i < 3; i++){
    int result = int(random(0,101-soma));
    valores[i] = result;
    soma+=result;

    cores[i] = color(random(0,255),random(0,255),random(0,255));
  }
  if (soma < 100){
    valores[valores.length-1] += 100 - soma;
  }
}

void drawGraph(){
  float cx = width/2;
  float cy = height/2;

  float angulo1 = radians(360) * valores[0]/100;
  float angulo2 = radians(360) * valores[1]/100;
  float angulo3 = radians(360) * valores[2]/100;

  /* fill(0,0,0); */
  /* circle(cx,cy,300); */
  fill(cores[0]);
  arc(cx,cy,300,300,0,angulo1);
  fill(cores[1]);
  arc(cx,cy,300,300,angulo1,angulo1 + angulo2);
  fill(cores[2]);
  arc(cx,cy,300,300,angulo1 + angulo2 ,angulo1 + angulo2 + angulo3);

  fill(cores[0]);
  rect(width/2 + 170, height/2 + 206,20,20);
  fill(cores[1]);
  rect(width/2 + 170, height/2 + 222,20,20);
  fill(cores[2]);
  rect(width/2 + 170, height/2 + 238,20,20);
  fill(0,0,0);
  text("Legenda", width/2 + 200, height/2 + 200);
  text("V1: " + valores[0] + "%", width/2 + 200, height/2 + 218);
  text("V2: "  + valores[1] + "%", width/2 + 200, height/2 + 236);
  text("V3: "  + valores[2] + "%", width/2 + 200, height/2 + 252);

}
