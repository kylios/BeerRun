part of ui;

class NinePatch {

  ImageElement _topLeftCorner;
  ImageElement _topRightCorner;
  ImageElement _bottomLeftCorner;
  ImageElement _bottomRightCorner;
  ImageElement _horizontalScaleable;
  ImageElement _verticalScaleable;
  int _cornerWidth;
  int _cornerHeight;

  NinePatch(this._cornerWidth, this._cornerHeight,
      this._topLeftCorner, this._topRightCorner,
      this._bottomLeftCorner, this._bottomRightCorner,
      this._horizontalScaleable, this._verticalScaleable);


  void draw(DrawingInterface drawer, int x, int y, int width, int height) {

    drawer.drawImage(this._topLeftCorner,
        x, y,
        this._cornerWidth, this._cornerHeight);
    drawer.drawImage(this._topRightCorner,
        x + width - this._cornerWidth, y,
        this._cornerWidth, this._cornerHeight);
    drawer.drawImage(this._bottomLeftCorner,
        x, y + height - this._cornerHeight,
        this._cornerWidth, this._cornerHeight);
    drawer.drawImage(this._bottomRightCorner,
        x + width - this._cornerWidth,
        y + height - this._cornerHeight,
        this._cornerWidth, this._cornerHeight);
    drawer.drawImage(this._horizontalScaleable,
        x + this._cornerWidth, y,
        width - this._cornerWidth * 2,
        this._cornerHeight);
    drawer.drawImage(this._horizontalScaleable,
        x + this._cornerWidth,
        y + height - this._cornerHeight,
        width - this._cornerWidth * 2,
        this._cornerHeight);
    drawer.drawImage(this._verticalScaleable,
        x, y + this._cornerHeight,
        this._cornerWidth,
        height - this._cornerHeight * 2);
    drawer.drawImage(this._verticalScaleable,
        x + width - this._cornerWidth,
        y + this._cornerHeight,
        this._cornerWidth,
        height - this._cornerHeight * 2);
  }
}

