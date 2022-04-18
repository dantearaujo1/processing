//Imports
import controlP5.*;
import processing.sound.*;

// Inputs
int playerOption = -1;
int cpuOption = -1;

//sounds
SoundFile backgroundMusic;
SoundFile clickSound;
SoundFile optionSound;
HashMap<String,SoundFile> sounds = new HashMap<String,SoundFile>();

//Shaders?
PShader rainbow;

//GUI
ControlP5 playControl;
ControlP5 menuControl;
String resultText;
int nButtons = 5;
int buttonsVariables = 4;
float[][] buttons = new float[nButtons][];

// Animation variables
int accumulator = 0;
int lastTime = 0;
int newTime = 0;
int deltaTime = 0;
int delayTime = 500;
int totalWaitTime = 0;


// Images Frames (CENTERED POINTS)
float playerImgX;
float playerImgY;
float playerImgWidth;
float playerImgHeight;
float cpuImgX;
float cpuImgY;
HashMap<Integer,PImage> images = new HashMap<Integer,PImage>();
/* PImage playerImage; */
/* PImage cpuImage; */
int playerImage;
int cpuImage;

//Options
int spock = 1;
int scissors = 2;
int paper = 3;
int rock = 4;
int lizard = 5;
int result = 0;
int winner = 0;
int loser = 0;

HashMap<Integer,String> results = new HashMap<Integer,String>();

//States Variables
boolean menu = true;
boolean play = false;
boolean restart = false;
boolean playerOK = false;
boolean animate = false;
boolean debug = false;

void setup(){

  size(800,600);

  loadSounds();
  backgroundMusic = sounds.get("play_background");
  backgroundMusic.loop();
  loadImages();
  loadResults();

  populateButtons();

  createMenuGUI();
  createGameGUI();


  /* playerImage = images.get(0); */
  /* cpuImage = images.get(-1); */
  playerImage = 0;
  playerImage = -1;
  resultText = "Choose your Option!";

}

void draw(){

  newTime = millis();
  deltaTime = newTime - lastTime;
  lastTime = newTime;

  background(0);
  if (menu){
      playControl.hide();
      menuControl.show();
      drawMenuGUI();
  }
  else if (play){
    playControl.show();
    menuControl.hide();
    handleGameEvents();
    drawGameGUI();
  }
}

void handleGameEvents(){
  if(!playerOK){

    if(playControl.get("Spock").isMouseOver()){

      playerImage = spock;

    }

    else if(playControl.get("Scissors").isMouseOver()){

      playerImage = scissors;

    }

    else if(playControl.get("Paper").isMouseOver()){

      playerImage = paper;
    }

    else if(playControl.get("Rock").isMouseOver()){

      playerImage = rock;

    }

    else if(playControl.get("Lizard").isMouseOver()){

      playerImage = lizard;

    }
    else {
        playerImage = 0;
        cpuImage = -1;
    }

  }
  else{

  }
}

int getCpuOption(){

  int value = 0;
  for (int time = 0; time < int(random(1,6)); time++){
    value = int(random(1,6));
    cpuImage = value;
  }
  return value;

}

void animateCPU(){
  if (animate){

    // Setting the correct image from getWinner()
    int correctImage = cpuOption; // This may be a problem

    textAlign(CENTER);
    fill(255);
    textSize(24);
    text("Randomizing CPU turn....", 0.5 * width, 0.62 * height);
    fill(0);

    accumulator += deltaTime; // Start the animation clock

    if (accumulator >= delayTime) { // Wait delay time seconds
      cpuImage = getCpuOption();
      accumulator -= delayTime;
      totalWaitTime -= delayTime;
    }

    if (totalWaitTime <= 0){
      animate = false;
      cpuImage = correctImage;

      if (playerOption < cpuOption){
        resultText += " " + results.get(playerOption*10+result);
      }
      else if (playerOption > cpuOption){
        resultText += " " + results.get(cpuOption*10+result);
      }

    }
  }
}

