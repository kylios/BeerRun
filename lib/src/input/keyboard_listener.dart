part of input;

abstract class KeyboardListener {


  static const KEY_Tab = 9;

  static const KEY_SHIFT = 16;
  static const KEY_CONTROL = 17;
  static const KEY_ALT = 18;

  static const KEY_SPACE = 32;
  static const KEY_PAGE_UP = 33;
  static const KEY_PAGE_DOWN = 34;
  static const KEY_END = 35;
  static const KEY_HOME = 36;
  static const KEY_LEFT = 37;
  static const KEY_UP = 38;
  static const KEY_RIGHT = 39;
  static const KEY_DOWN = 40;

  static const KEY_0 = 48;
  static const KEY_1 = 49;
  static const KEY_2 = 50;
  static const KEY_3 = 51;
  static const KEY_4 = 52;
  static const KEY_5 = 53;
  static const KEY_6 = 54;
  static const KEY_7 = 55;
  static const KEY_8 = 56;
  static const KEY_9 = 57;

  static const KEY_A = 65;
  static const KEY_B = 66;
  static const KEY_C = 67;
  static const KEY_D = 68;
  static const KEY_E = 69;
  static const KEY_F = 70;
  static const KEY_G = 71;
  static const KEY_H = 72;
  static const KEY_I = 73;
  static const KEY_J = 74;
  static const KEY_K = 75;
  static const KEY_L = 76;
  static const KEY_M = 77;
  static const KEY_N = 78;
  static const KEY_O = 79;
  static const KEY_P = 80;
  static const KEY_Q = 81;
  static const KEY_R = 82;
  static const KEY_S = 83;
  static const KEY_T = 116;
  static const KEY_U = 85;
  static const KEY_V = 86;
  static const KEY_W = 87;
  static const KEY_X = 88;
  static const KEY_Y = 89;
  static const KEY_Z = 90;

  void onKeyDown(KeyboardEvent e);
  void onKeyUp(KeyboardEvent e);
  void onKeyPressed(KeyboardEvent e);
}

