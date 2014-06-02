part of level;

abstract class Trigger {

  GameEvent _event;

  int _row;
  int _col;

  Trigger(this._event, this._row, this._col);

  int get row => this._row;
  int get col => this._col;

  GameEvent get event => this._event;
  GameEvent trigger(GameObject o);
  bool get isTriggered;
}