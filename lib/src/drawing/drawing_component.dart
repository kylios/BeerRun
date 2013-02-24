part of drawing;

class DrawingComponent extends Component
  implements ComponentListener
{

  static final DIRECTION_CHANGE_EVENT = 1;
  static final UPDATE_STEP_EVENT = 2;

  CanvasDrawer _drawer;
  CanvasManager _manager;

  bool _scrollBackground = false;

  DrawingComponent(this._manager, this._drawer, this._scrollBackground);

  void update(GameObject obj) {

    if (this._scrollBackground) {
      this._drawer.setOffset(
        obj.x + obj.tileWidth - (this._manager.width ~/ 2),
        obj.y + obj.tileHeight - (this._manager.height ~/ 2)
      );
    }

    Sprite s;
    if (obj.x == obj.oldX && obj.y == obj.oldY) {
      s = obj.getStaticSprite();
    } else {
      s = obj.getMoveSprite();
    }
    this._drawer.drawSprite(s, obj.x, obj.y, obj.tileWidth, obj.tileHeight);
    //this._drawer.backgroundColor = "black";
    //this._drawer.drawRect(obj.x, obj.y, obj.tileWidth, obj.tileHeight, 0, 0, true);

  }

  void listen(GameEvent e) {

    if (null == e) {
      return;
    }
  }

  static GameEvent directionChangeEvent(Direction d) {

    GameEvent e = new GameEvent();
    e.type = DrawingComponent.DIRECTION_CHANGE_EVENT;
    e.data["dir"] = d;
    return e;
  }
}

