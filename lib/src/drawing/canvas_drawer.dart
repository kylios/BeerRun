part of drawing;

/**
 * This class handles drawing stuff to the canvas.  It provides basic
 * functionality to draw things like images, text, lines, etc, as well as
 * clearing the screen and setting a background.
 *
 * It also has the ability to "offset" the drawing to give a "scrolling"
 * effect.  As the player moves around, they should always appear in the center
 * of the screen, unless we get too far to the edge of the level.
 */
class CanvasDrawer implements DrawingInterface {

  CanvasManager _canvasManager;

  // These variables help do the canvas scrolling thing as the player moves
  int _offsetX;
  int _offsetY;
  int _boundX;
  int _boundY;

  String backgroundColor = "white";
  String font = "12px";

  /**
   * Give us a manager so we can access the canvas' properties.
   */
  CanvasDrawer(this._canvasManager);

  /**
   * Sets the draw offset.  Contsrains those offsets to certain boundaries so
   * we never draw just nothingness.
   */
  void setOffset(int x, int y) {

    // Stop "scrolling" when we get too close to the edge
    if (x < 0)  x = 0;
    else if (x /*+ this._canvasManager.width*/ > this._boundX)  x = this._boundX;
    if (y < 0)  y = 0;
    else if (y /*+ this._canvasManager.height*/ > this._boundY)  y = this._boundY;

    this._offsetX = x;
    this._offsetY = y;
  }

  void setBounds(int x, int y) {
    if (x < 0) x = 0;
    if (y < 0) y = 0;

    this._boundX = x;
    this._boundY = y;
  }

  // DRAWING FUNCTIONS
  void clear() {
    CanvasRenderingContext2D c = this._canvasManager.canvas.getContext("2d");
    c.fillStyle = this.backgroundColor;
    c.fillRect(0, 0, this._canvasManager.width, this._canvasManager.height);
  }

  void drawImage(ImageElement i, int x, int y, [int width, int height]) {

    CanvasRenderingContext2D c = this._canvasManager.canvas.getContext("2d");
    if (?width)
    {
      c.drawImage(i, x, y, width);
    }
    else if (?height)
    {
      c.drawImage(i, x, y, width, height);
    }
  }

  void drawSprite(Sprite s, int x, int y, [int drawWidth, int drawHeight]) {

    if (null == s) {
      return;
    }

    int width = (?drawWidth ? drawWidth : s.width);
    int height = (?drawHeight ? drawHeight : s.height);

    // If the sprite won't show up on screen, then just don't draw it!
    if (s == null || x == null || y == null ||
        x + s.width < this._offsetX ||
        x > this._offsetX + this._canvasManager.width ||
        y + s.height < this._offsetY ||
        y > this._offsetY + this._canvasManager.height)
    {
      return;
    }

    x = x - this._offsetX;
    y = y - this._offsetY;

    CanvasRenderingContext2D c = this._canvasManager.canvas.getContext("2d");

    c.drawImage(s.image, s.x, s.y, s.width, s.height, x, y, width, height);
  }

  void drawRect(int x, int y, int width, int height,
                [int radiusX, int radiusY]) {

    if (! ?radiusX) {
      radiusX = 0;
    }
    if (! ?radiusY) {
      radiusY = 0;
    }
    CanvasRenderingContext2D c = this._canvasManager.canvas.getContext("2d");

    c.fillStyle = "blue";
    c.beginPath();
    c.moveTo(x + radiusX, y);
    c.lineTo(x + width - radiusX, y);
    c.quadraticCurveTo(x + width, y, x + width, y + radiusY);
    c.lineTo(x + width, y + height - radiusY);
    c.quadraticCurveTo(x + width, y + height, x + width - radiusX, y + height);
    c.lineTo(x + radiusX, y + height);
    c.quadraticCurveTo(x, y + height, x, y + height - radiusY);
    c.lineTo(x, y + radiusY);
    c.quadraticCurveTo(x, y, x + radiusX, y);
    c.closePath();
    c.stroke();

  }

  void drawText(String text, int x, int y) {

    CanvasRenderingContext2D c = this._canvasManager.canvas.getContext("2d");
    c.font = this.font;

    c.fillText(text, x, y);
  }
}
