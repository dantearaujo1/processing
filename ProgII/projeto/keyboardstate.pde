import java.util.Stack;

class KeyboardState{
  boolean[] _heldKeys;
  boolean[] _lastHeldKeys;
  KeyboardState(){
    _heldKeys = new boolean[255];
    _lastHeldKeys = new boolean[255];
    reset();
  }

  void reset(){
    for (int i = 0; i < 255; i++){
      _heldKeys[i] = false;
      _lastHeldKeys[i] = false;
    }
  }

  void updateKeyPressed(int lkey){
    this.keyPress(lkey);
  }
  void updateKeyReleased(int lkey){
    this.keyRelease(lkey);
  }

  void update(){
    for (int i = 0; i < 255; i++){
      _lastHeldKeys[i] = _heldKeys[i];
    }
  }
  boolean getKeyState(int lkey){
    return _heldKeys[ lkey ];
  }
  boolean isKeyJustPressed(int lkey){
    return (_heldKeys[ lkey ] && !_lastHeldKeys[ lkey ]);
  }
  boolean isKeyPressed(int lkey){
    return (isKeyJustPressed(lkey) || (_heldKeys[ lkey ] && _lastHeldKeys[ lkey ]));
  }
  boolean isKeyReleased(int lkey){
    return (!_heldKeys[ lkey ] && _lastHeldKeys[ lkey ] );
  }
  void keyPress(int lkey){
    _heldKeys[lkey] = true;
  }
  void keyRelease(int lkey){
    _heldKeys[lkey] = false;
  }
}

class InputContext{
  HashMap<String, Integer>  m_states;
  HashMap<String, Integer> m_actions;
  KeyboardState             m_input;

  InputContext(KeyboardState kb){
    m_states = new HashMap<String, Integer>();
    m_actions = new HashMap<String, Integer>();
    m_input = kb;

  }

  boolean mapState(String state, int k){
    m_states.put(state,k);
    return true;
  }
  boolean mapAction(String action, int k){
    m_actions.put(action,k);
    return true;
  }

  boolean getAction(String k){
    return (m_input.isKeyJustPressed(m_actions.get(k)));
  }
  boolean getState(String k){
    return (m_input.isKeyPressed(m_states.get(k)));
  }

}


class InputManager{

  HashMap<String,InputContext> m_contexts;
  InputManager(){

    m_contexts = new HashMap<String,InputContext>();
  }


  void addContext(String name, InputContext obj){
    if(!m_contexts.containsKey(name)){
      m_contexts.put(name,obj);
      return;
    }
    return;
  }

  InputContext getContext(String name){
    if(m_contexts.containsKey(name)){
      return m_contexts.get(name);
    }
    return null;
  }




}


