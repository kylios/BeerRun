part of ui;

class UI {

  WindowView _rootView;

  UI(DivElement rootEl) {

    this._rootView = new WindowView(rootEl);
  }

  void showView(View v) {

    v.onDraw(this._rootView.rootElement);
    this._rootView.show();
  }
}

