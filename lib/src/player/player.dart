part of player;

class Player extends GameObject implements ComponentListener {

  static final int BUZZ_PER_BEER = 1;
  static final int MAX_DRUNKENNESS = 10;
  static final int MIN_DRUNKENNESS = 0;
  static final int DAMAGE_INTERVAL = 50;
  static final int BUZZ_TIME = 35000;

  StatsManager _stats;

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
  int _buzz = 3;  // out of 10;
  int _buzzDecreaseTime = -1;

  int _nextBuzzDecreaseTS = new DateTime.now().millisecondsSinceEpoch ~/ 1000 + 35;

  int get drunkenness => this._buzz;
  int get beers => this._beers;
  int get health => this._health;

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  Player(this._stats) : super(DIR_DOWN, 0, 0) {

    this.speed = 6;

    SpriteSheet sprites = new SpriteSheet(
        "img/player/player.png",
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
  }

  void startInLevel(Level l) {
    this.setLevel(l);
    this.setPos(l.startX, l.startY);
    this.dir = DIR_UP;
    this.resetBeersDelivered();

    this.setHealth(3);
    this.addBeers(300);
  }

  void setHealth(int health) {
    this._health = health;
    this._stats.health = health;
  }

  void addBeers(int beers) {
    this._beers += beers;
    this._stats.beers = beers;
  }
  void resetBeersDelivered() {
    this._beersDelivered = 0;
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

      // Reset some single-frame state variables
      this._wasHitByCar = false;
      this._wasBeerStolen = false;

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
        if (this._buzz <= 3) {
          this._boredNotify = true;
          this.level.addAnimation(new TextAnimation(
             "*YAWN*",
             this.x, this.y, 3
          ));
        }
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
        DateTime now = new DateTime.now();
        this._damageInterval = now.millisecondsSinceEpoch +
            Player.DAMAGE_INTERVAL;
        this._damagedUntil = now.millisecondsSinceEpoch + 3000;
        this.level.addAnimation(
            new TextAnimation("OUCH!", this.x, this.y, 2));

        this._stats.health = this._health;
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
        this.level.addAnimation(
            new TextAnimation("-1 BEER!", this.x, this.y, 2));

        this._stats.beers = this._beers;
      }
    } else if (e.type == GameEvent.BEER_STORE_EVENT) {
      if (this._beers < 24) {
        int diff = 24 - this._beers;
        this.level.addAnimation(
            new TextAnimation("+${diff} BEERS!", this.x, this.y, 2));
      }
      this._beers = 24;
      this._beenToStore = true;

      this._stats.beers = this._beers;
    } else if (e.type == GameEvent.PARTY_ARRIVAL_EVENT && this._beenToStore) {
      // Only trigger if you've gone to the store at least once

      // TODO stats.score <- update
      //this._score += this._player.beersDelivered;



      // Gain score
      //this._stats.beers += this._beers;
      this._beersDelivered += this._beers;

      this._beers = 0;
      this.level.addAnimation(
          new TextAnimation("FUCK YEAH!", this.x, this.y, 2));

      GameManager g = new GameManager();

      GameEvent addScoreEvent = new GameEvent();
      addScoreEvent.type = GameEvent.ADD_SCORE_EVENT;
      addScoreEvent.value = this._beers;
      this.broadcast(addScoreEvent, [ g ]);

      if (this._beersDelivered >= this.level.beersToWin) {
        // send event to the game

        GameEvent e = new GameEvent();
        e.type = GameEvent.GAME_WON_EVENT;
        e.creator = this;
        e.value = 0;
        this.broadcast(e, [
                           g
                          ]);
      } else {

        // TODO: pass a message to the game manager to show this
        g.showView(
            new Message(g.ui, "Sick dude, beers! We'll need you to bring us more though.  Go back and bring us more beer!"));
      }
    }

  }

  /*
  void beerStolen() {
    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._wasBeerStolen = true;
  }
  */

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

    if (this._buzz >= 8) {
      this._drunkNotify = true;
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

  bool get wasHitByCar => this._wasHitByCar;
  bool get wasBeerStolen => this._wasBeerStolen;
  int get beersDelivered => this._beersDelivered;
  bool get boredNotify => this._boredNotify;
  bool get drunkNotify => this._drunkNotify;

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


