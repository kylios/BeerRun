part of ui;

abstract class UIInterface {

  void addListener(UIListener listener);

  void closeWindow(var data);

  void showView(View v, {
    int seconds: null,
    uiCallback callback: null});
}