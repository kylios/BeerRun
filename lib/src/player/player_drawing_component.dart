part of player;

class PlayerDrawingComponent extends DrawingComponent {

  static final DIRECTION_CHANGE_EVENT = 1;
  static final UPDATE_STEP_EVENT = 2;

  //List<SpriteAnimation> _walkSprites;
  List<Sprite> _beerSprites;

  PlayerDrawingComponent(CanvasManager manager, CanvasDrawer drawer, bool scrollBackground) :
      super(manager, drawer, scrollBackground){

      /*
    SpriteSheet sprites = new SpriteSheet(
        "assets/sprites/player/player.png",
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
    this._walkSprites = new List<SpriteAnimation>(4);
    this._walkSprites[DIR_UP.direction] = new SpriteAnimation(walkUp);
    this._walkSprites[DIR_DOWN.direction] = new SpriteAnimation(walkDown);
    this._walkSprites[DIR_LEFT.direction] = new SpriteAnimation(walkLeft);
    this._walkSprites[DIR_RIGHT.direction] = new SpriteAnimation(walkRight);
*/
    SpriteSheet beerSprites = new SpriteSheet(
        "assets/sprites/player/beer.png",
        64, 64);

    Sprite beerUp = beerSprites.spriteAtNew(0, 0);
    Sprite beerLeft = beerSprites.spriteAtNew(1, 0);
    Sprite beerDown = beerSprites.spriteAtNew(2, 0);
    Sprite beerRight = beerSprites.spriteAtNew(3, 0);

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

    /*
    this.drawer.backgroundColor = "white";
    double row = obj.y / 16;
    double col = obj.x / 16;
    this.drawer.drawText("${col},${row}", obj.x, obj.y, relative: true);
    */
  }
}