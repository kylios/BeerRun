part of car;

class Car extends GameObject {

  List<Sprite> _sprites;

  Car(Path p, Direction d, this._sprites) :
    super(d, p.start.x, p.start.y) {
    this.speed = 6;
    this.setControlComponent(new PathFollowerInputComponent(p));
  }

  void update() {
    super.update();

    GameObject obj = this.level.collidesWithPlayer(this);
    if (obj != null) {
      GameEvent e = new GameEvent();
      e.type = GameEvent.TAKE_HIT_EVENT;
      e.value = 1;
      Timer.run(() => obj.listen(e));
    }
  }

  void takeHit() {}

  Point get point => new Point(this.x, this.y);

  int get tileWidth {
    if (this.dir == DIR_UP || this.dir == DIR_DOWN) {
      return 64;
    } else {
      return 106;
    }
  }

  int get tileHeight {
    if (this.dir == DIR_UP || this.dir == DIR_DOWN) {
      return 106;
    } else {
      return 64;
    }
  }

  Sprite getMoveSprite() {
    return this._sprites[this.dir.direction];
  }
  Sprite getStaticSprite() {
    return this._sprites[this.dir.direction];
  }

  void listen(GameEvent e) {}
}