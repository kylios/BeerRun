library component;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';

abstract class Component {

  Component();

  void update(GameObject obj);
}

