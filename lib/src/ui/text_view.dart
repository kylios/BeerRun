part of ui;

class TextView extends View {

  String _text;

  TextView(UIInterface ui, this._text) : super(ui) {
    DivElement el = new DivElement();
    el.classes.add("text");
    el.innerHtml = this._text;
    this._root = el;
  }
}