void getWinner(){
  // Setting the correct states
  animate = true;
  playerOK = true;

  // Getting result
  cpuOption = getCpuOption();
  totalWaitTime = cpuOption * delayTime; // This function should have animation logic?

  // Logic for the winner
  /* int result = playerOption + cpuOption; */
  if (playerOption > cpuOption){
    result = playerOption - cpuOption;
    if(result == 1 || result == 3){
      resultText = "You lose!";
    }
    else{
      resultText = "You win!";
    }
  }
  else{
    result = cpuOption - playerOption;
    if(result == 1 || result == 3){
      resultText = "You win!";
    }
    else{
      resultText = "You lose!";
    }
  }

  if (result == 0){
    resultText = "It's a draw!";
  }
}

// ===========================================================================
// These functions gets called when a button is pressed!
// ===========================================================================
void Spock(){
  if(!playerOK){
    optionSound = sounds.get("spock");
    optionSound.play();
    playerOption = 1;
    getWinner();
  }
}
void Scissors(){
  if(!playerOK){
    optionSound = sounds.get("scissors");
    optionSound.play();
    playerOption = 2;
    getWinner();
  }
}

void Paper(){
  if(!playerOK){
    optionSound = sounds.get("paper");
    optionSound.play();
    playerOption = 3;
    getWinner();
  }
}

void Rock(){
  if(!playerOK){
    optionSound = sounds.get("rock");
    optionSound.play();
    playerOption = 4;
    getWinner();
  }
}

void Lizard(){
  if(!playerOK){
    optionSound = sounds.get("lizard");
    optionSound.play();
    playerOption = 5;
    cpuOption = getCpuOption();
    getWinner();
  }
}
void Play(){
  menu = false;
  play = true;
}

void Exit(){
  exit();
}

void Restart(){
  playerOK = false;
  animate = false;
  playerImage = 0;
  playerImage = -1;
  resultText = "Choose your Option!";
}
// ===========================================================================
// ===========================================================================

// This is for storing data for placement and size of buttons for further checking
void populateButtons(){

  playerImgX = 0.25 * width;
  playerImgY = 0.30 * height;
  playerImgWidth = 0.375 * width;
  playerImgHeight = 0.5 * height;
  cpuImgX =  0.75 * width;
  cpuImgY = 0.3 * height;

  for (int btn = 0; btn < nButtons; btn++){
      buttons[btn] = new float[buttonsVariables];
      buttons[btn][0] = 0.225 * width + 0.10 * width * btn;
      buttons[btn][2] = 0.1625 * width; // width buttons variable
      buttons[btn][3] = 0.05 * height; // height buttons variable
      if (btn % 2 == 1){
        buttons[btn][1] = 0.67 * height; // Y buttons variable
      }
      else{
        buttons[btn][1] = 0.77 * height;
      }
    }
}

void mousePressed(){
  if (mouseButton == LEFT) clickSound.play();
  if (mouseButton == RIGHT) Restart();
}

void createMenuGUI(){
  if (menuControl == null){
    menuControl = new ControlP5(this);
  }
  menuControl.addButton(this,"Play")
              .setSize((int)(0.125*width),(int)(0.0625*height))
              .setPosition(0.5 * width - menuControl.get("Play").getWidth()/2, 0.5 * height);
  menuControl.addButton("Exit")
              .setSize((int)(0.125*width),(int)(0.0625*height))
              .setPosition(0.5 * width - menuControl.get("Exit").getWidth()/2, 0.5 * height + menuControl.get("Exit").getHeight());
}

void drawMenuGUI(){
      textSize(50);
      textAlign(CENTER);
      text("SMD - TAREFA 3", 0.5 * width, 0.25 * height);
      textSize(25);
      text("Dante de Araújo", 0.5 * width, 0.30 * height);
      textSize(12);
}

