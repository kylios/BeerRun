part of ui;

abstract class View {

  UIInterface _container = null;

  View();

  DivElement get rootElement;
  UIInterface get container => this._container;

  void close() {
    this._container.closeWindow();
  }

  void draw(Element root) {
    this.onDraw(root);
  }

  void onDraw(Element root);

  void attachCloseButton(Element el) {
    el.onClick.listen((MouseEvent e) {
      this._container.closeWindow();
    });
  }
}

