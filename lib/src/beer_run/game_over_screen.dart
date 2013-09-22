part of beer_run;

class GameOverScreen extends View {

  String _text;

  DivElement get rootElement => null;

  GameOverScreen(this._text) : super();

  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.style.lineHeight = "24px";

    DivElement nameEl = new DivElement();
    nameEl.style.marginLeft = "auto";
    nameEl.style.marginRight = "auto";
    nameEl.style.width = "256px";
    nameEl.style.background = "#5482a9";
    nameEl.style.padding = "12px";
    nameEl.style.borderRadius = "8px";
    nameEl.style.height = "24px";

    DivElement nameTextEl = new DivElement();
    nameTextEl.text = "GameOver";
    nameTextEl.style.fontWeight = "bold";
    nameTextEl.style.fontSize = "22px";
    nameTextEl.style.height = "58px";
    nameTextEl.style.marginLeft = "auto";
    nameTextEl.style.marginRight = "auto";
    nameEl.append(nameTextEl);

    el.append(nameEl);

    DivElement messageEl = new DivElement();
    messageEl.style.marginLeft = "auto";
    messageEl.style.marginRight = "auto";
    messageEl.style.width = "80%";

    messageEl.text = this._text;
    messageEl.style.fontWeight = "bold";
    messageEl.style.fontSize = "22px";
    messageEl.style.height = "58px";
    el.append(messageEl);


    el.classes .add("ui");
    el.classes.add("text");
    root.append(
      el
    );
  }
}