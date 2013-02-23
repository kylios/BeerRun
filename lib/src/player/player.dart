part of player;

class Player extends GameObject {

  static final int BUZZ_PER_BEER = 1;
  static final int MAX_DRUNKENNESS = 10;
  static final int MIN_DRUNKENNESS = 0;

  int _beers;
  int _buzz;

  int _health = 3;

  bool _damaged = false;
  int _damageInterval = 0;
  int _damagedUntil = 0;

  // Movement parameters

  int _balance = 1;
  int _drunkenness = 8;  // out of 10

  int get drunkenness => this._drunkenness;

  // TODO: add stuff for drunkenness :-P

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  Player(Level l, Direction d, int x, int y) : super(d, x, y) {

    this.setLevel(l);

    SpriteSheet sprites = new SpriteSheet(
        "img/Character1Walk.png",
        64, 64);

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
      super.update();

      if (this._damaged) {
        this._damageInterval++;

        if (this._damagedUntil <= new Date.now().millisecondsSinceEpoch) {
          this._damaged = false;
          this._damageInterval = 0;
        }
      }
    }
  }

  void takeHit() {
    if ( ! this._damaged) {
      this._health--;
      this._damaged = true;
      this._damagedUntil = new Date.now().millisecondsSinceEpoch + 2000;
    }
    if (this._health <= 0) {

      this.level.addAnimation(
          new Explosion.createAt(this.x, this.y,
                                 this.tileWidth, this.tileHeight));
      this.remove();
    }
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


