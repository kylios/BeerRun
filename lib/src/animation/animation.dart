part of animation;

abstract class Animation {

  int _x;
  int _y;

  Animation(this._x, this._y);

  int get x => this._x;
  int get y => this._y;

  void drawNext(DrawingInterface drawer);
  void drawCur(DrawingInterface drawer);

  bool isDone;
}