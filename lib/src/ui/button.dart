part of ui;

class Button extends View {

  String _text = "";
  bool _enabled = true;
  var _clickFn = null;

  Button(UIInterface ui, this._text, this._clickFn, [this._enabled = true]) :
    super(ui) {

    this._root.text = this._text;
    this._root.classes.add("ui2");
    this._root.classes.add("button");
    if (! this._enabled) {
      this._root.classes.add('disabled');
    }

    this._root.onClick.listen((MouseEvent e) {

      if (this._enabled && this._clickFn != null) {
        this._clickFn();
      }
    });
  }

  void enable() {
    this._enabled = true;
    this._root.classes.remove('disabled');
  }
  void disable() {
    if (this._enabled) {
      this._enabled = false;
      this._root.classes.add('disabled');
    }
  }
}

