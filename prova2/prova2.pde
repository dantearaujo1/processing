int[][] tabuleiro;
int tilesX;
int tilesY;
int tileSize;

int px;
int py;
int direction;

color paredes;
color vazio;
color pacmanColor;
color vitoria;

boolean fim;

void setup(){
  size(800,800);
  colorMode(HSB,360,100,100);
  tileSize = 32;
  tilesX = width/tileSize;
  tilesY = height/tileSize;

  paredes = color(int(random(0,361)),int(random(60,101)),int(random(70,101)));
  vazio = color(hue(paredes) - 120,saturation(paredes),brightness(paredes));
  pacmanColor = color(hue(paredes) + 120,saturation(paredes),brightness(paredes));
  vitoria = color(70,0,brightness(paredes));

  criar();
  direction = 0;
  px = 0;
  py = 0;
  fim = false;
}

void draw(){
  if(fim){
    background(0);
    textSize(52);
    colorMode(RGB,255,255,255);
    fill(255);
    text("FIM DE JOGO", width/2 - textWidth("FIM DE JOGO")/2, height/2 - 52/2 );
    colorMode(HSB,360,100,100);
  }
  else{
    desenhar();
    desenharPacman(direction);
  }
}

// Define uma matriz de Zeros e Uns
void criar(){
  tabuleiro = new int[tilesY][tilesX];
  criarPadrao();
}

void desenharPacman(int direction){
  fill(pacmanColor);
  ellipseMode(CORNER);
  switch (direction){
    case 0:
      circle(px*tileSize,py*tileSize,tileSize);
      fill(0);
      circle(px*tileSize +20,py*tileSize + tileSize/2 - 10,tileSize/5);
      break;
    case 1:
      circle(px*tileSize,py*tileSize,tileSize);
      fill(0);
      circle(px*tileSize +5,py*tileSize + tileSize/2 - 10,tileSize/5);
      break;
    case 2:
      circle(px*tileSize,py*tileSize,tileSize);
      fill(0);
      circle(px*tileSize + tileSize/2,py*tileSize + tileSize/5,tileSize/5);
      break;
    case 3:
      circle(px*tileSize,py*tileSize,tileSize);
      fill(0);
      circle(px*tileSize + tileSize/2 ,py*tileSize + tileSize/2,tileSize/5);
      break;
  }
  ellipseMode(CENTER);
}

// Percorre a matriz criada em criar e desenha os elementos na tela
void desenhar(){
  background(0);
  for (int y = 0; y < tabuleiro.length; y++){
    for (int x = 0; x < tabuleiro[y].length; x++){
      if(tabuleiro[y][x] == 1){
        fill(paredes);
      }
      if(tabuleiro[y][x] == 0){
        fill(vazio);
      }
      if(tabuleiro[y][x] == 2){
        fill(vitoria);
      }
      rect(x * tileSize, y * tileSize, tileSize, tileSize);
    }
  }
}

void criarPadrao(){
  for (int y = 0; y < tabuleiro.length; y++){
    for (int x = 0; x < tabuleiro[y].length; x++){
      tabuleiro[y][x] = 0;
      quadrado(x,y,7,false);
      quadrado(x,y,5,true);
      quadrado(x,y,3,false);
      quadrado(x,y,1,true);
    }
  }
}

void quadrado(int x, int y, int location, boolean invert){
  if(y == location || y == tilesY - (location + 1) || x == location || x == tilesX - (location + 1)){
    if (y <= location - 1 && x >= location && x <= tilesX - location){
      tabuleiro[y][x] = 0;
      return;
    }
    if (y >= tilesY - location && x >= location && x <= tilesX - location){
      tabuleiro[y][x] = 0;
      return;
    }
    if (x <= location - 1 && y >= location && y <= tilesY - location){
      tabuleiro[y][x] = 0;
      return;
    }
    if (x >= tilesX - location && y >= location && y <= tilesY - location){
      tabuleiro[y][x] = 0;
      return;
    }
    if(!invert){
        // Abertura Inferior
        if (y == tilesY - (location + 1) && x == tilesX/2 - 1 || y == tilesY - (location + 1) && x == tilesX/2){
          tabuleiro[y][x] = 0;
          return;
        }
        tabuleiro[y][x] = 1;
    }
    else{
        // Abertura Superior
        if (y == location && x == tilesX/2 - 1 || y == location && x == tilesX/2){
          tabuleiro[y][x] = 0;
          return;
        }
        tabuleiro[y][x] = 1;
    }
  }
  else if ( x >= tilesX/2 - 2 && x <= tilesX/2 + 2){
    if (y >= tilesY/2 - 2 && y <= tilesY/2 +2){
      tabuleiro[y][x] = 2;
    }
  }
}

void keyPressed(){
  if (key == 'd' && px+1 < tilesX && tabuleiro[py][px+1] != 1 ){
    px += 1;
    direction = 0;
  }
  else if (key == 'a'&& px-1 >= 0 && tabuleiro[py][px-1] != 1){
    px -= 1;
    direction = 1;
  }
  else if (key == 'w'&& py-1 >= 0 && tabuleiro[py-1][px] != 1){
    py -= 1;
    direction = 2;
  }
  else if (key == 's'&& py+1 < tilesY && tabuleiro[py+1][px] != 1){
    py += 1;
    direction = 3;
  }
  fim(px,py);
}

void fim(int x, int y){
  if (tabuleiro[y][x] == 2){
    fim = true;
  }
}
