part of input;

abstract class KeyboardListener {


  static final int KEY_Tab = 9;

  static final int KEY_SHIFT = 16;
  static final int KEY_CONTROL = 17;
  static final int KEY_ALT = 18;

  static final int KEY_SPACE = 32;
  static final int KEY_PAGE_UP = 33;
  static final int KEY_PAGE_DOWN = 34;
  static final int KEY_END = 35;
  static final int KEY_HOME = 36;
  static final int KEY_LEFT = 37;
  static final int KEY_UP = 38;
  static final int KEY_RIGHT = 39;
  static final int KEY_DOWN = 40;

  static final int KEY_0 = 48;
  static final int KEY_1 = 49;
  static final int KEY_2 = 50;
  static final int KEY_3 = 51;
  static final int KEY_4 = 52;
  static final int KEY_5 = 53;
  static final int KEY_6 = 54;
  static final int KEY_7 = 55;
  static final int KEY_8 = 56;
  static final int KEY_9 = 57;

  static final int KEY_A = 65;
  static final int KEY_B = 66;
  static final int KEY_C = 67;
  static final int KEY_D = 68;
  static final int KEY_E = 69;
  static final int KEY_F = 70;
  static final int KEY_G = 71;
  static final int KEY_H = 72;
  static final int KEY_I = 73;
  static final int KEY_J = 74;
  static final int KEY_K = 75;
  static final int KEY_L = 76;
  static final int KEY_M = 77;
  static final int KEY_N = 78;
  static final int KEY_O = 79;
  static final int KEY_P = 80;
  static final int KEY_Q = 81;
  static final int KEY_R = 82;
  static final int KEY_S = 83;
  static final int KEY_T = 84;
  static final int KEY_U = 85;
  static final int KEY_V = 86;
  static final int KEY_W = 87;
  static final int KEY_X = 88;
  static final int KEY_Y = 89;
  static final int KEY_Z = 90;

  void onKeyDown(KeyboardEvent e);
  void onKeyUp(KeyboardEvent e);
  void onKeyPressed(KeyboardEvent e);
}

