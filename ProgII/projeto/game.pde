
class Game{
  GAME_STATES     m_states;
  Ball            m_ball;
  Player[]        m_players;
  Court           m_court;
  Net             m_net;
  int             m_activePlayers;
  int             m_menuChoice;

  InputContext[]  m_contexts;

  float           m_currentTime;
  float           m_deltaTime;
  float           m_lastTime;

  String          m_scoreText;
  String          m_gameTitle;;

  boolean         m_debug;

  GAME_STATES     m_state;

  Game(){
    init();
  }

  void init(){
    m_deltaTime =     0.0f;
    m_currentTime =   0.0f;
    m_lastTime =      0.0f;
    m_activePlayers = 0;
    m_court =         new Court();
    m_ball =          new Ball(0,0,15);
    m_players =       new Player[4];
    m_contexts =      new InputContext[10];
    m_gameTitle =     "Tennis Atari 2600";
    for(int i = 1; i <= PLAYERS_PLAYING; i++){
      if(i % 2 == 0){
        m_players[i-1] =    new Player(0,0,i,1);
      }
      else{
        m_players[i-1] =    new Player(0,0,i,2);
      }
      m_activePlayers++;

    }
    m_players[1].setColor(0,color(255,0,0));
    m_players[1].setColor(1,color(134,50,200));
    m_players[1].setColor(2,color(0,255,0));
    m_net =         m_court.getNet();
    m_state =       GAME_STATES.GAME_MENU;
    m_debug =       false;

    initControllerContexts();
    loadController("controller.dante");
    startServe(m_players[0],m_players[1],m_ball);

  }
  void initControllerContexts(){
    // from 0 to 3 are players contexts
    // 1 context for debug = 4 contexts;
    for (int i = 0; i < 5; i++){
      m_contexts[i] = new InputContext(g_keyboard);
    }
    g_inputManager.addContext(m_players[0].m_name,m_contexts[0]);
    g_inputManager.addContext(m_players[1].m_name,m_contexts[1]);
    g_inputManager.addContext("Debug",m_contexts[4]);
  }

  void loadController(String inputConfig){
    InputManager input = g_inputManager;
    String[] lines = loadStrings(inputConfig);
    String context = "";
    String keyStr = "";
    String valueStr = "";
    String typeStr = "";
    for (int i = 0; i < lines.length; i++){
      String[] words = split(lines[i], ' ');
      if(words.length <= 2){
        context = lines[i];
        continue;
      }
      if(words.length >= 4){
        keyStr = words[0] + " " + words[1];
        valueStr = words[2];
        typeStr = words[3];
      }
      else{
        keyStr = words[0];
        valueStr = words[1];
        typeStr = words[2];
      }
      if(valueStr.equals("space")) valueStr = " ";
      char[] c = valueStr.toCharArray();
      println(context + "," + keyStr + "," + valueStr + "," + typeStr + "," + c[0] );
      if (typeStr.equals("ACTION")){
        input.getContext(context).mapAction(keyStr,c[0]);
      }
      else{
        input.getContext(context).mapState(keyStr,c[0]);
      }
    }
  }


  void updateMenu(){
    if(CollisionRP(float(width/2 - 30), float(height/2 + 50), float(60),float(30),float(mouseX),float(mouseY))){
      m_menuChoice = 1;
    }
    else if(CollisionRP(float(width/2 - 30), float(height/2 + 90), float(60),float(30),float(mouseX),float(mouseY))){
      m_menuChoice = 2;
    }
    else{
      m_menuChoice = 0;
    }

    if(mouseButton == LEFT && mousePressed){
      switch(m_menuChoice){
        case 0:
          break;
        case 1:
          setState(GAME_STATES.GAME_SERVE);
          break;
        case 2:
          exit();
          break;
        default:
          break;
      }
    }
  }
  void updateGame(){
    m_currentTime = millis()/1000.0f;
    m_deltaTime += m_currentTime - m_lastTime;
    m_lastTime = m_currentTime;

    if (m_deltaTime >= DT){
      if(m_state == GAME_STATES.GAME_MENU){

      }
      else{
        m_deltaTime -= DT;
        m_ball.update(this,m_court,m_net);

        for (int player = 0; player < m_activePlayers; player++){
          Player p = m_players[player];
          if(p != null){
            p.handleInput(this);
            p.update(this,m_court,m_net);
          }
        }

        if(shouldGivePoint()){
          setState(GAME_STATES.GAME_POINT);
          setPoint(m_players[0],m_players[1],m_ball);
          startServe(m_players[0],m_players[1],m_ball);
        }
      }
    }
    g_keyboard.update();

  }

