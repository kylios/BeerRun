part of ui;

typedef void uiFunction(UI ui);

abstract class UIListener {

  void onWindowOpen(uiFunction);

  void onWindowClose(uiFunction);
}