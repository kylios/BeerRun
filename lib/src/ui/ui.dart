part of ui;

class UI {

  DrawingInterface _drawer;

  UI(this._drawer) {

  }

  void showView(View v) {

    //v.onDraw();

    this._drawer.backgroundColor = "black";
    this._drawer.setOffset(-32, -32);
    this._drawer.fillRect(32, 32, 640 - 64, 480 - 64, 8, 8);
    this._drawer.backgroundColor = "white";
    this._drawer.fillRect(48, 48, 640 - 96, 480 - 96, 6, 6);
    this._drawer.backgroundColor = "black";
    v.onDraw(this._drawer);
  }
}

