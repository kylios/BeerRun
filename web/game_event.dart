library game_event;

import 'dart:html';

import 'game_object.dart';

class GameEvent {

  int type;
  int value;
  Map<String, dynamic> data = {};
  GameObject creator;
}

