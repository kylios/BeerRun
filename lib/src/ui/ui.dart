part of ui;

class UI {

  WindowView _rootView;
  Player _player;
  bool _opened = false;
  var _callback = null;

  // This is to hold onto the player's input component while UI is showing
  Component _tmpInputComponent = null;

  UI(DivElement rootEl, this._player) {

    this._rootView = new WindowView(this, rootEl);
  }

  void closeWindow() {
    this._player.setControlComponent(this._tmpInputComponent);
    this._rootView.onClose();
    this._player.level.unPause();
    this._opened = false;

    if (this._callback != null) {
      this._callback();
    }
  }

  void showView(View v, {
                bool pause: false,
                int seconds: 0,
                var callback: null}) {

    if (this._opened) {
      this.closeWindow();
    }

    if (pause) {
      this._player.level.pause();
    }

    this._tmpInputComponent = this._player.getControlComponent();

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
      this._player.setControlComponent(new NullInputComponent());
    }
    this._opened = true;
  }
}

