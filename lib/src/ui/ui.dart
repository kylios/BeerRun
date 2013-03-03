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
    this._rootView.hide();
    this._rootView.clear();
    this._player.level.unPause();
  }

  void showView(View v, [bool pause]) {

    if (?pause && pause == true) {
      this._player.level.pause();
    }

    // Pause gameplay too
    this._tmpInputComponent = this._player.getControlComponent();
    this._player.setControlComponent(new NullInputComponent());

    v.onDraw(this._rootView.rootElement);
    this._rootView.show();
  }
}

