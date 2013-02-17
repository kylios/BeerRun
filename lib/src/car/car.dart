part of car;

class Car extends GameObject {

  List<Sprite> _sprites;

  Car(Path p, Direction d, this._sprites) :
    super(d, p.start.x, p.start.y) {
    this.setSpeed(6);
    this.setControlComponent(new PathFollowerInputComponent(p));
  }

  void update() {
    super.update();

    List<GameObject> objs = this.level.checkCollision(this);
    if (objs != null) {
      for (GameObject o in objs) {
        o.takeHit();
      }
    }
  }

  void takeHit() {}

  Point get point => new Point(this.x, this.y);

  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getMoveSprite() {
    return this._sprites[this.dir.direction];
  }
  Sprite getStaticSprite() {
    return this._sprites[this.dir.direction];
  }
}