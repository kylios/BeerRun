part of beer_run;

class ScoreScreen extends View {

  int _score;
  Duration _timeAllowed;
  Duration _timeRemaining;

  ScoreScreen(this._score, this._timeAllowed, this._timeRemaining) :
    super() {

  }

  DivElement get rootElement => null;

  void onDraw(Element root) {

    DivElement el = new DivElement();

    DivElement beersEl = new DivElement();
    beersEl.text = "Beers Delivered: ${this._score}";

    DivElement timeEl = new DivElement();
    int s1 = this._timeAllowed.inSeconds;
    int s2 = this._timeRemaining.inSeconds;
    int s3 = s1 - s2;
    Duration timeTook = new Duration(seconds: s3);
    int minutes = timeTook.inMinutes;
    String formattedTime = "${minutes}:";
    int seconds = timeTook.inSeconds % 60;
    if (seconds < 10) {
      formattedTime = "${formattedTime}0${seconds}";
    } else {
      formattedTime = "${formattedTime}${seconds}";
    }
    timeEl.text = "You took ${formattedTime}!";

    el.append(beersEl);
    el.append(timeEl);
    el.classes = ["ui", "text"];
    root.append(
      el
    );
  }
}

