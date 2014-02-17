part of ui;

class TextView extends View {

  String _text;

  TextView(UIInterface ui, this._text) : super(ui, root: new DivElement()) {
    this._root.innerHtml = this._text;
  }
}