  void drawGame(){
    m_court.draw();
    // Should draw Player 2 and 4 if they exist
    if(m_players[1] != null) m_players[1].draw();
    if(m_players[3] != null)m_players[3].draw();
    if (m_ball.getSide() == 1){
      m_ball.draw();
      m_court.drawNet();
    }
    else {
      m_court.drawNet();
      m_ball.draw();
    }
    // Should draw Player 1 and 3if they exist
    if(m_players[0] != null)m_players[0].draw();
    if(m_players[2] != null)m_players[2].draw();

  }
  void drawMenu(){
    fill(150,150,0);
    textSize(46);
    text(m_gameTitle,width/2 - textWidth(m_gameTitle)/2, height/2 - 100);

    // Button - Start
    fill(180);
    rect(width/2 - 30, height/2 + 50, 60,30);
    textSize(16);
    fill(16);
    text("Start",width/2 - 15, height/2 + 50 + 20);
    // Button - Exit
    fill(180);
    rect(width/2 - 30, height/2 + 90, 60,30);
    textSize(16);
    fill(16);
    text("Exit",width/2 - 15, height/2 + 90 + 20);
    /* text("" + m_state,10,10); */
    /* text("" + m_menuChoice,10,25); */
  }

  void run(){
    if(m_state == GAME_STATES.GAME_MENU){
      updateMenu();
      drawMenu();
    }
    else{
      updateGame();
      drawGame();
      drawGUI();
    }
  }

  void drawGUI(){
    textSize(36);
    fill(255,255,0);
    m_scoreText = int(m_players[0].m_score) + " : " + int(m_players[1].m_score );
    text(m_scoreText, width/2 - textWidth(m_scoreText)/2, textDescent() + textAscent());
    textSize(12);
    if(m_debug){
      fill(0,255,0);
      text("CurrentTime: " + m_currentTime , 0,15);
      text("DeltaTime: " + m_deltaTime , 0,30);
      text("Game State: " + m_state , 0,45);
      for (int i = 0; i < m_players.length; i++){
        Player p = m_players[i];
        if(p != null){
          p.drawDebug(0 + 150 * i, 625);
        }
      }

    }
  }

  // Helpers
  Ball getBall(){
    return m_ball;
  }
  Court getCourt(){
    return m_court;
  }
  Player getPlayerServing(){
    int pId = 0;
    for(int p = 0; p <m_players.length; p++){
      if(m_players[p] != null){
        if (m_players[p].getServeStatus()){
          pId = p;
          break;
        }
      }
    }
    return m_players[pId];
  }
  Player getPlayerRecieving(){
    int pId = 0;
    for(int p = 0; p <m_players.length; p++){
      if(m_players[p] != null){
        if (m_players[p].getRecieverStatus()){
          pId = p;
          break;
        }
      }
    }
    return m_players[pId];
  }
  Player getPlayer(int id){
    if (id > 0 && id < 5){
      return m_players[id-1];
    }
    return m_players[0];
  }

