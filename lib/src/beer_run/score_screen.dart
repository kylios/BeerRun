part of beer_run;

class ScoreScreen extends View {

  ScoreScreen() :
    super() {

  }

  DivElement get rootElement => null;

  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.text = "Level complete!";
    el.classes = ["ui", "text"];
    root.append(
      el
    );
  }
}

