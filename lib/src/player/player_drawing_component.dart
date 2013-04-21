part of player;

class PlayerDrawingComponent extends DrawingComponent {

  static final DIRECTION_CHANGE_EVENT = 1;
  static final UPDATE_STEP_EVENT = 2;

  List<SpriteAnimation> _walkSprites;
  List<Sprite> _beerSprites;

  PlayerDrawingComponent(CanvasManager manager, CanvasDrawer drawer, bool scrollBackground) :
      super(manager, drawer, scrollBackground){

    SpriteSheet sprites = new SpriteSheet(
        "img/player/player.png",
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
    this._walkSprites = new List<SpriteAnimation>(4);
    this._walkSprites[DIR_UP.direction] = new SpriteAnimation(walkUp);
    this._walkSprites[DIR_DOWN.direction] = new SpriteAnimation(walkDown);
    this._walkSprites[DIR_LEFT.direction] = new SpriteAnimation(walkLeft);
    this._walkSprites[DIR_RIGHT.direction] = new SpriteAnimation(walkRight);

    SpriteSheet beerSprites = new SpriteSheet(
        "img/player/beer.png",
        64, 64);

    Sprite beerUp = beerSprites.spriteAt(0, 0);
    Sprite beerLeft = beerSprites.spriteAt(0, 64);
    Sprite beerDown = beerSprites.spriteAt(0, 128);
    Sprite beerRight = beerSprites.spriteAt(0, 192);

    this._beerSprites = new List<Sprite>(4);
    this._beerSprites[DIR_UP.direction] = beerUp;
    this._beerSprites[DIR_DOWN.direction] = beerDown;
    this._beerSprites[DIR_LEFT.direction] = beerLeft;
    this._beerSprites[DIR_RIGHT.direction] = beerRight;
  }

  void update(Player obj) {

    if (this.scrollBackground) {
      this.drawer.setOffset(
        obj.x + obj.tileWidth - (this.manager.width ~/ 2),
        obj.y + obj.tileHeight - (this.manager.height ~/ 2)
      );
    }

    Sprite s;
    if (obj.x == obj.oldX && obj.y == obj.oldY) {
      s = obj.getStaticSprite();
    } else {
      s = obj.getMoveSprite();
    }
    if (obj.beers > 0) {
      this.drawer.drawSprite(this._beerSprites[obj.dir.direction],
          obj.x, obj.y, obj.tileWidth, obj.tileHeight);
    }
    this.drawer.drawSprite(s, obj.x, obj.y, obj.tileWidth, obj.tileHeight);
    //this._drawer.backgroundColor = "black";
    //this._drawer.drawRect(obj.x, obj.y, obj.tileWidth, obj.tileHeight, 0, 0, true);

  }
}