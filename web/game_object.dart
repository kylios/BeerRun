library game_object;

import 'dart:html';

import 'component.dart';
import 'direction.dart';

class GameObject {

  int _speed = 5;

  int _x = 0;
  int _y = 0;
  Direction dir = DIR_DOWN;

  Component _control;

  int get x => this._x;
  int get y => this._y;
  int get numSteps => 9;

  void setControlComponent(Component c) {
    this._control = c;
  }

  void update() {
    this._control.update(this);
  }

  void moveUp() {
    this.dir = DIR_UP;
    this._y -= this._speed;
  }
  void moveDown() {
    this.dir = DIR_DOWN;
    this._y += this._speed;
  }
  void moveLeft() {
    this.dir = DIR_LEFT;
    this._x -= this._speed;
  }
  void moveRight() {
    this.dir = DIR_RIGHT;
    this._x += this._speed;
  }
}

