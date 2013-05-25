part of car;

class Car extends GameObject {

  int _type;

  final SpriteSheet _horiz;
  final SpriteSheet _vert;

  Car(GamePath p, Direction d, this._type, this._vert, this._horiz) :
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

  GamePoint get point => new GamePoint(this.x, this.y);

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
    int t = this._type;
    if (this.dir == DIR_UP) {
      return this._vert.spriteAt(96 * (t + 1), 0, 96, 160);
      //return Data._carSpriteSheetData["car${t}Up"];
    } else if (this.dir == DIR_RIGHT) {
      return this._horiz.spriteAt(160, 96 * t, 160, 96);
      //return Data._carSpriteSheetData["car${t}Right"];
    } else if (this.dir == DIR_DOWN) {
      return this._vert.spriteAt(96 * (t * 3), 0, 96, 160);
      //return Data._carSpriteSheetData["car${t}Down"];
    } else {
      return this._horiz.spriteAt(0, 96 * t, 160, 96);
      //return Data._carSpriteSheetData["car${t}Left"];
    }
  }
  Sprite getStaticSprite() {
    return this.getMoveSprite();
  }

  void listen(GameEvent e) {}
}