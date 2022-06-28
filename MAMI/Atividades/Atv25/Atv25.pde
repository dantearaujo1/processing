int[]   valores;
color[] cores;

void setup(){
  size(600,600);
  valores = new int[3];
  cores = new color[3];
  for (int i = 0; i < 3; i++){

    valores[i] = int(random(0,100));
    println("Valor" + i + ":" );
    cores[i] = color(random(0,255),random(0,255),random(0,255));
  }

  float cx = width/2;
  float cy = height/2;
  float angulo1 = radians(360) * valores[0]/100;
  float angulo2 = radians(360) * valores[1]/100;
  float angulo3 = radians(360) * valores[2]/100;

  println(angulo1);
  println(angulo2);
  println(angulo3);
  fill(255,255,255);
  circle(cx,cy,300);
  fill(cores[0]);
  arc(cx,cy,300,300,0,angulo1);
  fill(cores[1]);
  arc(cx,cy,300,300,angulo1,angulo1 + angulo2);
  fill(cores[2]);
  arc(cx,cy,300,300,angulo1 + angulo2 ,angulo1 + angulo2 + angulo3);

}
