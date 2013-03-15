part of ui;

abstract class View {

  UI _container = null;
  View([this._container]);

  DivElement get rootElement;
  UI get container => this._container;

  void onClose();

  void onDraw(Element root);

  void attachCloseButton(Element el) {
    el.onClick.listen((MouseEvent e) {
      this.container.closeWindow();
    });
  }
}

