part of player;

class Player extends GameObject implements GameEventListener {

  static final int BUZZ_PER_BEER = 1;
  static final int MAX_DRUNKENNESS = 10;
  static final int MIN_DRUNKENNESS = 0;
  static final int DAMAGE_INTERVAL = 50;
  static final int BUZZ_TIME = 35000;

  GameManager _mgr;
  StatsManager _stats;

  Song drinkBeerSfx;

  bool _damaged = false;
  int _damageInterval = 0;
  int _blinkInterval = 0;
  int _damagedUntil = 0;
  int _beerStolenUntil = 0;

  bool _wasHitByCar = false;
  bool _wasBeerStolen = false;
  bool _beenToStore = false;
  bool _boredNotify = false;
  bool _drunkNotify = false;
  int _beersDelivered = 0;

  int _health = 0;
  int _beers = 0;
  int _buzz = 0;  // out of 10;
  int _buzzDecreaseTime = -1;

  int _nextBuzzDecreaseTS = new DateTime.now().millisecondsSinceEpoch ~/ 1000 + 35;

  int get drunkenness => this._buzz;
  int get beers => this._beers;
  int get health => this._health;

  StreamController<int> _beersStream;
  StreamController<int> _beersDeliveredStream;
  StreamController<int> _healthChangedStream;

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  Player(this._mgr, this._stats) : super(DIR_DOWN, 0, 0) {

    SpriteSheet sprites = new SpriteSheet(
        "assets/sprites/player/player.png",
        64, 64);

    this.collisionXOffset = 16;
    this.collisionYOffset = 32;
    this.collisionWidth = 32;
    this.collisionHeight = 32;

    List<Sprite> walkUp = new List<Sprite>();
    List<Sprite> walkDown = new List<Sprite>();
    List<Sprite> walkLeft = new List<Sprite>();
    List<Sprite> walkRight = new List<Sprite>();
    for (int i = 0; i < 9; i++) {
      walkUp.add(sprites.spriteAtNew(0, i));
      walkLeft.add(sprites.spriteAtNew(1, i));
      walkDown.add(sprites.spriteAtNew(2, i));
      walkRight.add(sprites.spriteAtNew(3, i));
    }
    this._walkSprites[DIR_UP.direction] = new SpriteAnimation(walkUp);
    this._walkSprites[DIR_DOWN.direction] = new SpriteAnimation(walkDown);
    this._walkSprites[DIR_LEFT.direction] = new SpriteAnimation(walkLeft);
    this._walkSprites[DIR_RIGHT.direction] = new SpriteAnimation(walkRight);

    this._beersStream = new StreamController<int>();
    this._beersDeliveredStream = new StreamController<int>();
  }

  Stream<int> get onBeerDelta => this._beersStream.stream;
  Stream<int> get onBeerDelivered => this._beersDeliveredStream.stream;

  void startInLevel(Level l) {
    this.setLevel(l);
    this.setPos(l.startX * l.tileWidth, l.startY * l.tileHeight, true);
    this.dir = DIR_UP;
    this.resetBeersDelivered();

    this.setHealth(l.startHealth);
    this.setBeers(l.startBeers);

    this._buzz = 3;
    this._beenToStore = false;

    //this.onBeerDelta.takeWhile((var _) => true);
    //this.onBeerDelivered.takeWhile((var _) => true);
  }

  void setHealth(int health) {
    this._health = health;
    this._stats.health = health;
  }

  void setBeers(int beers) {
      this._beers = beers;
      this._beersStream.add(this._beers);
  }

  void resetBeers() {
      this.setBeers(0);
  }

  void addBeers(int beers) {
    this._beers += beers;
    this._beersStream.add(this._beers);
  }

  void resetBeersDelivered() {
    this._beersDelivered = 0;
    this._beersDeliveredStream.add(this._beersDelivered);
  }

  void addBeersDelivered(int beers) {
    this._beersDelivered += beers;
    this._beersDeliveredStream.add(this._beersDelivered);
  }

  void updateBuzzTime() {
    this._buzzDecreaseTime = new DateTime.now().millisecondsSinceEpoch +
        Player.BUZZ_TIME;
  }

  void _blink(DateTime now) {
    if (this._damagedUntil <= now.millisecondsSinceEpoch) {
      this._damaged = false;
      this._damageInterval = 0;
      this._blinkInterval = 0;
    } else {
      if (this._damageInterval > -1 &&
          this._damageInterval <= now.millisecondsSinceEpoch) {
        this._blinkInterval = now.millisecondsSinceEpoch + 17;
        this._damageInterval = -1;
      } else if (this._blinkInterval <= now.millisecondsSinceEpoch) {
        this._damageInterval = now.millisecondsSinceEpoch +
            17;
      }
    }
  }

