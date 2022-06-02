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
boolean CollisionRP(float x1,float y1,float w1, float h1,float xp, float yp){
  if(x1 + w1 < xp || x1 > xp){
    return false;
  }
  if(y1 + h1 < yp || y1 > yp){
    return false;
  }
  return true;
}

boolean CollisionCC(float cx1,float cy1, float r1, float cx2, float cy2, float r2){
    float dist = dist(cx1,cy1,cx2,cy2);

    if (dist < r1 + r2){
      return true;
    }
    else {
      return false;
    }
}
boolean CollisionCP(float cx1,float cy1, float r1, float x, float y){
    float dist = dist(cx1,cy1,x,y);

    if (dist < r1){
      return true;
    }
    else {
      return false;
    }
}

boolean CollisionPTrapeze(float px, float py, float angle, Vector[] pPoints){
  // Basicamente checar se px está entre duas linhas de mesma altura porem
  // anguladas e py está entre duas linhas horizontais de tamanhos diferentes
  // e px está entre duas linhas linhas angulares

  // Se px for menor que offsetPx1 ta na esquerda e fora
  // Se px for maior que offsetPx1 e menor que offsetPx2 ta dentro
  // Se px for maior que offsetPx1 e offsetPx2 ta na direita e fora
  // OffsetPx1 é o cateto oposto do triangulo ponto[0]hb
  // OffsetPx1 é o cateto oposto do triangulo ponto[3]ad
  // Temos a altura e o angulo de rotação podemos achar offsetPx1 utilizando
  // tan(angulo) * altura = offset
  // no caso de de offsetPx1 soma-se offsetPx1 ao ponto[0].x e chegamos ai ponto que queremos
  // no caso de de offsetPx2 subtrai-se offsetPx1 ao ponto[3].x e chegamos ai ponto que queremos
  float distV = pPoints[0].m_y - py;
  if(distV < 0 || distV > pPoints[0].m_y - pPoints[1].m_y){
    return false;
  }
  float offset = distV * tan(radians(angle));
  return (px >= pPoints[0].m_x + offset && px <= pPoints[3].m_x - offset);
}

boolean OnStraightSegment(float xi , float xn, float xf){
  return (xn <= max(xi,xf) && xn >= min(xi,xf));
}

