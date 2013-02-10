library game_object;

import 'dart:html';

import 'component.dart';
import 'direction.dart';
import 'level.dart';
import 'game_event.dart';
import 'component_listener.dart';

class GameObject {

  int _speed = 5;

  int _x = 0;
  int _y = 0;

  int oldX;
  int oldY;

  Direction _dir;

  Component _control;

  Level _level;

  int get x => this._x;
  int get y => this._y;
  Direction get dir => this._dir;
  int get numSteps => 9;
  Level get level => this._level;

  GameObject(this._dir, this._x, this._y);

  void setControlComponent(Component c) {
    this._control = c;
  }

  void setLevel(Level l) {
    this._level = l;
  }

  void setSpeed(int s) {
    this._speed = s;
  }

  void update() {

    this.oldX = this.x;
    this.oldY = this.y;
    this._control.update(this);
  }

  void moveUp() {
    this._dir = DIR_UP;
    this._y -= this._speed;
  }
  void moveDown() {
    this._dir = DIR_DOWN;
    this._y += this._speed;
  }
  void moveLeft() {
    this._dir = DIR_LEFT;
    this._x -= this._speed;
  }
  void moveRight() {
    this._dir = DIR_RIGHT;
    this._x += this._speed;
  }

  void broadcast(GameEvent e, Collection<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      l.listen(e);
    }
  }
}

