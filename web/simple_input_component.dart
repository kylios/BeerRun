library simple_input_component;

import 'dart:html';

import 'component.dart';
import 'component_listener.dart';
import 'drawing_component.dart';
import 'keyboard_listener.dart';
import 'game_event.dart';
import 'game_object.dart';
import 'direction.dart';

class SimpleInputComponent extends Component
  implements KeyboardListener {

  Map<int, bool> _pressed;
  DrawingComponent _drawer;

  SimpleInputComponent(this._drawer) {
    this._pressed = new Map<int, bool>();
  }

  void broadcast(GameEvent e, List<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      l.listen(e);
    }
  }

  void update(GameObject obj) {

    if (this._pressed[KeyboardListener.KEY_UP] == true) {
      obj.moveUp();
    } else if (this._pressed[KeyboardListener.KEY_DOWN] == true) {
      obj.moveDown();
    }
    if (this._pressed[KeyboardListener.KEY_LEFT] == true) {
      obj.moveLeft();
    } else if (this._pressed[KeyboardListener.KEY_RIGHT] == true) {
      obj.moveRight();
    }
  }

  void onKeyDown(KeyboardEvent e) {
    this._pressed[e.keyCode] = true;
  }
  void onKeyUp(KeyboardEvent e) {
    this._pressed[e.keyCode] = false;
  }
  void onKeyPressed(KeyboardEvent e) {

  }
}

