part of beer_run;

class LevelRequirementsScreen extends View {

  String _name;
  int _beers;
  Duration _time;

  DivElement get rootElement => null;

  LevelRequirementsScreen(this._name, this._beers, this._time) : super();

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
    nameTextEl.text = "${this._name}";
    nameTextEl.style.fontWeight = "bold";
    nameTextEl.style.fontSize = "22px";
    nameTextEl.style.height = "58px";
    nameTextEl.style.marginLeft = "auto";
    nameTextEl.style.marginRight = "auto";
    nameEl.append(nameTextEl);

    el.append(nameEl);

    DivElement beersEl = new DivElement();
    beersEl.style.marginLeft = "auto";
    beersEl.style.marginRight = "auto";
    beersEl.style.width = "80%";

    ImageElement beersIcon = new ImageElement();
    beersIcon.src = "img/ui/icons/beer.png";
    beersIcon.style.float = "left";
    beersIcon.style.margin = "5px";
    beersIcon.width = 48;
    beersIcon.height = 48;
    beersEl.append(beersIcon);

    DivElement beersTextEl = new DivElement();
    beersTextEl.text = "Bring ${this._beers} beers to the party";
    beersTextEl.style.fontWeight = "bold";
    beersTextEl.style.fontSize = "22px";
    beersTextEl.style.height = "58px";
    beersEl.append(beersTextEl);

    DivElement beersClearEl = new DivElement();
    beersClearEl.style.clear = "both";
    beersEl.append(beersClearEl);

    el.append(beersEl);

    DivElement timeEl = new DivElement();
    timeEl.style.marginLeft = "auto";
    timeEl.style.marginRight = "auto";
    timeEl.style.width = "80%";

    ImageElement clockIcon = new ImageElement();
    clockIcon.src = "img/ui/icons/clock.png";
    clockIcon.style.float = "left";
    clockIcon.style.margin = "5px";
    clockIcon.width = 48;
    clockIcon.height = 48;
    timeEl.append(clockIcon);

    DivElement timeTextEl = new DivElement();
    int seconds = this._time.inSeconds % 60;
    int minutes = this._time.inMinutes;
    String formattedTime = "${minutes}:";
    if (seconds < 10) {
      formattedTime = "${formattedTime}0${seconds}";
    } else {
      formattedTime = "${formattedTime}${seconds}";
    }
    timeTextEl.text = "You have ${formattedTime}!";
    timeTextEl.style.fontWeight = "bold";
    timeTextEl.style.fontSize = "22px";
    timeTextEl.style.height = "58px";
    timeEl.append(timeTextEl);

    DivElement timeClearEl = new DivElement();
    timeClearEl.style.clear = "both";
    timeEl.append(timeClearEl);

    el.append(timeEl);

    Button go = new Button("Start!", () {
      this.close();
    });
    go.draw(el);

    el.classes .add("ui");
    el.classes.add("text");
    root.append(
      el
    );
  }
}