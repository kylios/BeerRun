part of ui;

class Dialog extends View {

  String _text;

  Dialog(this._text);

  void setText(String text) {
    this._text = text;
  }
  String getText() {
    return this._text;
  }

  void onDraw(CanvasDrawer drawer) {

    // TODO: word wrapping
    // TODO: print chars one frame at a time
    // TODO: blinking text

    drawer.backgroundColor = "black";

    List<String> lines = DrawingUtils.wrapText(
        this._text, 640 - 128);
    int x = 64;
    int y = 64;

    for (String line in lines) {

      drawer.drawText(line, x, y);
      y += 16;
    }
  }

}