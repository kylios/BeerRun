part of ui;

abstract class View {

  DivElement get rootElement;

  void onClose();

  void onDraw(Element root);
}

