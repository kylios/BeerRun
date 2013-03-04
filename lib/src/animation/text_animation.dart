part of animation;

class _TextAnimationFrame {

  int _x;
  int _y;
  String _text;

  _TextAnimationFrame(this._x, this._y, this._text);

  int get x => this._x;
  int get y => this._y;
  String get text => this._text;
}

class TextAnimation extends Animation {

  String _text;
  int _cur = 0;
  int _endTime = 0;


  TextAnimation(this._text, int x, int y, int duration) :
      super(x, y) {
    this._endTime = new DateTime.now().millisecondsSinceEpoch + duration * 1000;
  }

  void drawNext(DrawingInterface drawer) {
    _TextAnimationFrame frame = this._getNext();
    drawer.backgroundColor = "blue";
    drawer.drawText(this._text, this.x, this.y + frame._y, relative: true);
  }
  void drawCur(DrawingInterface drawer) {
    _TextAnimationFrame frame = this._getCur();
    drawer.backgroundColor = "blue";
    drawer.drawText(this._text, this.x, this.y + frame._y, relative: true);
  }

  _TextAnimationFrame _getNext() {
    _TextAnimationFrame frame =
        new _TextAnimationFrame(0, -this._cur, this._text);
    if (this._cur < 16) {
      this._cur++;
    }
    return frame;
  }

  _TextAnimationFrame _getCur() {
    _TextAnimationFrame frame =
        new _TextAnimationFrame(0, -this._cur, this._text);
    return frame;
  }

  void reset() {
    this._cur = 0;
  }

  bool get isDone =>
      (new DateTime.now().millisecondsSinceEpoch >= this._endTime);
}

