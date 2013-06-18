part of beer_run;

class ScoreScreen extends View {

  bool _win;
  int _score;
  int _convertedScore;
  int _totalScore;
  Duration _timeAllowed;
  Duration _timeRemaining;
  Button _nextButton;

  DivElement get rootElement => null;

  ScoreScreen(this._win,
      this._score, this._convertedScore, this._totalScore,
      this._timeAllowed, this._timeRemaining) :
    super() {

    this._nextButton = new Button("Next", this.close);
  }

  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.style.lineHeight = "24px";

    // WIN OR LOSE?
    DivElement winLoseEl = new DivElement();
    winLoseEl.text = (this._win ? "YOU WON!" : "GAME OVER");
    winLoseEl.style.textAlign = "center";
    winLoseEl.style.marginLeft = "auto";
    winLoseEl.style.marginRight = "auto";
    winLoseEl.style.width = "256px";
    winLoseEl.style.color = (this._win ? "black" : "white");
    winLoseEl.style.background = (this._win ? "#CC9900" : "#CC0000");
    winLoseEl.style.padding = "12px";
    winLoseEl.style.borderRadius = "8px";
    winLoseEl.style.height = "24px";
    winLoseEl.style.fontWeight = "bold";
    winLoseEl.style.fontSize = "22px";
    winLoseEl.style.marginBottom = "8px";
    el.append(winLoseEl);

    // BEERS
    DivElement beersEl = new DivElement();
    beersEl.style.marginLeft = "auto";
    beersEl.style.marginRight = "auto";
    beersEl.style.width = "50%";

    ImageElement beersIcon = new ImageElement();
    beersIcon.src = "img/ui/icons/beer.png";
    beersIcon.style.float = "left";
    beersIcon.style.margin = "5px";
    beersIcon.width = 48;
    beersIcon.height = 48;
    beersEl.append(beersIcon);

    DivElement beersTextEl = new DivElement();
    beersTextEl.text = "${this._score} beers delivered";
    beersTextEl.style.fontWeight = "bold";
    beersTextEl.style.fontSize = "22px";
    beersTextEl.style.height = "58px";
    beersEl.append(beersTextEl);

    DivElement beersClearEl = new DivElement();
    beersClearEl.style.clear = "both";
    beersEl.append(beersClearEl);

    el.append(beersEl);

    // TIME
    DivElement timeEl = new DivElement();
    timeEl.style.marginLeft = "auto";
    timeEl.style.marginRight = "auto";
    timeEl.style.width = "50%";

    ImageElement clockIcon = new ImageElement();
    clockIcon.src = "img/ui/icons/clock.png";
    clockIcon.style.float = "left";
    clockIcon.style.margin = "5px";
    clockIcon.width = 48;
    clockIcon.height = 48;
    timeEl.append(clockIcon);

    DivElement timeTextEl = new DivElement();
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
    timeTextEl.text = "You took ${formattedTime}!";
    timeTextEl.style.fontWeight = "bold";
    timeTextEl.style.fontSize = "22px";
    timeTextEl.style.height = "58px";
    timeEl.append(timeTextEl);

    DivElement timeClearEl = new DivElement();
    timeClearEl.style.clear = "both";
    timeEl.append(timeClearEl);

    el.append(timeEl);

    DivElement scoreEl = new DivElement();
    scoreEl.style.marginLeft = "auto";
    scoreEl.style.marginRight = "auto";
    scoreEl.style.width = "256px";
    scoreEl.style.background = "#5482a9";
    scoreEl.style.padding = "12px";
    scoreEl.style.borderRadius = "8px";
    scoreEl.style.height = "24px";

    DivElement scoreTextEl = new DivElement();
    scoreTextEl.text = "Your Score: ${this._totalScore}";
    scoreTextEl.style.fontWeight = "bold";
    scoreTextEl.style.fontSize = "22px";
    scoreTextEl.style.height = "58px";
    scoreTextEl.style.marginLeft = "auto";
    scoreTextEl.style.marginRight = "auto";
    scoreEl.append(scoreTextEl);

    // TOTAL SCORE
    DivElement tScoreEl = new DivElement();
    tScoreEl.style.marginLeft = "auto";
    tScoreEl.style.marginRight = "auto";
    tScoreEl.style.width = "50%";
    tScoreEl.style.color = "red";

    DivElement totalBottomEl = new DivElement();
    totalBottomEl.style.borderTop = "1px solid blue";
    totalBottomEl.style.margin = "4px 8px";

    DivElement totalTextEl = new DivElement();
    totalTextEl.text = "${this._totalScore - this._convertedScore}";
    totalTextEl.style.color = "blue";
    totalTextEl.style.fontSize = "22px";
    totalTextEl.style.float = "right";
    totalTextEl.style.clear = "both";
    totalBottomEl.append(totalTextEl);

    DivElement tScoreTextEl = new DivElement();
    tScoreTextEl.text = "+ ${this._convertedScore}";
    tScoreTextEl.style.fontSize = "20px";
    tScoreTextEl.style.height = "58px";
    tScoreTextEl.style.float = "right";
    tScoreTextEl.style.clear = "both";
    totalBottomEl.append(tScoreTextEl);

    DivElement tClearEl = new DivElement();
    tClearEl.style.clear = "both";
    totalBottomEl.append(tClearEl);

    tScoreEl.append(totalBottomEl);

    el.append(tScoreEl);


    el.append(scoreEl);


    this._nextButton.draw(el);

    el.classes.add("ui");
    el.classes.add("text");
    root.append(
      el
    );
  }
}

