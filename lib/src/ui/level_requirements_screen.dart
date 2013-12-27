part of ui;

class LevelRequirementsScreen extends Dialog {

  String _name;
  int _beers;
  Duration _time;

  DivElement get rootElement => null;

  factory LevelRequirementsScreen(UIInterface ui,
      String name, int beers, Duration duration) {

    // the main body view
    View contents = new View(ui);

    // The title of the dialog: the level name
    View levelName = new View(ui);
    levelName.style.background = "white";
    levelName.style.color = "black";
    levelName.style.padding = "4px";
    levelName.style.display = "inline-block";

    TextView levelNameText = new TextView(ui, name);
    levelName.style.fontWeight = "bold";
    levelName.style.fontSize = "22px";

    levelName.addView(levelNameText);

    // The beers row
    View beersEl = new View(ui);
    beersEl.style.margin = "4px";

    ImageView beersIcon = new ImageView.fromSrc(ui,
        "img/ui/icons/beer.png", 32, 32);

    TextView beersText = new TextView(ui, "Bring ${beers} beers to the party");
    beersText.style.fontWeight = "bold";

    beersEl.addView(beersIcon);
    beersEl.addView(beersText);
    beersEl.floatElements();

    // The time row
    View timeEl = new View(ui);
    timeEl.style.margin = "4px";

    ImageView clockIcon = new ImageView.fromSrc(ui,
        "img/ui/icons/clock.png", 32, 32);

    int hours = duration.inHours;
    int seconds = duration.inSeconds % 60;
    int minutes = duration.inMinutes % 60;
    String formattedTime = "${hours}:";
    if (minutes < 10) {
      formattedTime = "${formattedTime}0${minutes}:";
    } else {
      formattedTime = "${formattedTime}${minutes}:";
    }
    if (seconds < 10) {
      formattedTime = "${formattedTime}0${seconds}";
    } else {
      formattedTime = "${formattedTime}${seconds}";
    }
    TextView timeText = new TextView(ui, "You have ${formattedTime}!");
    timeText.style.fontWeight = "bold";

    timeEl.addView(clockIcon);
    timeEl.addView(timeText);
    timeEl.floatElements();

    contents.addView(levelName);
    contents.addView(beersEl);
    contents.addView(timeEl);

    LevelRequirementsScreen screen =
        new LevelRequirementsScreen._internal(ui, contents);
    screen.addButton(new Button(ui, "Start!", () { screen.close(); }));

    return screen;
  }

  /**
   * Internal constructor just identical to Dialog's constructor.
   */
  LevelRequirementsScreen._internal(UIInterface ui, View contents) :
    super(ui, contents);
}