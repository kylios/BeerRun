part of level;

class Trigger {

  GameEvent _event;

  int _row;
  int _col;

  Trigger(this._event, this._row, this._col);

  int get row => this._row;
  int get col => this._col;
  GameEvent get event => this.event;

  void applyToObject(GameObject obj) {
    obj.listen(this._event);
  }
}