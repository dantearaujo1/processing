int[][] tiles;
boolean[][] bombs;
boolean[][] showed;

int tileWidth;
int tileHeight;
int ntiles;
int nbombs;

boolean show;
boolean debug;
boolean gameOver;

void setup(){
  size(800,800);
  textSize(16);
  ntiles = 10;
  nbombs = 4;
  tiles = new int[ntiles][ntiles];
  bombs = new boolean[ntiles][ntiles];
  showed = new boolean[ntiles][ntiles];
  for (int y = 0; y < ntiles; y++){
    for (int x = 0; x < ntiles; x++){
      tiles[y][x] = 0;
      bombs[y][x] = false;
      showed[y][x] = false;
    }
  }
  tileWidth = width/ntiles;
  tileHeight = height/ntiles;
  debug = false;
  show = false;
  gameOver = false;
  createBombs();
}

void keyPressed(){
  if(key == 'e'){
    debug = !debug;
  }
}


void draw(){
  background(0);
  for (int y = 0; y < tiles.length; y++){
    for (int x= 0; x < tiles[y].length; x++){
      stroke(255);
      strokeWeight(2);
      if (bombs[y][x]){
        if(showed[y][x]){
          if(gameOver){
            fill(255,0,0);
          }
          else{
            fill(0);
          }
          rect(x * tileWidth, y * tileHeight,tileWidth,tileHeight);
          fill(255);
          text(tiles[y][x], 40 + (x * tileWidth), y * tileHeight + 40);
        }
        else{
          stroke(255);
          fill(0);
          rect(x * tileWidth, y * tileHeight,tileWidth,tileHeight);
        }
      }
      else{
        stroke(255);
        fill(0);
        rect(x * tileWidth, y * tileHeight,tileWidth,tileHeight);
        if(showed[y][x]){
          fill(255);
          text(tiles[y][x], 40 + (x * tileWidth), y * tileHeight + 40);
        }
      }
    }
  }
  fill(122,122,122);
  rect(getTileX(mouseToTileCoordinate()) * width/ntiles, getTileY(mouseToTileCoordinate()) * height/ntiles ,width/ntiles,height/ntiles);

  if(debug){
    fill(255);
    text(mouseX + "," + mouseY, 10 , 15);
    text("Tile Coordinate: " + mouseToTileCoordinate(), 10 , 30);
    text("Tile (x,y): (" + getTileX(mouseToTileCoordinate()) + "," + getTileY(mouseToTileCoordinate()) + ")", 10 , 45);
    text("Show: " + showed[getTileY(mouseToTileCoordinate())][getTileX(mouseToTileCoordinate())], 10 , 60);
    /* text("Bombs around: " + checkBombs(mouseToTileCoordinate()), 10 , 50); */
  }
  if(gameOver){
    textSize(54);
    rect(width/2 - 250,height/2 - 50,500, 100);
    fill(0);
    text("Fim de Jogo", width/2 - textWidth("Fim de Jogo")/2, height/2 + 27);
    textSize(16);
  }

}

void mousePressed(){
  if(gameOver){
    if (mouseButton == RIGHT){
      setup();
    }

  }
  else{
    if (mouseButton == LEFT){
      if(teste(getTileX(mouseToTileCoordinate()), getTileY(mouseToTileCoordinate()))){
        gameOver = true;
        for(int y = 0; y < ntiles; y++){
          for(int x = 0; x < ntiles; x++){
            showed[y][x]=true;
          }
        }
      }
      else{
        int bombPosition = getTile(getTileX(mouseToTileCoordinate()),getTileY(mouseToTileCoordinate()));
        ShowNeighbors(bombPosition);

      }
    }
    if (mouseButton == CENTER){
      addBomb(getTileX(mouseToTileCoordinate()), getTileY(mouseToTileCoordinate()));
    }
    if (mouseButton == RIGHT){
      destroyBomb(getTileX(mouseToTileCoordinate()), getTileY(mouseToTileCoordinate()));
    }
  }
}

