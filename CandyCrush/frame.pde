class Frame{
  int x;
  int y;
  int width;
  int height;

  Frame(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
  }
  Frame(){
    this.x = 0;
    this.y = 0;
    this.width = 16;
    this.height = 16;
  }
}
