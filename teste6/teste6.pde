int[][] mapa;

void setup(){
  size(500,500);
  criarMatriz();
}

void draw(){
  desenharMatriz();
}
void criarMatriz(){
  mapa = new int[20][20];
  for (int x = 0; x < 20; x++){
    for (int y = 0; y < 20; y++){
      mapa[x][y] = 0;
      criarPadrao(x,y);
    }
  }
}
void criarPadrao(int x , int y){
  // Eu e vc ainda vamos pensar
  if (x > 1 && x < 18 && x < 3 && x > 16){
    mapa[x][y] = 0;
  }
  if (y > 1 && y < 18 && y < 3 && y > 16){
    mapa[x][y] = 0;
  }
  else{
    mapa[x][y] = 1;
  }
}

void desenharMatriz(){
  for (int x = 0; x < 20; x++){
  for (int y = 0; y < 20; y++){
      if(mapa[x][y] == 1){
        fill(255);
      }
      if(mapa[x][y] == 0){
        fill(0);
      }
      rect(x*25, y*25, 25, 25);
    }
  }
}

