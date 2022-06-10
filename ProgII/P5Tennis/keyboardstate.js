
class KeyboardState {

  _heldKeys ;
  _lastHeldKeys ;

  constructor( ) {
    this._heldKeys= new Array(255);
    this._lastHeldKeys= new Array(255);
    this.reset( ) ;
  }
  reset ( ) {
    for ( let i = 0 ; i< 255 ; i++ ) {
      this._heldKeys[ i] = false ;
      this._lastHeldKeys[ i] = false ;
    }
  }
  updateKeyPressed ( lkey ) {
    this . keyPress ( lkey) ;
  }
  updateKeyReleased( lkey ) {
    this . keyRelease ( lkey) ;
  }
  update( ) {
    for ( let i = 0 ; i< 255 ; i++ ) {
      this._lastHeldKeys[ i] = this._heldKeys[ i] ;
    }
  }
  getKeyState ( lkey ) {
    return this._heldKeys[ lkey] ;
  }
  isKeyJustPressed ( lkey ) {
    return ( this._heldKeys[ lkey] && ! this._lastHeldKeys[ lkey] ) ;
  }
  isKeyPressed ( lkey ) {
    return ( this.isKeyJustPressed( lkey) || ( this._heldKeys[ lkey] && this._lastHeldKeys[ lkey] ) ) ;
  }
  isKeyReleased ( lkey ) {
    return ( ! this._heldKeys[ lkey] && this._lastHeldKeys[ lkey] ) ;
  }
  keyPress ( lkey ) {
    this._heldKeys[ lkey] = true ;
  }
  keyRelease ( lkey ) {
    this._heldKeys[ lkey] = false ;
  }
}

class InputContext {

  m_states ;
  m_actions ;
  m_input ;
  constructor( kb ) {
    this.m_states= new HashMap < String Integer , > ( ) ;
    this.m_actions= new HashMap < String Integer , > ( ) ;
    this.m_input= kb;
  }
  mapState ( state , k ) {
    this.m_states . put( state, k) ;
    return true ;
  }
  mapAction ( action , k ) {
    this.m_actions . put( action, k) ;
    return true ;
  }
  getAction ( k ) {
    return ( this.m_input . isKeyJustPressed( this.m_actions . get( k) ) ) ;
  }
  getState ( k ) {
    return ( this.m_input . isKeyPressed( this.m_states . get( k) ) ) ;
  }
}

class InputManager {

  m_contexts ;
  constructor( ) {
    this.m_contexts= new HashMap < String InputContext , > ( ) ;
  }
  addContext ( name , obj ) {
    if ( ! this.m_contexts . containsKey( name) ) {
      this.m_contexts . put( name, obj) ;
      return ;
    }
    return ;
  }

  getContext ( name ) {
    if ( this.m_contexts . containsKey( name) ) {
      return this.m_contexts . get( name) ;
    }
    return null ;
  }
}
