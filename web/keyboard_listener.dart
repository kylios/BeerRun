library keyboard_listener;

import 'dart:html';

abstract class KeyboardListener {

  static final KEY_UP = 38;
  static final KEY_DOWN = 40;
  static final KEY_LEFT = 37;
  static final KEY_RIGHT = 39;

  void onKeyDown(KeyboardEvent e);
  void onKeyUp(KeyboardEvent e);
  void onKeyPressed(KeyboardEvent e);
}

