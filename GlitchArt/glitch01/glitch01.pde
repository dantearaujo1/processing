PImage image;

void setup(){
  size(400,400);
  image = loadImage("canon.jpg");
}
void draw(){
  background(0);
  image(image,0,0,width,height);
  for (int j = 0; j < height; j++){
    for (int i = 0; i < width; i++){
      color c = get(i*3,j*3);
      fill(c);
      if(j >= 0 && j < 25){
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        fill(color(r,g/4,b/4));
      }
      // Média Aritimética
      if(j > 30 && j < 50){
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        float ci = (r+g+b)/3;
        fill(color(ci,ci,ci));
      }
      // Média Ponderada
      if(j >= 50 && j < 75){
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        float ci = 0.3 * r + 0.59 * g + 0.11 * b;
        fill(color(ci,ci,ci));
      }
      if(j >= 75 && j < 100){
        float r = red(c);
        float g = green(c);
        float b = blue(c);
        fill(color(r/2,g,b/2));
      }
      noStroke();
      circle(i*3,j*3,3);
    }
  }
  filter(INVERT);
}
