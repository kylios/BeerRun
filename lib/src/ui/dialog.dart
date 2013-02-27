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

  }
}