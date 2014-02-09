part of drawing;

class Sprite {

  ImageElement _image;

  int _x;
  int _y;
  int _width;
  int _height;

  Sprite(this._image, this._x, this._y, this._width, this._height);

  int get x => this._x;
  int get y => this._y;
  int get width => this._width;
  int get height => this._height;
  ImageElement get image => this._image;
}
