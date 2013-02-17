part of npc;

class NPC extends GameObject {

  int _health = 3;

  bool _damaged = false;
  int _damageInterval = 0;
  int _damagedUntil = 0;

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  NPC(Level l, Direction d, int x, int y) : super(d, x, y) {

    this.setLevel(l);

    SpriteSheet sprites = new SpriteSheet(
        "img/Character1Walk.png",
        this.tileWidth, this.tileHeight);

    List<Sprite> walkUp = new List<Sprite>();
    List<Sprite> walkDown = new List<Sprite>();
    List<Sprite> walkLeft = new List<Sprite>();
    List<Sprite> walkRight = new List<Sprite>();
    for (int i = 0; i < 9; i++) {
      walkUp.add(sprites.spriteAt(i * this.tileHeight, 0 * this.tileWidth));
      walkLeft.add(sprites.spriteAt(i * this.tileHeight, 1 * this.tileWidth));
      walkDown.add(sprites.spriteAt(i * this.tileHeight, 2 * this.tileWidth));
      walkRight.add(sprites.spriteAt(i * this.tileHeight, 3 * this.tileWidth));
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
    window.console.log("took a hit");
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


