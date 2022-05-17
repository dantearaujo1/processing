/*  RealTennis for Atari 2600
    This is the main entry point for the game
    just setup functions and our "gameLoop"
*/

boolean CollisionCR(float cx, float cy, float r, float x, float y, float w, float h){
  float testX = cx;
  float testY = cy;
  
  if(cx<x) testX = x;
  else if (cx>x+w) testX = x+w;
  
  if(cy<y) testY = y;
  else if (cy>y+h) testY = y+h;
  
  float dist = dist(cx,cy,testX,testY);
  if (dist < r){
    return true;
  }
  return false;
  
}

boolean CollisionRR(float x1,float y1,float w1, float h1,float x2,float y2, float w2, float h2){
  if(x1 + w1 < x2 || x1 > x2 + w2){
    return false;
  }
  if(y1 + h1 < y2 || y1 > y2 + h2){
    return false;
  }
  return true;
}
