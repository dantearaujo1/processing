Snake cobra;
Food objective;

boolean gameRunning;
boolean menu;

void setup(){
  size(800,800);
  cobra = new Snake(color(255,0,0), 40);
  objective = new Food(1,40,40,40);
  objective.spaw();
  gameRunning = true;
}


void draw(){

  frameRate(12);
  background(0);

  // Draw some tiles for positioning
  /* for (int x = 0; x < floor(width/40); x++){ */
  /*   for (int y = 0; y < floor(height/40); y++){ */
  /*     noFill(); */
  /*     stroke(255); */
  /*     rect(x*40,y*40,40,40); */
  /*   } */
  /* } */
  /* noStroke(); */


  if (gameRunning){
    cobra.update(objective);
    objective.draw();
    cobra.draw();
    fill(255);
    textSize(50);
    text(cobra.points,60,75);
  }
  else{
    text("Game Over", width/2 - textWidth("Game Over")/2, height/2);
    text("Press Enter to Restart", width/2 - textWidth("Press Enter to Restart")/2, height/2 + 2*height/16);
    text("Points: " + cobra.points, width/2 - textWidth("Points:  ")/2, height/2 + height/16);
  }
}

void restart(Snake cobra, Food comida){
  cobra.tail_x.clear();
  cobra.tail_y.clear();
  cobra.points = 0;
  cobra.velx = 1;
  cobra.vely = 0;
  cobra.posx = floor(random(width/cobra.tamanho));
  cobra.posy = floor(random(height/cobra.tamanho));
  comida.spaw();
  gameRunning = true;

}
void gameOver(){
  gameRunning = false;
}

void keyPressed(){
  if (key == 'a'){
    cobra.setDirection(2);
  }
  if (key == 'd'){
    cobra.setDirection(1);
  }
  if (key == 'w'){
    cobra.setDirection(4);
  }
  if (key == 's'){
    cobra.setDirection(3);
  }
  if (key == char(10)){
    restart(cobra,objective);
  }
}

class Food{

  int posx;
  int posy;
  int side;
  color cor;

  Food(color cor, int x, int y, int side){
    this.cor = cor;
    this.posx = x;
    this.posy = y;
    this.side = side;
  }

  void draw() {
    fill(this.cor);
    rect(this.posx * this.side,this.posy * this.side, this.side, this.side);
  }

  void spaw(){
    int x = floor(random(width)/this.side);
    int y = floor(random(height)/this.side);
    float r = random(255);
    float g = random(255);
    float b = random(255);
    this.posx = x;
    this.posy = y;
    this.cor = color(r,g,b);
  }
}

class Snake {

  IntList tail_x;
  IntList tail_y;
  IntList tail_color;
  color cor;
  int tamanho;
  int posx;
  int posy;
  int velx;
  int vely;
  int velocity;
  int points;

  Snake (color cor, int l_tamanho) {
    this.cor = cor;
    this.tamanho = l_tamanho;
    this.posx = floor(random(width)/this.tamanho);;
    this.posy = floor(random(height)/this.tamanho);;
    this.velocity = 1;
    this.velx = 1;
    this.vely = 0;
    this.points = 0;
    this.tail_x = new IntList(this.posx);
    this.tail_y = new IntList(this.posy);
    this.tail_color = new IntList();
  }

  void update(Food myfood){

    for (int i = this.tail_x.size() - 1; i > 0; i--){
      tail_y.set(i, this.tail_y.get(i-1));
      tail_x.set(i, this.tail_x.get(i-1));
    }
    if (tail_x.size() >= 1){
      tail_x.set(0, this.posx);
      tail_y.set(0, this.posy);
    }

    this.posx += this.velx;
    this.posy += this.vely;

    // Checking collision with bounds of window
    if (this.posx + 1 > width/this.tamanho){
      gameOver();
    }
    if (this.posy + 1 > height/this.tamanho){
      gameOver();
    }
    if (this.posx < 0){
      gameOver();
    }
    if (this.posy < 0){
      gameOver();
    }

    // Checking collision with own body parts
    for (int i = 0; i < this.tail_x.size(); i++){
      if ( this.posx == this.tail_x.get(i) && this.posy == this.tail_y.get(i) ){
        gameOver();
      }
    }


    if (intersectSimple(myfood)){
      this.eat(myfood);
      myfood.spaw();
    }
  }


  void reset(){
    this.tail_x.clear();
    this.tail_y.clear();
    this.points = 0;
    this.posx = floor(random(width)/this.tamanho);;
    this.posy = floor(random(height)/this.tamanho);;
  }


  boolean intersectSimple(Food myfood){
    if (this.posx > myfood.posx || myfood.posx > this.posx){
      return false;
    }
    else if (this.posy > myfood.posy || myfood.posy > this.posy){
      return false;
    }
    else {
      return true;
    }
  }

  /* boolean intersect(Food myfood){ */
  /*   if (this.posx > myfood.posx + myfood.side || myfood.posx > this.posx + this.tamanho){ */
  /*     return false; */
  /*   } */
  /*   else if (this.posy > myfood.posy + myfood.side || myfood.posy > this.posy + this.tamanho){ */
  /*     return false; */
  /*   } */
  /*   else { */
  /*     return true; */
  /*   } */
  /* } */

  void draw(){
    for (int i = 0; i < this.tail_x.size(); i++){
      fill(this.tail_color.get(i));
      rect(this.tail_x.get(i) * this.tamanho , this.tail_y.get(i) * this.tamanho, this.tamanho, this.tamanho);
    }
    fill(this.cor);
    rect(this.posx * this.tamanho,this.posy * this.tamanho,this.tamanho, this.tamanho);
  }

  void setDirection(int n){
    if (n == 1){
      if(this.velx == -this.velocity){
        return;
      }
      this.velx = this.velocity;
      this.vely = 0;
    }
    if (n == 2){
      if(this.velx == this.velocity){
        return;
      }
      this.velx = -this.velocity;
      this.vely = 0;
    }
    if (n == 3){
      if(this.vely == -this.velocity){
        return;
      }
      this.vely = this.velocity;
      this.velx = 0;
    }
    if (n == 4){
      if(this.vely == this.velocity){
        return;
      }
      this.vely = -this.velocity;
      this.velx = 0;
    }
  }

  void eat(Food l_food){
      this.points += 1;
      tail_x.append(this.posx);
      tail_y.append(this.posy);
      tail_color.append(l_food.cor);
  }

}
