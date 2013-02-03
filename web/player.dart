library player;

class Player {

  static final int BUZZ_PER_BEER = 1;

  int _x;
  int _y;
  int _beers;
  int _buzz;

  // Movement parameters
  int _speed = 5;
  int _balance = 1;
  // TODO: add stuff for drunkenness :-P

  int get x => this._x;
  int get y => this._y;
  int get beers => this._beers;
  int get buzz => this._buzz;

  void giveBeers(int num) {
    this._beers += num;
  }

  void drinkBeer() {
    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._buzz += BUZZ_PER_BEER;
  }

  void moveUp() {
    this._y -= this._speed;
  }
  void moveDown() {
    this._y += this._speed;
  }
  void moveLeft() {
    this._x -= this._speed;
  }
  void moveRight() {
    this._x += this._speed;
  }
}
