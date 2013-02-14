part of game;

abstract class GameObject {

  int _speed = 5;

  int _x = 0;
  int _y = 0;

  int oldX;
  int oldY;

  Direction _dir;

  Component _control;

  Level _level;
  bool _remove = false;

  DrawingComponent _drawer;

  int get tileWidth;
  int get tileHeight;
  DrawingComponent get drawer => this._drawer;

  Sprite getStaticSprite();
  Sprite getMoveSprite();

  int get x => this._x;
  int get y => this._y;
  Direction get dir => this._dir;
  int get numSteps => 9;
  Level get level => this._level;
  bool get isRemoved => this._remove;

  void remove() {
    window.console.log("removed");
    this._remove = true;
  }

  GameObject(this._dir, this._x, this._y);

  void setControlComponent(Component c) {
    this._control = c;
  }

  void setDrawingComponent(DrawingComponent d) {
    this._drawer = d;
  }

  void setLevel(Level l) {
    this._level = l;
  }

  void setSpeed(int s) {
    this._speed = s;
  }

  void update() {

    this.oldX = this.x;
    this.oldY = this.y;
    this._control.update(this);
  }

  void moveUp() {
    this._dir = DIR_UP;
    this._y -= this._speed;
  }
  void moveDown() {
    this._dir = DIR_DOWN;
    this._y += this._speed;
  }
  void moveLeft() {
    this._dir = DIR_LEFT;
    this._x -= this._speed;
  }
  void moveRight() {
    this._dir = DIR_RIGHT;
    this._x += this._speed;
  }

  void broadcast(GameEvent e, Collection<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      l.listen(e);
    }
  }
}