  void update() {

      DateTime now = new DateTime.now();
      if ( ! this.isRemoved) {

          if (this._buzzDecreaseTime == 0) {
            this.updateBuzzTime();
          }

          // Update super
          super.update();

          // Make him blink when hit
          if (this._damaged) {
            this._blink(now);
          }

          if (this._beerStolenUntil <= new DateTime.now().millisecondsSinceEpoch) {
            this._beerStolenUntil = 0;
          }

          if (this._buzzDecreaseTime > 0 &&
              this._buzzDecreaseTime <= now.millisecondsSinceEpoch) {
            this._buzz--;
            this._buzzDecreaseTime = now.millisecondsSinceEpoch + Player.BUZZ_TIME;
            if (this._buzz <= 3 && !this._boredNotify) {
              this.level.addAnimation(new TextAnimation(
                 "*YAWN*",
                 this.x, this.y, 3
              ));

              GameNotification n = new GameNotification("Your buzz is wearing off!  Drink a beer before things get too boring.<br />Use [space] to crack one open.", imgUrl: "assets/ui/keyboard/Keyboard_White_Space.png");
              this.broadcast(n, [ this._mgr ]);
            }
          }
      }
  }

  void listen(GameEvent e) {

    if (e.type == GameEvent.TAKE_HIT_EVENT) {
      if ( ! this._damaged) {
        int damage = e.value;
        this._health -= damage;
        this._damaged = true;
        DateTime now = new DateTime.now();
        this._damageInterval = now.millisecondsSinceEpoch +
            Player.DAMAGE_INTERVAL;
        this._damagedUntil = now.millisecondsSinceEpoch + 3000;
        this.level.addAnimation(
            new TextAnimation("OUCH!", this.x, this.y, 2));

        this._stats.health = this._health;

        if (!this._wasHitByCar) {
            GameNotification n = new GameNotification("Fuck.  Watch where you're going!");
            this.broadcast(n, [ this._mgr ]);
            this._wasHitByCar = true;
        }
      }
      if (this._health <= 0) {
        this.level.addAnimation(
            new Explosion.createAt(this.x, this.y,
                                   this.tileWidth, this.tileHeight));
        this.remove();
      }
    } else if (e.type == GameEvent.BEER_STOLEN_EVENT) {
      if (this._beerStolenUntil == 0 && this._beers > 0) {
        this._beerStolenUntil = new DateTime.now().millisecondsSinceEpoch + 1000;
        this._beers -= e.value;
        this.level.addAnimation(
            new TextAnimation("-1 BEER!", this.x, this.y, 2));

        this._stats.beers = this._beers;

        if (!this._wasBeerStolen) {
            GameNotification n = new GameNotification("Ohhh, the bum stole a beer!  One less for you!");
            this.broadcast(n, [ this._mgr ]);
            this._wasBeerStolen = true;
        }
      }
    } else if (e.type == GameEvent.BEER_STORE_EVENT) {
        if (this._beers < e.value) {
            int diff = e.value - this._beers;
            this.level.addAnimation(
                new TextAnimation("+${diff} BEERS!", this.x, this.y, 2));
        }
        this._beers = e.value;
        this._beenToStore = true;

        this._stats.beers = this._beers;
    } else if (e.type == GameEvent.PARTY_ARRIVAL_EVENT) {
        if (this._beenToStore && this._beers > 0) {

            // Only trigger if you've gone to the store at least once

            // Gain score
            this.addBeersDelivered(this._beers);
            this.resetBeers();

            this.level.addAnimation(
                    new TextAnimation("FUCK YEAH!", this.x, this.y, 2));


        }
    }
  }

  void drinkBeer() {

    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._buzz += BUZZ_PER_BEER;
    this._buzzDecreaseTime =
        new DateTime.now().millisecondsSinceEpoch + Player.BUZZ_TIME;

    this.level.addAnimation(new TextAnimation(
        "+${BUZZ_PER_BEER} BUZZ", this.x, this.y - 16, 3));
    this.level.addAnimation(new TextAnimation(
        "-1 BEER", this.x, this.y + 8, 3));

    if (this._buzz >= 8 && !this._drunkNotify) {
      GameNotification n = new GameNotification("Be careful, don't get too drunk!");
      this.broadcast(n, [ this._mgr ]);
      this._drunkNotify = true;
    }

    if (this.drinkBeerSfx != null) {
      this.drinkBeerSfx.play();
    }

    this._stats.beers = this._beers;
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

  int get beersDelivered => this._beersDelivered;

  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getMoveSprite() {
    if (this._damaged && this._damageInterval >
        new DateTime.now().millisecondsSinceEpoch) {
      return null;
    }
    return this._walkSprites[this.dir.direction].getNext();
  }
  Sprite getStaticSprite() {

    this._walkSprites[this.dir.direction].reset();
    if (this._damaged && this._damageInterval >
        new DateTime.now().millisecondsSinceEpoch) {
      return null;
    }
    return this._walkSprites[this.dir.direction].getCur();
  }
}