void createBombs(){
  for (int i = 0; i < nbombs; i++){
    int bombPosition = (int)random(0,ntiles*ntiles);
    bombs[getTileY(bombPosition)][getTileX(bombPosition)] = true;
    int start =  bombPosition - ntiles - 1;
    PopulateNeighbors(bombPosition, start, true);
  }
}

void PopulateNeighbors(int bombPosition, int start, boolean sum){
    int checkX = 3;
    int checkY = 3;
    boolean anotherCase = false;
    boolean anotherCase2 = false;
    if (bombPosition < 10 && bombPosition != 0){
      checkY = 2;
      start += ntiles;
      anotherCase = true;
      anotherCase2 = false;
    }
    if (bombPosition % 10 == 0){
      checkX = 2;
      checkY = 3;
      start++;
      anotherCase2 = true;
      anotherCase = false;
    }

    for (int y = 0; y < checkY; y++){
      for (int x = 0; x < checkX; x++){
        int position = x+y*checkY;
        // Quando for o caso normal para checar todos os 9 tiles
        if (position == 4 && anotherCase == false && anotherCase2 == false){
          continue;
        }
        // Quando for o caso em que os tiles são menores que 10 [INDICE]
        else if (position == 1 && anotherCase == true && anotherCase2 == false){
          continue;
        }

        // Quando for o caso em que estamos na coluna de Indice 0
        else if (position == 3 && anotherCase == false && anotherCase2 == true){
          continue;
        }
        else{
          int z = getTileY(start) + y; //<>//
          int t = getTileX(start) + x;
          if (t >= 0 && z >= 0 && t < 10 && z < 10){
            if(sum){
                tiles[z][t]  += 1;
              }
            if(!sum){
              tiles[z][t]  -= 1;
            }
          }
        }
      }
    }
}

// This function makes a one dimensional array return the X value of a two dimensional array
int getTileX(int number){
  return number - ceil(number/ntiles) * ntiles;
}
// This function makes a one dimensional array return the Y value of a two dimensional array
int getTileY(int number){
  return (number - getTileX(number)) / ntiles;
}
// This Function makes a two dimensional position return an one dimensional position in an array
int getTile(int x, int y){
  return x + y * ntiles;
}

int mouseToTileCoordinate(){
  int x = mouseX * ntiles/width;
  int y = mouseY * ntiles/height;
  return getTile(x,y);
}


boolean teste(int i, int j){
  return bombs[j][i];
}

void addBomb(int x, int y){
  bombs[y][x] = true;
  int bombPosition = getTile(x,y);
  int start = bombPosition - ntiles - 1;
  PopulateNeighbors(bombPosition, start, true);
}

void destroyBomb(int x, int y){
  bombs[y][x] = false;
  int bombPosition = getTile(x,y);
  int start = bombPosition - ntiles - 1;
  PopulateNeighbors(bombPosition, start, false);
}

void ShowNeighbors(int bombPosition ){
    int checkX = 3;
    int checkY = 3;
    int start = bombPosition - ntiles - 1;
    boolean anotherCase = false;
    boolean anotherCase2 = false;
    if (bombPosition < 10 && bombPosition != 0){
      checkY = 2;
      start += ntiles;
      anotherCase = true;
      anotherCase2 = false;
    }
    if (bombPosition % 10 == 0){
      checkX = 2;
      checkY = 3;
      start++;
      anotherCase2 = true;
      anotherCase = false;
    }

    for (int y = 0; y < checkY; y++){
      for (int x = 0; x < checkX; x++){
        int position = x+y*checkY;
        // Quando for o caso normal para checar todos os 9 tiles
        if (position == 4 && anotherCase == false && anotherCase2 == false){
          continue;
        }
        // Quando for o caso em que os tiles são menores que 10 [INDICE]
        else if (position == 1 && anotherCase == true && anotherCase2 == false){
          continue;
        }

        // Quando for o caso em que estamos na coluna de Indice 0
        else if (position == 3 && anotherCase == false && anotherCase2 == true){
          continue;
        }
        else{
          int z = getTileY(start) + y; //<>//
          int t = getTileX(start) + x;
          if (t >= 0 && z >= 0 && t < 10 && z < 10){
            showed[z][t]  = true;
          }
        }
      }
    }
}
