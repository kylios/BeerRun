part of beer_run;

class ScoreScreen extends Dialog {

  bool _win;
  int _score;
  int _convertedScore;
  int _totalScore;
  Duration _timeAllowed;
  Duration _timeRemaining;
  Button _nextButton;

  DivElement get rootElement => null;

    factory ScoreScreen(UIInterface ui, bool win,
            int score, int convertedScore, int totalScore,
            Duration timeAllowed, Duration timeRemaining) {

        // the main body view
        View contents = new View(ui);

        TextView winText = new TextView(ui, "YOU WON!");
        winText.style.textAlign = "center";
        winText.style.marginLeft = "auto";
        winText.style.marginRight = "auto";
        winText.style.width = "256px";
        winText.style.color = "black";
        winText.style.background = "#CC9900";
        winText.style.padding = "12px";
        winText.style.borderRadius = "8px";
        winText.style.height = "24px";
        winText.style.fontWeight = "bold";
        winText.style.fontSize = "22px";
        winText.style.marginBottom = "8px";
        contents.addView(winText);


        // BEERS
        View beersEl = new View(ui);
        beersEl.style.marginLeft = "auto";
        beersEl.style.marginRight = "auto";
        beersEl.style.width = "50%";

        ImageView beersIcon = new ImageView.fromSrc(ui, "img/ui/icons/beer.png", 48, 48);
        beersIcon.style.float = "left";
        beersIcon.style.margin = "5px";
        beersEl.addView(beersIcon);

        TextView beersTextEl = new TextView(ui, "${score} beers delivered");
        beersTextEl.style.fontWeight = "bold";
        beersTextEl.style.fontSize = "22px";
        beersTextEl.style.height = "58px";
        beersEl.addView(beersTextEl);

        /*
        DivElement beersClearEl = new DivElement();
        beersClearEl.style.clear = "both";
        beersEl.append(beersClearEl);
        */

        contents.addView(beersEl);

        // TIME
        View timeEl = new View(ui);
        timeEl.style.marginLeft = "auto";
        timeEl.style.marginRight = "auto";
        timeEl.style.width = "50%";

        ImageView clockIcon = new ImageView.fromSrc(ui, "img/ui/icons/clock.png", 48, 48);
        clockIcon.style.float = "left";
        clockIcon.style.margin = "5px";
        timeEl.addView(clockIcon);

        String formattedTime = ScoreScreen._getFormattedTime(timeAllowed, timeRemaining);

        TextView timeTextEl = new TextView(ui, "You took ${formattedTime}!");
        timeTextEl.style.fontWeight = "bold";
        timeTextEl.style.fontSize = "22px";
        timeTextEl.style.height = "58px";
        timeEl.addView(timeTextEl);

        /*
         timeClearEl = new DivElement();
        timeClearEl.style.clear = "both";
        timeEl.append(timeClearEl);
        */

        contents.addView(timeEl);

        // SCORE
        View scoreEl = new View(ui);
        scoreEl.style.marginLeft = "auto";
        scoreEl.style.marginRight = "auto";
        scoreEl.style.width = "256px";
        scoreEl.style.background = "#5482a9";
        scoreEl.style.padding = "12px";
        scoreEl.style.borderRadius = "8px";
        scoreEl.style.height = "24px";

        TextView scoreTextEl = new TextView(ui, "Your Score: ${totalScore}");
        scoreTextEl.style.fontWeight = "bold";
        scoreTextEl.style.fontSize = "22px";
        scoreTextEl.style.height = "58px";
        scoreTextEl.style.marginLeft = "auto";
        scoreTextEl.style.marginRight = "auto";
        scoreEl.addView(scoreTextEl);

        // TOTAL SCORE
        View tScoreEl = new View(ui);
        tScoreEl.style.marginLeft = "auto";
        tScoreEl.style.marginRight = "auto";
        tScoreEl.style.width = "50%";
        tScoreEl.style.color = "red";

        View totalBottomEl = new View(ui);
        totalBottomEl.style.borderTop = "1px solid blue";
        totalBottomEl.style.margin = "4px 8px";

        TextView totalTextEl = new TextView(ui, "${totalScore - convertedScore}");
        totalTextEl.style.color = "blue";
        totalTextEl.style.fontSize = "22px";
        totalTextEl.style.float = "right";
        totalTextEl.style.clear = "both";
        totalBottomEl.addView(totalTextEl);

        TextView tScoreTextEl = new TextView(ui, "+ ${convertedScore}");
        tScoreTextEl.style.fontSize = "20px";
        tScoreTextEl.style.height = "58px";
        tScoreTextEl.style.float = "right";
        tScoreTextEl.style.clear = "both";
        totalBottomEl.addView(tScoreTextEl);
        /*
        DivElement tClearEl = new DivElement();
        tClearEl.style.clear = "both";

        totalBottomEl.append(tClearEl);
                */

        tScoreEl.addView(totalBottomEl);

        contents.addView(tScoreEl);


        contents.addView(scoreEl);


        ScoreScreen screen = new ScoreScreen._internal(ui, contents);
        screen.addButton(new Button(ui, "Next", () => screen.close(null)));

        return screen;
    }

    ScoreScreen._internal(UIInterface ui, View contents) :
        super(ui, contents);

    static String _getFormattedTime(Duration timeAllowed, Duration timeRemaining) {

        int s1 = timeAllowed.inSeconds;
        int s2 = timeRemaining.inSeconds;
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

        return formattedTime;
    }

    /*
  void onDraw(Element root) {

    DivElement el = new DivElement();
    el.style.lineHeight = "24px";





    el.classes.add("ui");
    el.classes.add("text");
    root.append(
      el
    );
  }
  */
}

