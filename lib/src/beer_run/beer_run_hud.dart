part of beer_run;

class BeerRunHUD {

  static final List<String> _STAGES = [
                                        "BORED",  // 0
                                        "SOBER",
                                        "BUZZED",
                                        "TIPSY",
                                        "TIPSY",
                                        "SLOPPY",
                                        "DRUNK",
                                        "DRUNK",
                                        "WASTED",
                                        "HAMMERED",
                                        "BLACKOUT"  // 10
                                       ];
  static final List<String> _COLORS = [
                                       "red",
                                       "red",
                                       "orange",
                                       "yellow",
                                       "yellow",
                                       "lightgreen",
                                       "green",
                                       "yellow",
                                       "orange",
                                       "red",
                                       "red"
                                       ];
  static final ImageElement _BEER_METER =
      new ImageElement(src: "img/ui/icons/beer_meter.png");

  CanvasDrawer _drawer;

  Player _player;

  BeerRunHUD(this._drawer, this._player);

  void draw() {

    int bac = this._player.drunkenness;
    String word = BeerRunHUD._STAGES[bac];

    int hudWidth = 164;
    int iconWidth = 70;

    this._drawer.backgroundColor = "rgba(24, 24, 24, 0.5)";
    this._drawer.fillRect(0, 0, hudWidth, 84);
    this._drawer.drawImage(BeerRunHUD._BEER_METER, 0, 0);

    this._drawer.font = "bold 14px sans-serif";
    this._drawer.backgroundColor = "white";
    var dim = this._drawer.measureText("YOU ARE");
    this._drawer.drawText("YOU ARE",
        (hudWidth - dim.width) ~/ 2 + iconWidth ~/ 2, 32);

    this._drawer.font = "bold 16px sans-serif";
    this._drawer.backgroundColor = BeerRunHUD._COLORS[bac];
    dim = this._drawer.measureText(word);
    this._drawer.drawText(word,
        (hudWidth - dim.width) ~/ 2 + iconWidth ~/ 2, 48);
  }
}