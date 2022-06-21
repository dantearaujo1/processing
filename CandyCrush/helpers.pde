  int convert2Dto1D(PVector v){
    return int(v.x + v.y * BOARD_COLUMNS);
  }
  PVector convert1Dto2D(int v){
    return new PVector(v % BOARD_COLUMNS, v / BOARD_COLUMNS);
  }
  Candy getCandy(int position, Candy[][] b){
    if(position >= 0 && position < BOARD_COLUMNS * BOARD_ROWS){
      PVector pos = convert1Dto2D(position);
      return b[int(pos.y)][int(pos.x)];
    }
    return null;
  }
  Candy getCandy(int gridX, int gridY, Candy[][] b){
    if(gridX < BOARD_COLUMNS  && gridX >= 0 && gridY < BOARD_ROWS && gridY >= 0){
      return b[gridY][gridX];
    }
    return null;
  }

  int offset(int pos, String direction, int WIDTH){
    switch(direction){
      case "North":
        return pos - WIDTH;
      case "South":
        return pos + WIDTH;
      case "East":
        return pos - 1;
      case "West":
        return pos + 1;
      default:
        return 0;
    }
  }
  PVector offset(int px, int py, String direction){
    switch(direction){
      case "North":
        return new PVector(px,px-1);
      case "South":
        return new PVector(px,py+1);
      case "East":
        return new PVector(px-1,py);
      case "West":
        return new PVector(px+1,py);
      default:
        return new PVector();
    }
  }

  float interpolation(float st, float end, float percentage){
    return (st + (end - st) * percentage);
  }

  float flip(float percentage){
    return 1 - percentage;
  }
  float easeIn(float x){
    return x * x;
  }
  float easeOut(float x){
    return flip(easeIn(flip(x)));
  }
