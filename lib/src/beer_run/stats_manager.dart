part of beer_run;

class StatsManager {

    DivElement _beersElement;
    DivElement _healthElement;
    DivElement _durationElement;

    // Flagged when a stat has changed so we know to update the dom
    bool _changedBeers = false;
    bool _changedHealth = false;
    bool _changedDuration = false;

    int _beers = 0;
    int _health = 0;
    Duration _duration = new Duration();

    int _fps = 0;

    StatsManager(DivElement stats) {
        this._beersElement = stats.querySelector('div#beers');
        this._healthElement = stats.querySelector('div#health');
        this._durationElement = stats.querySelector('div#duration');
    }

    set beers(int b) {
        this._beers = b;
        this._changedBeers = true;
    }

    set health(int h) {
        this._health = h;
        this._changedHealth = true;
    }

    set duration(Duration d) {
        this._duration = d;
        this._changedDuration = true;
    }

    void update() {

        // Don't update the DOM if nothing has changed
        if (this._changedDuration) {

            int m = this._duration.inMinutes;
            int s = this._duration.inSeconds % 60;
            String sFmt = "$s";
            if (s < 10) {
                sFmt = "0$sFmt";
            }
            String mFmt = "$m";
            if (m < 10) {
                mFmt = "0$mFmt";
            }
            String timeFmt = "$mFmt:$sFmt";
            this._durationElement.innerHtml = timeFmt;
            this._changedDuration = false;
        }

        if (this._changedBeers) {

            String bFmt = "${this._beers}";
            if (this._beers < 10) {
                bFmt = "0$bFmt";
            }
            this._beersElement.innerHtml = bFmt;
            this._changedBeers = false;
        }

        if (this._changedHealth) {
            this._healthElement.innerHtml = "";
            for (int i = 0; i < this._health; i++) {
                this._healthElement.append(this._makeHeart());
            }

            this._changedHealth = false;
        }

    }

    ImageElement _makeHeart() {

        ImageElement img = new ImageElement();
        img.src = 'img/ui/heart.png';
        return img;
    }
}
