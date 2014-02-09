part of game;

class GameEvent {

  static final int CREATE_BULLET_EVENT = 1;
  static final int TAKE_HIT_EVENT = 2;
  static final int BEER_STOLEN_EVENT = 3;
  static final int BEER_STORE_EVENT = 4;
  static final int PARTY_ARRIVAL_EVENT = 5;
  static final int GAME_WON_EVENT = 6;
  static final int GAME_LOST_EVENT = 7;
  static final int ADD_BEERS_DELIVERED_EVENT = 8;
  static final int NOTIFICATION_EVENT = 9;

  int type;
  int value;
  Map<String, dynamic> data = {};
  GameObject creator;
}

