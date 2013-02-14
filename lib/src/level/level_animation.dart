part of level;

class LevelAnimation extends SpriteAnimation {

  int _x, _y;
  int _tileWidth;
  int _tileHeight;

  LevelAnimation(List<Sprite> sprites, this._x, this._y,
      this._tileWidth, this._tileHeight,
      bool loop) :
    super(sprites, loop);

  int get x => this._x;
  int get y => this._y;
  int get tileWidth => this._tileWidth;
  int get tileHeight => this._tileHeight;
}

