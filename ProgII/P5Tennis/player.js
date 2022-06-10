 class Player {
   m_x ;
   m_y ;
   m_size ;
   m_target ;
   m_showTarget ;
   m_facingDirection ;
   m_side ;
   m_score ;
   m_games ;
   m_sets ;
   m_id ;
   m_name ;
   m_outfit ;
   m_racketX ;
   m_racketY ;
   m_racketXOffset ;
   m_racketYOffset ;
   m_racketHeight ;
   m_racketDiameter ;
   m_maxVel ;
   m_currentVel ;
   m_power ;
   m_maxShootPower ;
   m_states ;

   constructor( ) {
     this.m_x= width/ 2 ;
     this.m_y= height/ 2 ;
     this.m_racketXOffset= 15 ;
     this.m_racketYOffset= 10 ;
     this.m_racketX= this.m_x- this.m_racketXOffset;
     this.m_racketY= this.m_y- this.m_racketYOffset;
     this.m_racketHeight= 35 ;
     this.m_racketDiameter= 30 ;
     this.m_outfit= new Array(3);
     this.m_outfit[ 0 ] = color( 90 , 40 , 90 ) ;
     this.m_outfit[ 1 ] = color( 0 , 0 , 150 ) ;
     this.m_outfit[ 2 ] = color( 122 , 0 , 0 ) ;
     this.setSide( 1 ) ;
     this.m_id= 0 ;
     this.m_name= "Player " + this.m_id;
     this.m_maxVel= new p5.Vector ( 100 , 200 ) ;
     this.m_currentVel= new p5.Vector ( 0 , 0 ) ;
     this.m_size= new p5.Vector ( 20 , 30 ) ;
     this.m_target= new p5.Vector ( width/ 2 , height/ 2 ) ;
     this.m_showTarget= false ;
     this.m_power= 70 ;
     this.m_maxShootPower= 200 ;
     this.m_sets= 0 ;
     this.m_score= 0 ;
     this.m_states= new HashMap < PLAYER_STATES Boolean , > ( ) ;
     this.initStates( ) ;
   }
   constructor( x , y , id , side ) {
     this.m_x= x;
     this.m_y= y;
     this.m_racketXOffset= 15 ;
     this.m_racketYOffset= 10 ;
     this.m_racketX= this.m_x- this.m_racketXOffset;
     this.m_racketY= this.m_y- this.m_racketYOffset;
     this.m_racketHeight= 35 ;
     this.m_racketDiameter= 30 ;
     this.m_outfit= new Array(3);
     this.m_outfit[ 0 ] = color( 90 , 40 , 90 ) ;
     this.m_outfit[ 1 ] = color( 0 , 0 , 150 ) ;
     this.m_outfit[ 2 ] = color( 122 , 0 , 0 ) ;
     this.setSide( side) ;
     this.m_id= id;
     this.m_name= "Player " + this.m_id;
     this.m_size= new p5.Vector ( 20 , 30 ) ;
     this.m_maxVel= new p5.Vector ( 250 , 200 ) ;
     this.m_currentVel= new p5.Vector ( 0 , 0 ) ;
     this.m_target= new p5.Vector ( width/ 2 , height/ 2 - 100 ) ;
     this.m_showTarget= false ;
     this.m_maxShootPower= 225 ;
     this.m_power= 70 ;
     this.m_score= 0 ;
     this.m_sets= 0 ;
     this.m_states= new HashMap < PLAYER_STATES Boolean , > ( ) ;
     this.initStates( ) ;
   }

  function handleInput ( g ) {
    let input = g_inputManager;
    let ctx = input . getContext( this.m_name) ;
    let ball = g . getBall( ) ;
    if ( g . shouldStartServing( ) ) {
      if ( ctx . getAction( "Hit" ) && this.getServeStatus( ) ) {
        g . startServing( this , ball, g . getPlayerRecieving( ) ) ;
      }
    }
    else {
    if ( ctx . getAction( "Hit" ) && ball . getState( ) == BALL_STATES . SERVING) {
      this.hit( ball, g . getCourt( ) ) ;
    }
  }
  if ( ctx . getState( "Move Right" ) ) {
      this.setState( PLAYER_STATES . RIGHT, true ) ;
  }
  if ( ctx . getState( "Move Right" ) ) {
    this.setState( PLAYER_STATES . RIGHT, true ) ;
  }
  else {
    this.setState( PLAYER_STATES . RIGHT, false ) ;
    this.setVelX( 0 ) ;
  }
  if ( ctx . getState( "Move Left" ) ) {
    this.setState( PLAYER_STATES . LEFT, true ) ;
  }
  else {
    this.setState( PLAYER_STATES . LEFT, false ) ;
    this.setVelX( 0 ) ;
  }
  if ( ctx . getState( "Move Down" ) ) {
    this.setState( PLAYER_STATES . DOWN, true ) ;
  }
  else {
    this.setState( PLAYER_STATES . DOWN, false ) ;
    this.setVelY( 0 ) ;
  }
  if ( ctx . getState( "Move Up" ) ) {
    this.setState( PLAYER_STATES . UP, true ) ;
  }
  else {
    this.setState( PLAYER_STATES . UP, false ) ;
    this.setVelY( 0 ) ;
  }
  if ( ctx . getState( "Aim" ) ) {
    this.setState( PLAYER_STATES . AIM, true ) ;
  }
  else {
    this.setState( PLAYER_STATES . AIM, false ) ;
  }
  }

  function init ( x , y , side ) {
     this.setSide( side) ;
     this.m_score= 0 ;
     this.m_sets= 0 ;
     this.m_x= x;
     this.m_y= y;
     this.initStates( ) ;
     this.resetAim( ) ;
   }
  function initStates ( ) {
     this.m_states . put( PLAYER_STATES . LEFT, false ) ;
     this.m_states . put( PLAYER_STATES . UP, false ) ;
     this.m_states . put( PLAYER_STATES . RIGHT, false ) ;
     this.m_states . put( PLAYER_STATES . DOWN, false ) ;
     this.m_states . put( PLAYER_STATES . SERVING, true ) ;
     this.m_states . put( PLAYER_STATES . RECIEVING, false ) ;
     this.m_states . put( PLAYER_STATES . PLAYING, false ) ;
     this.m_states . put( PLAYER_STATES . AIM, false ) ;
   }
   function hit ( b , c ) {
    if ( this.checkHit( b) ) {
      let direction = PVector . sub( this.m_target, new p5.Vector ( this.m_racketX, this.m_racketY) ) . normalize ( ) ;
      // Getting ball get ball position
      // We're going to get the distance of the center of the ball
      // to the center of racket, the closer it gets, more power we will
      // push the ball up
      let bpos = b . getBallPosition( ) ;
      let distToRacketCenter = dist( bpos . x, bpos . y, this.m_racketX, this.m_racketY) ;
      // Reduce percentage by half to not be an weak shoot
      let percentage = ( distToRacketCenter/ this.m_racketDiameter) * 0.5;
      let heightForce = this.m_power* ( 1.1- percentage) ;
      let shootDirectionPower = this.m_maxShootPower* ( 1 - percentage) ;
      direction . mult( shootDirectionPower) ;

      if ( b . isServing( ) ) { b . setVel( direction . x, direction . y)
        b . setVelZ( heightForce) ;
        b . setLastHit( this ) ;
        b . setState( BALL_STATES . PLAYING) ;
        this.m_states . put( PLAYER_STATES . PLAYING, true ) ;
        this.m_showTarget= false ;
        return ;
      }
    }
  }

  function hit2 ( b , c ) {
    if ( this.checkHit( b) ) {
      let bpos = b . getBallPosition( ) ;
      let direction = PVector . sub( bpos, new p5.Vector ( this.m_racketX, this.m_racketY) ) . normalize ( ) ;
      let distToRacketCenter = dist( bpos . x, bpos . y, this.m_racketX, this.m_racketY) ;
      // Reduce percentage by half to not be an weak shoot
      let percentage = ( distToRacketCenter/ this.m_racketDiameter) ;
      let heightForce = this.m_power* ( percentage) ;
      let shootDirectionPower = this.m_maxShootPower;
      // Reduce percentage by half to not be an weak shoot
      direction.mult( shootDirectionPower) ;
      // When the serve end and they are playing
      b.setCurrentMaxHeight( b . getMaxHeight( ) ) ;
      b . setVelZ( heightForce) ;
      b . setVel( direction . x, direction . y) ;
      b . setKickCount( 0 ) ;
      b . setLastHit( this ) ;
    }
  }

  function update ( g , c , n ) {
    if ( g . getBall( ) . getState ( ) == BALL_STATES . PLAYING&& ! g . getBall( ) . isFirstHit ( ) ) {
      this.hit2( g . getBall( ) , c) ;
    }
    let condition = ( ! this.m_states . get( PLAYER_STATES . SERVING) || this.m_states . get( PLAYER_STATES . PLAYING) ) ;
    if ( this.m_states . get( PLAYER_STATES . LEFT) ) {
      this.m_currentVel . x= - this.m_maxVel . x;
    }
    if ( this.m_states . get( PLAYER_STATES . RIGHT) ) {
      this.m_currentVel . x= this.m_maxVel . x;
    }
    if ( this.m_states . get( PLAYER_STATES . UP) && condition) {
      this.m_currentVel . y= - this.m_maxVel . y;
    }
    if ( this.m_states . get( PLAYER_STATES . DOWN) && condition) {
      this.m_currentVel . y= this.m_maxVel . y;
    }
    if ( this.m_states . get( PLAYER_STATES . AIM) ) {
      this.m_target . x+= this.m_currentVel . x* getDeltaTime( ) ;
      this.m_target . y+= this.m_currentVel . y* getDeltaTime( ) ;
    }
    this.m_x+= this.m_currentVel . x* getDeltaTime( ) ;
    this.m_y+= this.m_currentVel . y* getDeltaTime( ) ;
    this.m_racketX= this.m_x- this.m_racketXOffset;
    this.m_racketY= this.m_y- this.m_racketYOffset;
    this.checkNetCollision( n) ;
    this.checkWindowCollision( ) ;
  }

  function draw ( ) {
    stroke( 255 ) ;
    fill( this.m_outfit[ 0 ] ) ;
    circle( this.m_x+ this.m_size . x/ 2 , this.m_y- this.m_size . y/ 2 , this.m_size . x) ;
    fill( this.m_outfit[ 1 ] ) ;
    rect( this.m_x, this.m_y, this.m_size . x, this.m_size . y) ;
    fill( this.m_outfit[ 2 ] ) ;
    pushStyle( ) ;
    stroke( this.m_outfit[ 2 ] ) ;
    strokeWeight( 4 ) ;
    line( this.m_x- this.m_racketXOffset/ 2 , this.m_y- this.m_racketYOffset/ 6 , this.m_x, this.m_y+ 12 ) ;
    popStyle( ) ;
    circle( this.m_x- this.m_racketXOffset, this.m_y- this.m_racketYOffset, this.m_racketDiameter) ;
    if ( this.m_showTarget) {
      circle( this.m_target . x, this.m_target . y, 5 ) ;
    }
  }

  function drawDebug ( atX , atY ) {
    noFill( ) ;
    circle( this.m_x- this.m_racketXOffset, this.m_y- this.m_racketYOffset, this.m_racketDiameter* 2 ) ;
    text( this.m_name, this.m_x+ 10 , this.m_y- this.m_size . x) ;
    text( "Side: " + this.m_side, atX, atY+ 15 ) ;
    text( "Target: (" + this.m_target . x+ "," + this.m_target . y+ ")" , atX+ 30 , atY+ 15 ) ;
    text( "Points: " + this.m_score, atX, atY+ 30 ) ;
    text( "Games: " + this.m_games, atX, atY+ 45 ) ;
    text( "Sets: " + this.m_sets, atX, atY+ 60 ) ;
    text( "Serving: " + this.m_states . get( PLAYER_STATES . SERVING) , atX, atY+ 75 ) ;
    text( "Recieving: " + this.m_states . get( PLAYER_STATES . RECIEVING) , atX, atY+ 90 ) ;
    text( "Playing: " + this.m_states . get( PLAYER_STATES . PLAYING) , atX, atY+ 105 ) ;
  }

  function checkWindowCollision ( ) {
  // This is our imaginary bounding box for player with rackets and head
  // Theses variables are offsets from our player X,Y top left corner rect
  let top = this.m_size . y/ 2 + this.m_size . x/ 2 ; // m_size.x is the head diameter and m_size.y/2 is the offset from topleft rect
  let bottom = height- this.m_size . y;
  let left = this.m_racketDiameter;
  let right = width- this.m_size . x;
  if ( this.m_x< left) {
    this.setPos( left, this.m_y) ;
  }
    if ( this.m_y< top) {
      this.setPos( this.m_x, top) ;
    }
    if ( this.m_x> right) {
      this.setPos( right, this.m_y) ;
    }
    if ( this.m_y> bottom) {
      this.setPos( this.m_x, bottom) ;
    }
  }

  function checkNetCollision ( n ) {
    if ( this.m_facingDirection== 1 ) {
      if ( this.m_y> n . getPosY( ) - this.m_size . y) {
        this.setPos( this.m_x, n . getPosY( ) - this.m_size . y) ;
      }
    }
    else {
      if ( this.m_y< n . getPosY( ) - this.m_size . y/ 2 ) {
        this.setPos( this.m_x, n . getPosY( ) - this.m_size . y/ 2 ) ;
      }
    }
  }
  function checkHit ( b ) {
    let radius = b . getBallDiameter( ) ;
    // Passed our diameter for collision check instead of radius
  // To facilitate our shot
    if ( CollisionCC( b . getBallPosition( ) . x , b . getBallPosition( ) . y , radius, this.m_racketX, this.m_racketY, this.m_racketDiameter/ 2 ) ) {
      return true ;
    }
    return false ;
  }
   // GETTERST AND SETTERS ====================================================
  function getPosX ( ) {
    return this.m_x;
  }
  function getPosY ( ) {
    return this.m_y;
  }
  function getRacketX ( ) {
    return this.m_racketX;
  }
  function getRacketY ( ) {
    return this.m_racketY;
  }
  function getSize ( ) {
    return this.m_size . copy( ) ;
  }
  function getSide ( ) {
    return this.m_side;
  }
  function getState ( state ) {
    return this.m_states . get( state) ;
  }
  function getFacing ( ) {
    return this.m_facingDirection;
  }
  function getCurrentVel ( ) {
    return this.m_currentVel . copy( ) ;
  }
  function getMaxVel ( ) {
    return this.m_maxVel . copy( ) ;
  }
  function getScore ( ) {
    return this.m_score;
  }
  function getServeStatus ( ) {
    return this.m_states . get( PLAYER_STATES . SERVING) ;
  }
  function getRecieverStatus ( ) {
    return this.m_states . get( PLAYER_STATES . RECIEVING) ;
  }
  function getName ( ) {
    return this.m_name;
  }
   // SETTERS ==================================================================
  function setSide ( i ) {
    if ( i== 1 ) {
      this.m_side= i;
    this.setFacing( 1 ) ;
    }
    else {
      this.m_side= 2 ;
      this.setFacing( - 1 ) ;
    }
  }
  function setFacing ( i ) {
    if ( i== 1 || i== - 1 ) this.m_facingDirection= i;
  }
  function setPos ( x , y ) {
    this.m_x= x;
    this.m_y= y;
  }
  funtion setVel ( vx , vy ) {
    this.m_currentVel . x= vx;
    this.m_currentVel . y= vy;
  }
  function setVelX ( vx ) {
    this.m_currentVel . x= vx;
  }
  function setVelY ( vy ) {
    this.m_currentVel . y= vy;
  }
  function setScore ( score ) {
    this.m_score= score;
  }
  function setColor ( piece , c ) {
    if ( piece>= 0 || piece< 3 ) {
      this.m_outfit[ piece] = c;
    }
  }
  function setId ( id ) {
    if ( id> 0 && id< 5 ) {
      this.m_id= id;
    }
  }
  function setTarget ( x , y ) {
    if ( x> 0 && x< width) {
      this.m_target . x= x;
    }
    else {
      this.m_target . x= width/ 2 ;
    }
    if ( y> 0 && y< height) {
      this.m_target . y= y;
    }
    else {
      this.m_target . y= height/ 2 ;
    }
  }
  function setServeStatus ( ) {
    this.m_states . put( PLAYER_STATES . SERVING, true ) ;
    this.m_showTarget= true ;
    this.m_states . put( PLAYER_STATES . RECIEVING, false ) ;
    this.m_states . put( PLAYER_STATES . PLAYING, false ) ;
  }
  function setRecieverStatus ( ) {
    this.m_states . put( PLAYER_STATES . SERVING, false ) ;
    this.m_states . put( PLAYER_STATES . RECIEVING, true ) ;
    this.m_states . put( PLAYER_STATES . PLAYING, false ) ;
  }
  function setState ( st , val ) {
    this.m_states . put( st, val) ;
  }
  function resetAim ( ) {
    if ( this.m_side== 1 ) {
      this.m_target . y= height/ 2 + 100 ;
    }
    else {
      this.m_target . y= height/ 2 - 100 ;
    }
    this.m_target . x= width/ 2 ;
  }
  function addScore ( amount ) {
    this.m_score+= amount;
  }
  function addSet ( ) {
    this.m_sets++ ;
  }
  function addGame ( ) {
    this.m_games++ ;
    if ( this.m_games== 7 ) {
      this.addSet( ) ;
    }
  }
 }