  int getPlayersLength(){
    return m_players.length;
  }
  void setState(GAME_STATES state){
    m_state = state;
  }
  boolean shouldStartServing(){
    return (m_state == GAME_STATES.GAME_SERVE);
  }
  boolean isServing(){
    return (m_state == GAME_STATES.GAME_SERVING);
  }
  boolean isInGame(){
    return (m_state == GAME_STATES.GAME_PLAYING);
  }
  boolean shouldGivePoint(){
    return (m_ball.hasEnd());
  }
  void changeDebug(){
    m_debug =! m_debug;
  }
  GAME_STATES getState(){
    return m_state;
  }
  // Start any serve of the game
  void startServe(Player serve, Player reciever, Ball b){
    b.startServe();
    b.setLastHit(serve);
    serve.setServeStatus();
    reciever.setRecieverStatus();
    serve.resetAim();
    reciever.resetAim();
    int option = int(random(1,3));
    if(serve.getSide() == 1){
      serve.setFacing(1);
      reciever.setFacing(-1);
      if(option % 2 == 0){
        serve.setPos(width/2 - width/8, 130);
        reciever.setPos(width/2 + width/4, 620);
      }
      else{
        serve.setPos(width/2 + width/8, 130);
        reciever.setPos(width/2 - width/4, 620);
      }
    }
    else{
      serve.setFacing(-1);
      reciever.setFacing(1);
      if(option % 2 == 0){
        serve.setPos(width/2 - width/4, 620);
        reciever.setPos(width/2 + width/8, 130);
      }
      else{
        serve.setPos(width/2 + width/4, 620);
        reciever.setPos(width/2 - width/8, 130);
      }
    }
    if(m_state != GAME_STATES.GAME_MENU){
      m_state = GAME_STATES.GAME_SERVE;
    }
  }

  // Change from moving in serving to shooting ball up to serve
  void startServing(Player server, Ball b,Player reciever){
    m_state = GAME_STATES.GAME_SERVING;
    server.setState(PLAYER_STATES.PLAYING,false);
    reciever.setState(PLAYER_STATES.PLAYING,true);
  }
  void endServing(){
    m_state = GAME_STATES.GAME_PLAYING;
  }
  void startGame(Player serve, Player reciever, Ball b){
    startServe(serve,reciever,b);
    serve.setScore(0);
    reciever.setScore(0);
  }
  void setPoint(Player p1, Player p2, Ball b){
    float side = b.getSide();
    Player reciever = p1.getState(PLAYER_STATES.RECIEVING) ? p1 : p2;
    Player server = p1.getState(PLAYER_STATES.SERVING) ? p1 : p2;
    // When we went to DEUCE MODE
    int difference = abs(p1.getScore() - p2.getScore());
    // This doesn't work when we have same points in advantage mode
    if(difference < 2 && difference >= 0 && (p1.getScore() > 0 || p2.getScore() > 0) && p1.getScore() <= 10 && p2.getScore() <= 10){
      if ((side == 1 && b.getLastHit() == p1 && b.isInside()) || side == 1 && b.getLastHit() == p2){
        p1.addScore(1);
      }
      else{
        p2.addScore(1);
      }
      difference = abs(p1.getScore() - p2.getScore());
      // Someone Won
      if(difference == 2){
        if(p1.getScore() > p2.getScore()){
          p1.addGame();
        }
        else{
          p2.addGame();
        }
        startGame(reciever,server,b);
      }
    }
    else{
      if ((side == 1 && b.getLastHit() == p1 && b.isInside()) || (side == 1 && b.getLastHit() == p2) || (side == 2 && b.getLastHit() == p2 && !b.isInside())){
        // Player one Won
        if(p1.getScore() == 40 && p2.getScore() != 40){
          p1.addGame();
          startGame(reciever,server,b);
        }
        //DEUCE
        else if (p1.getScore() == 40 && p2.getScore() == 40){
          p1.setScore(1);
          p2.setScore(0);
        }
        // Point for Player one
        else{
          if(p1.getScore() == 30){
            p1.addScore(10);
            return;
          }
          p1.addScore(15);
        }
      }
      else if((side == 2 && b.getLastHit() == p2 && b.isInside()) || (side == 2 && b.getLastHit() == p1) || (side == 1 && b.getLastHit() == p1 && !b.isInside())){
        // Player two Won
        if(p2.getScore() >= 40 && p1.getScore() != 40){
            p2.addGame();
            startGame(reciever,server,b);
        }
        //DEUCE
        else if (p2.getScore() == 40 && p1.getScore() == 40){
          p1.setScore(0);
          p2.setScore(1);
        }
        // Point for Player two
        else{
          if(p2.getScore() == 30){
            p2.addScore(10);
            return;
          }
          p2.addScore(15);
        }
      }
    }
  }
}


