part of ui;

class Message extends View {

  String _text;
  DivElement _rootEl = null;
  Button closeButton = null;

  Message(this._text);

  DivElement get rootElement => this._rootEl;

  void setText(String text) {
    this._text = text;
  }
  String getText() {
    return this._text;
  }
  void draw(Element root) {
    this.onDraw(root);
  }
  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.text = this._text;
    el.classes = ["ui2", "text"];
    el.append(new BRElement());
    root.append(
      el
    );

    this._rootEl = el;
  }
}