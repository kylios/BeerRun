part of input;

/*
 * Thanks to this article for inspiration and code snippets:
 * http://dartgamedevs.org/blog/2012/12/11/keyboard-input/
 */
class KeyboardInputComponent extends Component implements KeyboardListener {

  static final KEY_UP = 38;
  static final KEY_DOWN = 40;
  static final KEY_LEFT = 37;
  static final KEY_RIGHT = 39;

  final List<Set<int>> _keyboardStates = [new Set<int>(),
                                          new Set<int>()];

  int _currentIndex = 0;
  int _previousIndex = 1;

  KeyboardInputComponent();

  /** Process a keyboard event for the current frame.
  *
  * NOTE: This function should be thought of as internal.
  * */
  void keyboardEvent(KeyboardEvent event, bool down) {
    //window.console.log("Key Code: ${event.keyCode}");
    if (down) {
      _keyboardStates[_currentIndex].add(event.keyCode);
    } else {
      _keyboardStates[_currentIndex].remove(event.keyCode);
    }

  }

  bool _isDown(Set<int> keyboardState, int keyCode) {
    return keyboardState.contains(keyCode);
  }

  /** Is [keyCode] up this frame? */
  bool isUp(int keyCode) {
    return !_isDown(_keyboardStates[_currentIndex], keyCode);
  }

  /** Was [keyCode] up in the previous frame? */
  bool wasUp(int keyCode) {
    return !_isDown(_keyboardStates[_previousIndex], keyCode);
  }

  /** Is [keyCode] down this frame? */
  bool isDown(int keyCode) {
    return _isDown(_keyboardStates[_currentIndex], keyCode);
  }

  /** Was [keyCode] down in the previous frame? */
  bool wasDown(int keyCode) {
    return _isDown(_keyboardStates[_previousIndex], keyCode);
  }

  /** Was [keyCode] down in the previous frame and up in this frame? */
  bool wasReleased(int keyCode) {
    return wasDown(keyCode) && isUp(keyCode);
  }

  /** Was [keyCode] up in the previous frame and down in this frame? */
  bool wasPressed(int keyCode) {
    return wasUp(keyCode) && isDown(keyCode);
  }

  /** Is [keyCode] being held down? */
  bool isHeld(int keyCode) {
    return wasDown(keyCode) && isDown(keyCode);
  }

  /** Is [keyCode] down this frame or was it down in the previous frame? */
  bool isDownFuzzy(int keyCode) {
    return isDown(keyCode) || wasDown(keyCode);
  }

  /** Is [keyCode] up this frame or was it up in the previous frame? */
  bool isUpFuzzy(int keyCode) {
    return isUp(keyCode) || wasUp(keyCode);
  }

  void update(GameObject obj) {

    // Swap map indices.
    int temp = _currentIndex;
    _currentIndex = _previousIndex;
    _previousIndex = temp;
    // Clear current frame state.
    _keyboardStates[_currentIndex].clear();
    // Start current frame state at same point as previous frame.
    _keyboardStates[_previousIndex].forEach((k) {
      _keyboardStates[_currentIndex].add(k);
    });


    if (this.isDown(KeyboardInputComponent.KEY_UP)) {
      obj.moveUp();
    } else if (this.isDown(KeyboardInputComponent.KEY_DOWN)) {
      obj.moveDown();
    }
    if (this.isDown(KeyboardInputComponent.KEY_LEFT)) {
      obj.moveLeft();
    } else if (this.isDown(KeyboardInputComponent.KEY_RIGHT)) {
      obj.moveRight();
    }
  }

  // Page key event handlers
  void onKeyDown(KeyboardEvent e) {
    this.keyboardEvent(e, true);
  }
  void onKeyUp(KeyboardEvent e) {
    this.keyboardEvent(e, false);
  }
  void onKeyPressed(KeyboardEvent e) {

  }
}

