part of ui;

class UI implements UIInterface {

  WindowView _rootView;
  bool _opened = false;
  var _callback = null;
  List<UIListener> _listeners = new List<UIListener>();

  // This is to hold onto the player's input component while UI is showing
  Component _tmpInputComponent = null;

  UI(DivElement rootEl) {

    this._rootView = new WindowView(this, rootEl);
  }

  void addListener(UIListener listener) {
    this._listeners.add(listener);
  }

  void closeWindow() {

    window.console.log("close window called");
    if (this._listeners.length > 0) {
        this._listeners.forEach((UIListener l) => l.onWindowClose(this));
    }
    this._rootView.onClose();
    this._opened = false;

    if (this._callback != null) {
      this._callback();
    }
  }

  void showView(View v, {
                int seconds: null,
                var callback: null}) {

    if (this._opened) {
      this.closeWindow();
    }

    if (seconds == null) {
      seconds = 0;
    }

    if (seconds > 0) {
      this._rootView.hideX();
    }

    this._callback = callback;
    v._container = this;
    v.draw(this._rootView.rootElement);
    this._rootView.show();

    if (seconds != 0) {
      new Future.delayed(new Duration(seconds: seconds), () {
        this.closeWindow();
        this._rootView.showX();
      });
    }
    else {
      // Pause gameplay too
    }
    this._opened = true;
  }
}

