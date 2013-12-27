part of ui;

class GameOverScreen extends Dialog {

  factory GameOverScreen(UIInterface ui, String reason) {

    // the main body view
    View contents = new View(ui);

    // The title of the dialog: the level name
    TextView title = new TextView(ui, "GAME OVER");
    title.style.fontWeight = "bold";
    title.style.fontSize = "22px";

    TextView reasonView = new TextView(ui, reason);
    reasonView.style.fontWeight = "bold";

    contents.addView(title);
    contents.addView(reasonView);

    GameOverScreen screen =
        new GameOverScreen._internal(ui, contents);
    screen.addButton(new Button(ui, "Fine!", () { screen.close(); }));

    return screen;
  }

  GameOverScreen._internal(UIInterface ui, View contents) :
    super(ui, contents);
}