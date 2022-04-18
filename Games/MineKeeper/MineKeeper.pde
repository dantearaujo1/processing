void setup(){
  size(800,800);
}

void drawBoard(int quadSize){
  for (int y = 0; y < height/quadSize; y++){
    for (int x = 0; x < width/quadSize; x++){
      noFill();
      rect(x*quadSize,y*quadSize,quadSize,quadSize);
    }
  }
}
void draw(){
  background(122,122,200);
  drawBoard(20);

}
