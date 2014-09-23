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
    int _offsetX = 0;
    int _offsetY = 0;
    int _boundX = 0;
    int _boundY = 0;

    String _backgroundColor = "white";
    String _font = "12px";

    /**
   * Give us a manager so we can access the canvas' properties.
   */
    CanvasDrawer(this._canvasManager) {

        if (_globalContext == null) {
            _globalContext = this._canvasManager.canvas.getContext("2d");
        }
    }

    String get backgroundColor => this._backgroundColor;
    set backgroundColor(String color) {
        this._backgroundColor = color;
        CanvasRenderingContext2D c = this.context;
        c.fillStyle = this._backgroundColor;
    }

    String get font => this._font;
    set font(String font) {
        this._font = font;
        CanvasRenderingContext2D c = this.context;
        c.font = this._font;
    }

    int get offsetX => this._offsetX;
    int get offsetY => this._offsetY;

    CanvasManager get canvas => this._canvasManager;
    CanvasRenderingContext2D get context {
        CanvasRenderingContext2D c = this._canvasManager.canvas.getContext('2d'
                );
        return c;
    }

    /**
   * Sets the draw offset.  Contsrains those offsets to certain boundaries so
   * we never draw just nothingness.
   */
    void setOffset(int x, int y) {

        // Stop "scrolling" when we get too close to the edge
        if (x < 0) {
            x = 0;
        } else if (x + this._canvasManager.width >= this._boundX) x =
                this._boundX - this._canvasManager.width;
        if (y < 0) {
            y = 0;
        } else if (y + this._canvasManager.height >= this._boundY) y =
                this._boundY - this._canvasManager.height;

        this._offsetX = x;
        this._offsetY = y;
    }

    void moveOffset(int dX, int dY) {
        window.console.log("moving $dX, $dY");
        this._offsetX += dX;
        this._offsetY += dY;
        if (this._offsetX < 0) {
            this._offsetX = 0;
        } else if (this._offsetX /*+ this._canvasManager.width*/ > this._boundX)
                this._offsetX = this._boundX;
        if (this._offsetY < 0) {
            this._offsetY = 0;
        } else if (this._offsetY /*+ this._canvasManager.height*/ >
                this._boundY) this._offsetY = this._boundY;
    }

    void setBounds(int x, int y) {
        if (x < 0) x = 0;
        if (y < 0) y = 0;

        this._boundX = x;
        this._boundY = y;
    }

    // DRAWING FUNCTIONS
    void clear() {
        CanvasRenderingContext2D c = this.context;
        c.fillStyle = this.backgroundColor;
        c.fillRect(0, 0, this._canvasManager.width, this._canvasManager.height);
    }

    void drawImage(ImageElement i, int x, int y, [int width, int height]) {

        CanvasRenderingContext2D c = this.context;
        if (null != width && null != height) {
            //Rect destinationRect = new Rect(x, y, width, height);
            //Rect sourceRect = new Rect(0, 0, i.width, i.height);
            // TODO: durrrrrr
            c.drawImage(i, x, y);
        } else {
            c.drawImage(i, x, y);
        }
    }

    void drawSprite(Sprite s, int x, int y, [int drawWidth, int drawHeight]) {
        if (null == s) {
            return;
        }

        int width = ((null != drawWidth) ? drawWidth : s.width);
        int height = ((null != drawHeight) ? drawHeight : s.height);

        // If the sprite won't show up on screen, then just don't draw it!
        if (s == null || x == null || y == null || x + s.width < this._offsetX
                || x > this._offsetX + this._canvasManager.width || y + s.height < this._offsetY
                || y > this._offsetY + this._canvasManager.height) {
            return;
        }

        x = x - this._offsetX;
        y = y - this._offsetY;

        CanvasRenderingContext2D c = this.context;

        c.drawImageScaledFromSource(s.image, s.x, s.y, s.width, s.height, x, y,
                width, height);
        //c.drawImage(s.image, s.x, s.y, s.width, s.height, x, y, width, height);

        //this.drawRect(x, y, drawWidth, drawHeight);
    }

    void drawRect(int x, int y, int width, int height, [int radiusX, int
            radiusY]) {

        if (null == radiusX) {
            radiusX = 0;
        }
        if (null == radiusY) {
            radiusY = 0;
        }
        CanvasRenderingContext2D c = this.context;

        c.fillStyle = this.backgroundColor;
        c.beginPath();
        c.moveTo(x + radiusX, y);
        c.lineTo(x + width - radiusX, y);
        c.quadraticCurveTo(x + width, y, x + width, y + radiusY);
        c.lineTo(x + width, y + height - radiusY);
        c.quadraticCurveTo(x + width, y + height, x + width - radiusX, y +
                height);
        c.lineTo(x + radiusX, y + height);
        c.quadraticCurveTo(x, y + height, x, y + height - radiusY);
        c.lineTo(x, y + radiusY);
        c.quadraticCurveTo(x, y, x + radiusX, y);
        c.closePath();
        c.stroke();

    }

    void fillRect(int x, int y, int width, int height, [int radiusX, int
            radiusY]) {

        if (null == radiusX) {
            radiusX = 0;
        }
        if (null == radiusY) {
            radiusY = 0;
        }
        CanvasRenderingContext2D c = this.context;

        c.fillStyle = this.backgroundColor;
        c.beginPath();
        c.moveTo(x + radiusX, y);
        c.lineTo(x + width - radiusX, y);
        c.quadraticCurveTo(x + width, y, x + width, y + radiusY);
        c.lineTo(x + width, y + height - radiusY);
        c.quadraticCurveTo(x + width, y + height, x + width - radiusX, y +
                height);
        c.lineTo(x + radiusX, y + height);
        c.quadraticCurveTo(x, y + height, x, y + height - radiusY);
        c.lineTo(x, y + radiusY);
        c.quadraticCurveTo(x, y, x + radiusX, y);
        c.closePath();
        c.fill();

    }

    void drawText(String text, int x, int y, {relative: false}) {

        CanvasRenderingContext2D c = this.context;
        c.font = this.font;
        c.fillStyle = this.backgroundColor;

        if (relative) {
            x -= this._offsetX;
            y -= this._offsetY;
        }

        c.fillText(text, x, y);
    }

    TextMetrics measureText(String text) {
        CanvasRenderingContext2D c = this.context;
        return c.measureText(text);
    }

    DrawingPath getPath() {
        return new DrawingPath(this.context);
    }
}
