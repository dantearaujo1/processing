
class Game{
  GAME_STATES   m_states;
  Ball          m_ball;
  Player[]      m_players;
  Court         m_court;
  Net           m_net;

  float         m_currentTime;
  float         m_deltaTime;
  float         m_lastTime;

  String        m_scoreText;

  boolean       m_debug;

  GAME_STATES   m_state;

  Game(){
    init();
  }

  void init(){
    m_deltaTime =   0.0f;
    m_currentTime = 0.0f;
    m_lastTime =    0.0f;
    m_court =       new Court();
    m_ball =        new Ball(0,640,15);
    m_players =     new Player[4];
    m_players[0] =  new Player(width/2, 620,2);
    m_players[0].m_name += 0;
    m_players[1] =  new Player(0,0,1);
    m_players[1].m_name += 1;
    m_net =         m_court.getNet();
    m_state =       GAME_STATES.GAME_SERVE;
    m_debug =       false;
    startServe(m_players[1],m_players[0],m_ball);

  }

  void update(){
    m_currentTime = millis()/1000.0f;
    m_deltaTime += m_currentTime - m_lastTime;
    m_lastTime = m_currentTime;

    if (m_deltaTime >= DT){
      m_deltaTime -= DT;
      m_ball.update(this);
      m_ball.checkCourt(m_court);
      m_ball.checkNet(m_net);
      m_ball.setBallSide(m_net);


      for (int player = 0; player < m_players.length; player++){
        Player p = m_players[player];
        if(p != null){
          p.update();
          p.checkNetCollision(m_net);
        }
      }

      if(shouldGivePoint()){
        setState(GAME_STATES.GAME_POINT);
        setPoint(m_players[0],m_players[1],m_ball);
        startServe(m_players[0],m_players[1],m_ball);
      }
    }

  }

  void draw(){
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

  void run(){
    update();
    draw();
    drawGUI();
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
  Player getPlayer(int id){
    if (id > 0 && id < 5){
      return m_players[id-1];
    }
    return m_players[0];
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
  boolean isFirstHit(){
    return (m_state == GAME_STATES.GAME_FIRSTHIT);
  }
  boolean shouldShowScore(){
    return (m_state == GAME_STATES.GAME_POINT);
  }
  boolean shouldGivePoint(){
    return (m_ball.hasEnd());
  }
  void changeDebug(){
    m_debug =! m_debug;
  }
  void startServing(Player p, Ball b){
    m_state = GAME_STATES.GAME_SERVING;
  }
  void endServing(){
    m_state = GAME_STATES.GAME_PLAYING;
  }
  void startGame(Player serve, Player reciever, Ball b){
    startServe(serve,reciever,b);
    serve.setScore(0);
    reciever.setScore(0);
  }
  void startServe(Player serve, Player reciever, Ball b){
    b.startServe();
    b.setLastHit(serve);
    serve.setServeStatus();
    reciever.setRecieverStatus();
    int option = int(random(1,3));
    println(option);
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
    m_state = GAME_STATES.GAME_SERVE;
  }
  void setPoint(Player p1, Player p2, Ball b){
    float side = b.getSide();
    Player reciever = p1.getState(PLAYER_STATES.RECIEVING) ? p1 : p2;
    Player server = p1.getState(PLAYER_STATES.SERVING) ? p1 : p2;
    // When we went to DEUCE MODE
    int difference = abs(p1.getScore() - p2.getScore());
    // This doesn't work when we have same points in advantage mode
    if(difference < 2 && difference >= 0 && (p1.getScore() > 0 || p2.getScore() > 0) && p1.getScore() <= 10 && p2.getScore() <= 10){
      if (side == 1 && b.getLastHit() == p1 || side == 1 && b.getLastHit() == p2){
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
      if (side == 1 && b.getLastHit() == p1 || side == 1 && b.getLastHit() == p2){
        // Player one Won
        if(p1.getScore() >= 40 && p2.getScore() != 40){
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
      else  {
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
