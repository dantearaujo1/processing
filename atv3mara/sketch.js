//States
let state;
let animationState;
let endingAnimationState;

//Clock
let applicationTime;
//Labels
let label_titulo;
let tSize;
let trab1Text;
let trab2Text;

//Buttons
let bIniciar;
let bJob1;
let bJob2;
let bSair;
let bVoltar;

//Images
let image1;
let image2;
let image3;

let opacity;

//Variables

let xpos1;
let xpos2;
let ypos1;
let ypos2;
let speed;
let arcMovement;

function preload(){
  loadImages();
}


function setup() {
  createCanvas(800, 800);
  // createCanvas(windowWidth/2, windowHeight);
  state = 0;
  opacity = 0;
  animationState = true;
  endingAnimationState = false;
  applicationTime = millis();
  loadLabels();
  loadButtons();
  loadVelocity();
}

function loadImages(){
  image1 = new Image();
  image1.src = "assets/be.png"
  image2 = new Image();
  image2.src = "assets/lm.png"
  image3 = new Image();
  image3.src = "assets/cenario.jpg"
}

function loadVelocity(){
  xpos1 = width/4;
  xpos2 = width/2 + width/4;
  ypos1 = height/2;
  ypos2 = height/2;
  speed = 5;
  arcMovement = 0;
}



function loadButtons(){
  bIniciar = new Clickable();
  bIniciar.locate( width/10, height - height/10 - bIniciar.height/2 - bIniciar.height/5);
  bIniciar.text = "Iniciar";
  bJob1 = new Clickable();
  bJob1.text = "Trabalho 1";
  bJob1.locate(width/2 - 2*bJob1.width, height/2 - bJob1.height/2)
  bJob2 = new Clickable();
  bJob2.text = "Trabalho 2";
  bJob2.locate(width/2 + bJob2.width, height/2 - bJob2.height/2)
  bSair = new Clickable();
  bSair.text = "Sair"
  bSair.locate(width/2 , height - height/10 - bSair.height/2)
  bVoltar = new Clickable();
  bVoltar.text = "Voltar"
  bVoltar.locate(width - bVoltar.width, height - height/10 - bVoltar.height/2)
}

function loadLabels(){
  label_titulo = "Atividade 03 - Trabalho";
  tSize = 1;
  trab1Text = "Atividade número 06 de Desenho, desenhar um personagem usando uma paleta de cores análogas entre si, o desenho deveria ser original, porém podia ser personagens existentes, o desenho poderia tanto ser digital como manual. Escolhi o Bob Esponja por ter as cores parecidas com as que o professor utilizou nos exemplos"
  trab2Text = "Atividade número 07 de Desenho, utilizar cores complementares em relação a atividade número 06, o desenho deveria ser feito em pixel art e com cores análogas entre si. Para isto escolhi fazer um cenário com o Lula Molusco visto que as cores se encaixavam dentro do pedido."
}

function draw() {
  applicationTime = millis();
  buttonsColors();
  switch(state) {
    case 0:
      drawInit();
      logicInit();
      break;
    case 1:
      drawMenu();
      logicMenu();
      break;
    case 2:
      drawJob1();
      logicJob1();
      break;
    case 3:
      drawJob2();
      logicJob2();
      break;
    case 4:
      drawEnding();
      logicEnding();
      break;
    default:
      break;
  }
}


function drawInit(){
  background(0);
  fill(255);
  textSize(24);
  text("Dante de Araújo Clementino", width - textWidth("Dante de Araújo Clementino") - width/20, height - height/10);
  textSize(tSize);
  text(label_titulo, width/2 - textWidth(label_titulo)/2, height/2);

  if (applicationTime/1000 >= 3.0 && applicationTime/1000 <= 4.0){
    push();
    tSize++;
    pop();
  }
  push();
  bIniciar.draw();
  pop();
}
function logicInit(){
  if (applicationTime/1000 >= 4.0){
    animationState = false;
  }
  if (animationState == false){
    bIniciar.onPress = function() {
      state = 1;
    }
  }
}


function drawMenu(){
  background(0,0,70);
  bJob1.draw();
  bJob2.draw();
  bSair.draw();
  bSair.locate(width/2 - bSair.width/2, height/2 + height/10 - bVoltar.height/2)

}

