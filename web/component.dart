library component;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';
import 'component_listener.dart';

abstract class Component {

  Component();

  void update(GameObject obj);

  void broadcast(GameEvent e, Collection<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      l.listen(e);
    }
  }
}

