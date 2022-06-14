import controlP5.*;

ControlP5 cp5;
Range range;
Slider slider1;
int slider1Value;

PImage img1, img2;
PImage imgResultado = createImage(612, 409, RGB);

void setup() {
  size(800, 600);
  background(0);

  slider1Value = 0;

  img1 = loadImage("img1.jpg");
  img2 = loadImage("img2.jpg");

  cp5 = new ControlP5(this);
  cp5.addSlider("slider1Value")
    .setPosition(125,50)
    .setLabel("Dissolve")
    .setSize(400,30)
    .setRange(0,100);

  cp5.getController("slider1Value").getCaptionLabel().align(ControlP5.CENTER,ControlP5.TOP_OUTSIDE).setPaddingX(0);
  noStroke();
}

void draw() {

  dissolve(slider1Value/100.0);

  image(imgResultado,20, 135);
}

void dissolve(float k){
  float r1,g1,b1;
  float r2,g2,b2;
  float r3,g3,b3;
  color corImg1, corImg2, corResultado;

  for(int x = 0; x < 612; x++){
    for(int y = 0; y < 409; y++){
      corImg1 = img1.get(x,y);
      r1 = red(corImg1);
      g1 = green(corImg1);
      b1 = blue(corImg1);

      corImg2 = img2.get(x,y);
      r2 = red(corImg2);
      g2 = green(corImg2);
      b2 = blue(corImg2);

      r3 = k * r1 + (1.0-k) * r2;
      g3 = k * g1 + (1.0-k) * g2;
      b3 = k * b1 + (1.0-k) * b2;
      corResultado = color(r3,g3,b3);

      imgResultado.set(x,y,corResultado);
    }
  }
}