function logicMenu(){
  bJob1.onPress = function(){
    state=2;
  }
  bJob2.onPress = function(){
    state=3;
  }
  bSair.onPress = function(){
    state = 4;
    label_titulo = "Boas Férias!"
    endingAnimationState = true;
    tSize = 32;
  }

}

function drawJob1(){
  background(0,122,0);
  push();
  bVoltar.draw();
  bVoltar.locate(width/10 , height - height/10 - bVoltar.height/2)
  bSair.draw();
  bSair.locate(width/10 + width/5, height - height/10 - bVoltar.height/2)
  drawingContext.drawImage(image1, width/2, 0, width/2, height);
  drawingContext.scale(-5,1);
  pop();
  textSize(width/50);
  textWrap(WORD);
  textAlign(LEFT);
  text(trab1Text, 0 + width/10, 0 + width/5, width/3);
}

function logicJob1(){
  bVoltar.onPress = function(){
    state = 1;
  }
  bSair.onPress = function(){
    state = 4;
    label_titulo = "Boas Férias!"
    endingAnimationState = true;
    tSize = 32;
  }
}

function drawJob2(){
  background(0,122,122);
  push();
  bVoltar.draw();
  bVoltar.locate(width/2 + bVoltar.width, height - height/10 - bVoltar.height/2)
  bSair.draw();
  bSair.locate(width - width/5, height - height/10 - bVoltar.height/2)
  drawingContext.drawImage(image2, 0, 0, width/2, height);
  pop();
  textSize(width/50);
  textWrap(WORD);
  textAlign(LEFT);
  text(trab2Text, width/2 + width/10, 0 + width/5, width/3);
}
function logicJob2(){
  bVoltar.onPress = function(){
    state = 1;
  }
  bSair.onPress = function(){
    state = 4;
    label_titulo = "Boas Férias!"
    endingAnimationState = true;
    tSize = 32;
  }

}

function drawEnding(){
  background(255);
  drawingContext.drawImage(image3, 0, 0, width, height);
  fill(0,0,0,opacity);
  textSize(tSize);
  text(label_titulo, width/2 - textWidth(label_titulo)/2, height/2 - height/4);
  drawBall(xpos1, ypos1, color(0,122,0),0);
  drawBall(xpos2, ypos2, color(0,0,180),1);

}

function logicEnding(){
  if (endingAnimationState){
    if(opacity < 255){
      opacity++;

    }
    else{
      opacity = 255;
    }
  }
  CirclePatternMovement();
  StarPatternMovement();

}


function buttonsColors(){
  bVoltar.onOutside = function(){
    bVoltar.color = "#FFFFFF";
  }
  bVoltar.onHover = function(){
    bVoltar.color = "#AAFFAA";
  }
  bSair.onHover = function(){
    bSair.color = "#AAFFAA";
  }
  bSair.onOutside = function(){
    bSair.color = "#FFFFFF";
  }
  bIniciar.onOutside = function(){
    bIniciar.color = "#FFFFFF";
  }
  bIniciar.onHover = function(){
    bIniciar.color = "#AAFFAA";
  }
  bJob1.onOutside = function(){
    bJob1.color = "#FFFFFF";
  }
  bJob1.onHover = function(){
    bJob1.color = "#AAFFAA";
  }
  bJob2.onOutside = function(){
    bJob2.color = "#FFFFFF";
  }
  bJob2.onHover = function(){
    bJob2.color = "#AAFFAA";
  }

}

function drawBall(x,y,color, option){
  fill(color);
  circle(x,y,width/10);
  fill(255);
  circle(x + width/40,y - height/100,width/60);
  circle(x - width/40,y - height/100,width/60);
  fill(0);
  circle(x + width/40 + width/320,y - height/100,width/120);
  circle(x - width/40 - width/320,y - height/100,width/120);
  if (option == 0 ){
    fill(255,0,0);
    circle(x,y + height/100,width/120);
  }
  if (option == 1 ){
    fill(0);
    circle(x,y + height/100,width/120);
  }
}

function CirclePatternMovement(x,y){
  xpos1 = width/2 - width/4 + cos(arcMovement) * width/20;
  ypos1 = height/2 + sin(arcMovement) * width/20;

  arcMovement = arcMovement + 0.01;
  if (arcMovement > TWO_PI){
    arcMovement = 0;
  }
}

function StarPatternMovement(){
  xpos2 += speed;

  if (xpos2 >= width - width/10){
    speed = -speed;
  }
  if (xpos2 <= width/2 + width/10){
    speed = -speed;
  }

}
