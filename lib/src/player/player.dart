part of player;

class Player extends GameObject implements ComponentListener {

  static final int BUZZ_PER_BEER = 1;
  static final int MAX_DRUNKENNESS = 10;
  static final int MIN_DRUNKENNESS = 0;


  bool _damaged = false;
  int _damageInterval = 0;
  int _damagedUntil = 0;
  int _beerStolenUntil = 0;

  bool _wasHitByCar = false;
  bool _wasBeerStolen = false;


  int _health = 3;
  int _beers = 0;
  int _buzz = 3;  // out of 10;

  int _nextBuzzDecreaseTS = new DateTime.now().millisecondsSinceEpoch ~/ 1000 + 35;

  int get drunkenness => this._buzz;
  int get beers => this._beers;
  int get health => this._health;

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  Player(Level l, Direction d, int x, int y) : super(d, x, y) {

    this.setLevel(l);

    SpriteSheet sprites = new SpriteSheet(
        "img/Character1Walk.png",
        64, 64);

    this.collisionXOffset = 17;
    this.collisionYOffset = 32;
    this.collisionWidth = 30;
    this.collisionHeight = 32;

    List<Sprite> walkUp = new List<Sprite>();
    List<Sprite> walkDown = new List<Sprite>();
    List<Sprite> walkLeft = new List<Sprite>();
    List<Sprite> walkRight = new List<Sprite>();
    for (int i = 0; i < 9; i++) {
      walkUp.add(sprites.spriteAt(i * 64, 0 * 64));
      walkLeft.add(sprites.spriteAt(i * 64, 1 * 64));
      walkDown.add(sprites.spriteAt(i * 64, 2 * 64));
      walkRight.add(sprites.spriteAt(i * 64, 3 * 64));
    }
    this._walkSprites[DIR_UP.direction] = new SpriteAnimation(walkUp);
    this._walkSprites[DIR_DOWN.direction] = new SpriteAnimation(walkDown);
    this._walkSprites[DIR_LEFT.direction] = new SpriteAnimation(walkLeft);
    this._walkSprites[DIR_RIGHT.direction] = new SpriteAnimation(walkRight);
  }

  void update() {
    if ( ! this.isRemoved) {

      // Reset some single-frame state variables
      this._wasHitByCar = false;
      this._wasBeerStolen = false;

      // Update super
      super.update();

      // Make him blink when hit
      if (this._damaged) {
        this._damageInterval++;

        if (this._damagedUntil <= new DateTime.now().millisecondsSinceEpoch) {
          this._damaged = false;
          this._damageInterval = 0;
        }
      }

      if (this._beerStolenUntil <= new DateTime.now().millisecondsSinceEpoch) {
        this._beerStolenUntil = 0;
      }
    }
  }

  void listen(GameEvent e) {
    if (e.type == GameEvent.TAKE_HIT_EVENT) {
      if ( ! this._damaged) {
        int damage = e.value;
        this._wasHitByCar = true;
        this._health -= damage;
        this._damaged = true;
        this._damagedUntil = new DateTime.now().millisecondsSinceEpoch + 2000;
      }
      if (this._health <= 0) {
        this.level.addAnimation(
            new Explosion.createAt(this.x, this.y,
                                   this.tileWidth, this.tileHeight));
        this.remove();
      }
    } else if (e.type == GameEvent.BEER_STOLEN_EVENT) {
      if (this._beerStolenUntil == 0 && this._beers > 0) {
        this._wasBeerStolen = true;
        this._beerStolenUntil = new DateTime.now().millisecondsSinceEpoch + 1000;
        this._beers -= e.value;
      }
    }
  }

  void beerStolen() {
    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._wasBeerStolen = true;
  }

  void drinkBeer() {
    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._buzz += BUZZ_PER_BEER;
  }

  void spawnBullet() {

    int x = this.x;
    int y = this.y;

    if (this.dir == DIR_RIGHT) {
      x += this.tileWidth ~/ 2;
      y += this.tileHeight ~/ 4;
    } else if (this.dir == DIR_LEFT) {
      y += this.tileHeight ~/ 4;
    } else if (this.dir == DIR_UP) {
      x += tileWidth ~/ 4;
    } else if (this.dir == DIR_DOWN) {
      x += this.tileWidth ~/ 4;
      y += this.tileHeight ~/ 2;
    }

    this.broadcast(new CreateBulletEvent(
        this.dir, this, x, y),
        [ this.level ]);
  }

  bool get wasHitByCar => this._wasHitByCar;
  bool get wasBeerStolen => this._wasBeerStolen;

  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getMoveSprite() {
    if (this._damaged && this._damageInterval % 3 == 0) {
      return null;
    }
    return this._walkSprites[this.dir.direction].getNext();
  }
  Sprite getStaticSprite() {
    this._walkSprites[this.dir.direction].reset();
    if (this._damaged && this._damageInterval % 3 == 0) {
      return null;
    }
    return this._walkSprites[this.dir.direction].getCur();
  }
}


