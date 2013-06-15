part of ui;

abstract class UIInterface {

  void addListener(UIListener listener);

  void closeWindow();

  void showView(View v, {
    int seconds: 0,
    var callback: null});
}