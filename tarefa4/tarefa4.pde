int rectsize = 80;
void setup(){
  size(800,800);

}

void draw(){

  for (int x = 0; x < width/rectsize; x++){
    for (int y = 0; y < height/rectsize; y++){
      int option = 0;
      if (y % 2 == 0 ){
        if (x % 2 == 0){
          createTwoColorsRectangle(x * rectsize, y * rectsize, rectsize, 0, 255, 4);
        }
        else{
          createTwoColorsRectangle(x * rectsize, y * rectsize, rectsize, 0, 255, 1);
        }

      }
      else {
        if (x % 2 == 0){
          createTwoColorsRectangle(x * rectsize, y * rectsize, rectsize, 0, 255, 2);
        }
        else{
          createTwoColorsRectangle(x * rectsize, y * rectsize, rectsize, 0, 255, 3);
        }
      }

    }
  }
}

void createTwoColorsRectangle(int x, int y, int size, color one, color two, int option){
  option = 4 - option % 4;

  switch (option){
    case 1:
      fill(one);
      triangle(x,y,x+size,y,x+size,y+size);
      fill(two);
      triangle(x,y,x,y+size,x+size,y+size);
      break;
    case 2:
      fill(two);
      triangle(x,y,x+size,y,x,y+size);
      fill(one);
      triangle(x,y+size,x + size,y,x+size,y+size);
      break;
    case 3:
      fill(one);
      triangle(x,y,x+size,y,x,y+size);
      fill(two);
      triangle(x,y+size,x + size,y,x+size,y+size);
      break;
    case 4:
      fill(two);
      triangle(x,y,x+size,y,x+size,y+size);
      fill(one);
      triangle(x,y,x,y+size,x+size,y+size);
      break;
      }
}
