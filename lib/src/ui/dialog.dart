part of ui;

class Dialog extends View {

  String _text;
  DivElement _rootEl = null;
  Button closeButton = null;

  Dialog(this._text) {
    this.closeButton = new Button("Close", this.close);
  }

  void setText(String text) {
    this._text = text;
  }
  String getText() {
    return this._text;
  }

  DivElement get rootElement => this._rootEl;

  void draw(Element root) {
    this.onDraw(root);
    this.closeButton.draw(this._rootEl);
  }
  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.text = this._text;
    el.classes = ["ui", "text"];
    el.append(new BRElement());
    root.append(
      el
    );

    this._rootEl = el;
  }

}