// This is a generate GUI function using ControlP5 Library and populateButtons data stored in buttons variable
void createGameGUI(){
  if (playControl == null){
    playControl = new ControlP5(this);
  }


  playControl.getFont().setSize(18);
  // After doing this i asked me whats the point of it? i could simple write playControl.addButton for each button
  for (int btn = 0; btn < nButtons; btn++){
    switch (btn){
      case 0:
        playControl.addButton(this,"Spock")
          .setPosition(buttons[btn][0],buttons[btn][1])
          .changeValue(0) // this is an option to setValue since it doensn't call Spock() in setup();
          .setSize((int)buttons[btn][2],(int)buttons[btn][3]);
        break;
      case 1:
        playControl.addButton(this,"Scissors")
          .setPosition(buttons[btn][0],buttons[btn][1])
          .setSize((int)buttons[btn][2],(int)buttons[btn][3]);
        break;
      case 2:
        playControl.addButton(this,"Paper")
          .setPosition(buttons[btn][0],buttons[btn][1])
          .setSize((int)buttons[btn][2],(int)buttons[btn][3]);
        break;
      case 3:
        playControl.addButton(this,"Rock")
          .setPosition(buttons[btn][0],buttons[btn][1])
          .setSize((int)buttons[btn][2],(int)buttons[btn][3]);
        break;
      case 4:
        playControl.addButton(this,"Lizard")
          .setPosition(buttons[btn][0],buttons[btn][1])
          .setSize((int)buttons[btn][2],(int)buttons[btn][3]);
        break;
      default:
        break;
    }
  }
  playControl.addButton(this,"Restart")
              .setPosition(0.82 * width, 0.9 * height)
              .setSize(int(buttons[0][2]),int(buttons[0][3]));
  playControl.addButton(this,"Exit")
              .setPosition(0.63 * width, 0.9 * height)
              .setSize(int(buttons[0][2]),int(buttons[0][3]));
}
void drawGameGUI(){
      noFill();
      strokeWeight(3.0);
      strokeJoin(BEVEL);
      stroke(122,122,122);
      imageMode(CENTER);
      rectMode(CENTER);

      animateCPU(); // this is going to be the update of cpuImage data

      if(images.get(playerImage) != null){
        rect(playerImgX, playerImgY, playerImgWidth, playerImgHeight);
        image(images.get(playerImage), playerImgX, playerImgY, playerImgWidth, playerImgHeight);
      }
      if(images.get(cpuImage) != null){
        rect(cpuImgX, cpuImgY, playerImgWidth, playerImgHeight);
        image(images.get(cpuImage), cpuImgX, cpuImgY, playerImgWidth, playerImgHeight);
      }

      if(playerOK){
        playControl.getController("Restart").show();
        playControl.getController("Exit").show();
      }
      else{
        playControl.getController("Exit").hide();
        playControl.getController("Restart").hide();
      }

      textAlign(CENTER);
      textSize(24);
      if (!animate) text(resultText, 0.5 * width , 0.62 * height);
      textSize(12);
      textAlign(LEFT);

      if(debug){
        fill(255,0,0);
        text("PlayerOption: " + playerOption, 20, 20 );
        text("CpuOption: " + cpuOption, 20, 40 );
        text("Result: " + result, 20, 60 );
        if (playerOption < cpuOption){
          text("Mapping: " + (playerOption*10 + result), 20, 80 );
        }
        else if (playerOption > cpuOption){
          text("Mapping: " + (cpuOption*10 + result), 20, 80 );
        }
        fill(255);
      }

}

void keyPressed(){
  if(key == 'd'){
    debug = !debug;
  }
}


void loadImages(){

  images.put(spock,loadImage("spock.png","png"));
  images.put(scissors,loadImage("scissor.png","png"));
  images.put(paper,loadImage("paper.png","png"));
  images.put(rock,loadImage("rock.png","png"));
  images.put(lizard,loadImage("lizard.png","png"));
  images.put(0,loadImage("choice.png"));
  images.put(-1,loadImage("robot.png"));

}

void loadSounds(){

  sounds.put("play_background",new SoundFile(this, "game_sound.mp3"));
  sounds.put("spock",new SoundFile(this, "spock.wav"));
  sounds.put("rock",new SoundFile(this, "rock.wav"));
  sounds.put("lizard",new SoundFile(this, "lizard.wav"));
  sounds.put("paper",new SoundFile(this, "paper.wav"));
  sounds.put("scissors",new SoundFile(this, "scissors2.wav"));
  sounds.put("click",new SoundFile(this, "click.wav"));

  clickSound = sounds.get("click");
}

void loadResults(){
  results.put(11,"Spock smashes Scissors");
  results.put(13,"Spock vaporizes Rock");
  results.put(21,"Scissors cuts Paper");
  results.put(23,"Scissors decapitates Lizard");
  results.put(31,"Paper covers Rock");
  results.put(12,"Paper disproves Spock");
  results.put(41,"Rock crushes Lizard");
  results.put(14,"Lizard poisons Spock");

  // I entered these numbers to be in the correct logic for resultText append
  results.put(22,"Rock crushes Scissors");
  results.put(32,"Lizard eats Paper");

}
