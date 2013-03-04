part of animation;

class GraphicAnimation extends Animation {

  SpriteAnimation _sprites;
  int _tileWidth;
  int _tileHeight;

  GraphicAnimation(this._sprites,
      int x, int y, this._tileWidth, this._tileHeight) :
        super(x, y);

  void drawNext(DrawingInterface drawer) {
    drawer.drawSprite(this._sprites.getNext(), this.x, this.y,
        this._tileWidth, this._tileHeight);
  }
  void drawCur(DrawingInterface drawer) {
    drawer.drawSprite(this._sprites.getCur(), this.x, this.y,
        this._tileWidth, this._tileHeight);
  }

  bool get isDone => this._sprites.isDone();
}