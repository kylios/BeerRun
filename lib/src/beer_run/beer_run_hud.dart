part of beer_run;

class BeerRunHUD {

  CanvasDrawer _drawer;

  int _beers = 0;
  int _health = 0;
  int _bac = 0;
  Duration _time = new Duration();

  BeerRunHUD(this._drawer) {

  }

  void update(int beers, int health, int bac, Duration time) {
    this._beers = beers;
    this._health = health;
    this._bac = bac;
    this._time = time;
  }

  void draw() {

  }
}