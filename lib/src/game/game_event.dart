part of game;

class GameEvent {

  static final int CREATE_BULLET_EVENT = 1;
  static final int TAKE_HIT_EVENT = 2;
  static final int BEER_STOLEN_EVENT = 3;

  int type;
  int value;
  Map<String, dynamic> data = {};
  GameObject creator;
}

