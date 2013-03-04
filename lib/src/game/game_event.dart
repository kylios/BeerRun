part of game;

class GameEvent {

  static final int CREATE_BULLET_EVENT = 1;
  static final int TAKE_HIT_EVENT = 2;
  static final int BEER_STOLEN_EVENT = 3;
  static final int BEER_STORE_EVENT = 4;
  static final int PARTY_ARRIVAL_EVENT = 5;

  int type;
  int value;
  Map<String, dynamic> data = {};
  GameObject creator;
}

