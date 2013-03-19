part of drawing;

class Meter
{
  int _max;
  int _x;
  int _y;
  int _width;
  int _height;

  int value;

  Meter(this._max, this._x, this._y, this._width, this._height, [this.value]);

  void draw(DrawingInterface d) {

    d.backgroundColor = 'white';
    d.fillRect(this._x, this._y, this._width, this._height, 3, 3);

    num percent = this.value.toDouble() / this._max.toDouble();
    if (percent == 0) {
      return;
    }
    if (percent < 0.25) {
      d.backgroundColor = '#ff0000';
    } else if (percent < 0.5) {
      d.backgroundColor = '#ff4500';
    } else if (percent < 0.75) {
      d.backgroundColor = '#ffd700';
    } else {
      d.backgroundColor = '#00ff00';
    }
    int pixels = (percent * this._width).toInt();

    d.fillRect(this._x, this._y, pixels, this._height, 3, 3);


    d.backgroundColor = 'black';
    d.drawRect(this._x, this._y, this._width, this._height, 3, 3);
  }

}