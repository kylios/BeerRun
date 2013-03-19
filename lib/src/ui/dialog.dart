part of ui;

class Dialog extends View {

  String _text;

  Dialog(this._text) :
    super();

  void setText(String text) {
    this._text = text;
  }
  String getText() {
    return this._text;
  }

  DivElement get rootElement => null;

  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.text = this._text;
    el.classes = ["ui", "text"];
    root.append(
      el
    );
  }

}