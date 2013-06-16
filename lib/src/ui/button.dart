part of ui;

class Button extends View {

  String _text = "";
  bool _enabled = true;
  var _clickFn = null;

  DivElement _rootEl = null;

  Button(this._text, this._clickFn, [this._enabled = true]);

  DivElement get rootElement => this._rootEl;

  void onDraw(Element root) {
    DivElement el = new DivElement();
    el.text = this._text;
    el.classes = [ 'ui2', 'button' ];
    if (! this._enabled) {
      el.classes.add('disabled');
    }

    el.onClick.listen((MouseEvent e) {

      if (this._enabled && this._clickFn != null) {
        this._clickFn();
      }
    });

    this._rootEl = el;
    root.append(el);
  }

  void enable() {
    this._enabled = true;
    this._rootEl.classes.remove('disabled');
  }
  void disable() {
    if (this._enabled) {
      this._enabled = false;
      this._rootEl.classes.add('disabled');
    }
  }

}

