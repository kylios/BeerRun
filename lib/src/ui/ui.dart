part of ui;

class UI {

  WindowView _rootView;
  Player _player;

  // This is to hold onto the player's input component while UI is showing
  Component _tmpInputComponent = null;

  UI(DivElement rootEl, this._player) {

    this._rootView = new WindowView(this, rootEl);
  }

  void closeWindow() {
    this._player.setControlComponent(this._tmpInputComponent);
    this._rootView.onClose();
    this._player.level.unPause();
  }

  void showView(View v, {bool pause: false, int seconds: 0}) {

    if (pause) {
      this._player.level.pause();
    }

    this._tmpInputComponent = this._player.getControlComponent();

    v.onDraw(this._rootView.rootElement);
    this._rootView.show();

    if (seconds != 0) {
      new Future.delayed(seconds * 1000, () {
        this.closeWindow();
      });
    }
    else {
      // Pause gameplay too
      this._player.setControlComponent(new NullInputComponent());
    }
  }
}

