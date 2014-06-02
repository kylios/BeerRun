part of bullet;

class Bullet extends GameObject {

  List<Sprite> _moveSprites = new List<Sprite>(4);

  GameObject _creator = null;

  Bullet(Level l, this._creator, Direction d, int x, int y,
      Component c, DrawingComponent drw) :
    super(d, x, y)
  {
    this.setLevel(l);
    this.setControlComponent(c);
    this.setDrawingComponent(drw);

    this.speed = 8;

    SpriteSheet sprites = new SpriteSheet(
        "img/Muzzleflashes-Shots.png",
        32, 32);

    this._moveSprites[DIR_DOWN.direction] = sprites.spriteAtNew(1, 0);
    this._moveSprites[DIR_RIGHT.direction] = sprites.spriteAtNew(1, 1);
    this._moveSprites[DIR_UP.direction] = sprites.spriteAtNew(1, 2);
    this._moveSprites[DIR_LEFT.direction] = sprites.spriteAtNew(1, 3);
  }

  void takeHit() {
    this.remove();
  }

  void update() {
    super.update();

    if (this.level.isOffscreen(this)) {
      this.remove();
    } else {

      // Check collisions.  Remove bullet from map and deal some damage
      List<GameObject> objs = this.level.checkCollision(this);
      if (objs != null) {
        GameObject o = objs.removeLast();
        while (objs.length > 0 && o == this._creator) {
          assert(o != this);
          o = objs.removeLast();
        }
        if (o != this._creator) {
          GameEvent e = new GameEvent(GameEvent.TAKE_HIT_EVENT, 1);
          Timer.run(() => o.listen(e));
          this.remove();
        }
      } else {

        this.drawer.update(this);
      }
    }
  }

  void listen(GameEvent e) {}

  int get tileWidth => 32;
  int get tileHeight => 32;

  Sprite getStaticSprite() {
    return this._moveSprites[this.dir.direction];
  }
  Sprite getMoveSprite() {
    return this._moveSprites[this.dir.direction];
  }
}

