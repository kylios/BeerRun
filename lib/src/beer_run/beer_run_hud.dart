part of beer_run;

class BeerRunHUD {

    static final List<String> _STAGES = ["BORED", // 0
        "SOBER", "BUZZED", "TIPSY", "TIPSY", "SLOPPY", "DRUNK", "DRUNK",
                "WASTED", "HAMMERED", "BLACKOUT" // 10
    ];
    static final List<String> _COLORS = ["red", "red", "orange", "yellow",
            "yellow", "lightgreen", "green", "yellow", "orange", "red", "red"];
    static final ImageElement _BEER_METER = new ImageElement(src:
            "img/ui/icons/beer_meter.png");

    CanvasDrawer _drawer;

    Player _player;

    NumberFormat _bacFormat = new NumberFormat('0.00', 'en_US');

    // Timestamps to make the HUD flash
    int _onTime = 0;
    int _offTime = 0;
    bool _flashing = false;

    BeerRunHUD(this._drawer, this._player);

    void startFlashing() {
        if (!this._flashing) {
            int time = new DateTime.now().millisecondsSinceEpoch;
            this._flashing = true;
            this._onTime = time + 250;
            this._offTime = 0;
        }
    }
    void stopFlashing() {
        this._flashing = false;
        this._onTime = 0;
        this._offTime = 0;
    }

    void draw() {

        int time = new DateTime.now().millisecondsSinceEpoch;

        int bac = this._player.drunkenness;
        String word = BeerRunHUD._STAGES[bac];

        int hudWidth = 164;
        int iconWidth = 70;

        this._fillBeer(bac);

        this._drawer.backgroundColor = "rgba(24, 24, 24, 0.5)";
        this._drawer.fillRect(0, 0, hudWidth, 84);
        this._drawer.drawImage(BeerRunHUD._BEER_METER, 0, 0);



        this._drawer.font = "bold 14px sans-serif";
        this._drawer.backgroundColor = "white";
        var dim = this._drawer.measureText("YOU ARE");
        this._drawer.drawText("YOU ARE", (hudWidth - dim.width) ~/ 2 + iconWidth
                ~/ 2, 32);


        // Make the text flash
        if (!this._flashing || (this._flashing && time <= this._onTime)) {
            this._drawer.font = "bold 16px sans-serif";
            this._drawer.backgroundColor = BeerRunHUD._COLORS[bac];
            dim = this._drawer.measureText(word);
            this._drawer.drawText(word, (hudWidth - dim.width) ~/ 2 + iconWidth
                    ~/ 2, 48);
        }
        if (this._flashing) {
            if (this._onTime != 0 && this._onTime < time) {
                this._onTime = 0;
                this._offTime = time + 250;
            } else if (this._offTime != 0 && this._offTime < time) {
                this._offTime = 0;
                this._onTime = time + 250;
            }
        }

        num realBAC = 0.28 * bac / 10;

        this._drawer.font = "bold 12px sans-serif";
        this._drawer.backgroundColor = "white";
        this._drawer.drawText("BAC: ${this._bacFormat.format(realBAC)}",
                (hudWidth - dim.width) ~/ 2 + iconWidth ~/ 2, 64);
    }

    void _fillBeer(int bac) {

        // Figure out the dimensions
        // TODO: make this better?
        int height = bac * 53 ~/ 10;
        int xOffset = height ~/ 7;

        CanvasRenderingContext2D c = this._drawer.context;

        // save state
        c.save();

        // translate context
        //c.translate(this._drawer.canvas.width / 2, this._drawer.canvas.height / 2);

        // scale context horizontally
        c.scale(2, 0.5);

        c.beginPath();
        c.moveTo(6 /*11*/, 71 * 2);
        c.arc(18 /*34*/, 71 * 2, 12 /*23*/, PI, PI * 2, true);

        c.lineTo((58 + xOffset) ~/ 2, (71 - height) * 2);
        c.arc(18, (71 - height) * 2, 10 + xOffset, PI * 2, PI, true);

        //c.lineTo((12 - xOffset) ~/ 2, (71 - height) * 2);
        c.lineTo(6 /*11*/, 71 * 2);
        c.closePath();

        c.fillStyle = "#cc6600";
        c.fill();

        c.strokeStyle = "#ff9933";
        c.stroke();


        c.restore();
        /*
    DrawingPath p = this._drawer.getPath();
    p.addPoint(new GamePoint(11, 71));
    p.addCurve(new GameCurve(PI , PI * 2, true));
    p.addPoint(new GamePoint(58, 71));
    p.addPoint(new GamePoint(58 + xOffset, 71 - height));
    p.addPoint(new GamePoint(11 - xOffset, 71 - height));
    //p.addPoint(new GamePoint(11, 71));

    p.setFill(true);
    p.setBackgroundColor("#cc6600");
    //p.draw();

    p.setFill(false);
    p.setForegroundColor("#ff9933");
    p.draw();
    */
    }
}
