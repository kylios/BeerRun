part of ui;

abstract class View {

  DivElement get rootElement;

  void show();
  void hide();

  void onDraw(Element root);
}

