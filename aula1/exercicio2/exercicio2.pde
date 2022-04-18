PVector rgb;
color first;
color second;
color third;
float shadow = 0.8;

void setup(){
  size(640,640);
  background(255);
  rgb = new PVector(220,220,220);

  first = color(rgb.x,rgb.y,rgb.z);

  rgb.mult(shadow);
  second = color(rgb.x,rgb.y,rgb.z);

  rgb.mult(shadow);
  rgb.mult(shadow);
  third = color(rgb.x,rgb.y,rgb.z);
}

void draw(){
  fill(first);
  triangle(10,320,320,370,640,200);
  fill(second);
  triangle(10,320,320,370,320,450);
  fill(third);
  triangle(640,200,320,370,320,450);
}
