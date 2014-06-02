part of npc;

class NPC extends GameObject implements GameEventListener {

  int _health = 3;

  bool _damaged = false;
  int _damageInterval = 0;
  int _damagedUntil = 0;
  String _name; // mainly for debugging

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  NPC(Level l, Direction d, int x, int y, this._name) : super(d, x, y) {

    this.setLevel(l);

    SpriteSheet sprites = new SpriteSheet(
        "assets/sprites/bum.png",
        64, 64);

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

  void update() {
    if ( ! this.isRemoved) {
      super.update();

      // If you're hit
      if (this._damaged) {
        this._damageInterval++;

        if (this._damagedUntil <= new DateTime.now().millisecondsSinceEpoch) {
          this._damaged = false;
          this._damageInterval = 0;
        }
      } else {
        // Only if you're not damaged can you steel beer
        GameObject obj = this.level.collidesWithPlayer(this);
        if (obj != null) {
          GameEvent e = new GameEvent(GameEvent.BEER_STOLEN_EVENT, 1);
          Timer.run(() => obj.listen(e));
        }
      }
    }
  }

  void listen(GameEvent e) {
    if (e.type == GameEvent.TAKE_HIT_EVENT) {
      if ( ! this._damaged) {
        this._health -= e.value;
        this._damaged = true;
        this._damagedUntil = new DateTime.now().millisecondsSinceEpoch + 2000;
      }
      if (this._health <= 0) {

        this.level.addAnimation(
            new Explosion.createAt(this.x, this.y,
                                   this.tileWidth, this.tileHeight));
        this.remove();
      }
    }
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


