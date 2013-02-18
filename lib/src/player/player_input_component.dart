part of player;

class SimpleInputComponent extends Component
  implements KeyboardListener {

  static final int BULLET_COOLDOWN = 10;

  Map<int, bool> _pressed;
  DrawingComponent _drawer;

  bool _spawnBullet = false;
  int _bulletCooldown = 0;

  SimpleInputComponent(this._drawer) {
    this._pressed = new Map<int, bool>();
  }

  void update(Player obj) {

    if (this._pressed[KeyboardListener.KEY_UP] == true ||
        this._pressed[KeyboardListener.KEY_W] == true) {
      obj.moveUp();
    } else if (this._pressed[KeyboardListener.KEY_DOWN] == true ||
        this._pressed[KeyboardListener.KEY_S] == true) {
      obj.moveDown();
    }
    if (this._pressed[KeyboardListener.KEY_LEFT] == true ||
        this._pressed[KeyboardListener.KEY_A] == true) {
      obj.moveLeft();
    } else if (this._pressed[KeyboardListener.KEY_RIGHT] == true ||
        this._pressed[KeyboardListener.KEY_D] == true) {
      obj.moveRight();
    }


    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    // Get surrounding tiles
    List<List> tiles = [
      [row - 1, col - 1, obj.level.isBlocking(row - 1, col - 1)],
      [row - 1, col, obj.level.isBlocking(row - 1, col)],
      [row - 1, col + 1, obj.level.isBlocking(row - 1, col + 1)],
      [row, col + 1, obj.level.isBlocking(row, col + 1)],
      [row + 1, col + 1, obj.level.isBlocking(row + 1, col + 1)],
      [row + 1, col, obj.level.isBlocking(row + 1, col)],
      [row + 1, col - 1, obj.level.isBlocking(row + 1, col - 1)],
      [row, col - 1, obj.level.isBlocking(row, col - 1)],
    ];


    // Collision detection
    for (List t in tiles) {

      int oX1 = t[1].toInt() * obj.level.tileWidth;
      int oX2 = oX1 + obj.level.tileWidth;
      int oY1 = t[0].toInt() * obj.level.tileHeight;
      int oY2 = oY1 + obj.level.tileHeight;

      int pX1 = obj.x;
      int pX2 = obj.x + obj.tileWidth;
      int pY1 = obj.y;
      int pY2 = obj.y + obj.tileHeight;

      int pX1_old = obj.oldX;
      int pX2_old = obj.oldX + obj.tileWidth;
      int pY1_old = obj.oldY;
      int pY2_old = obj.oldY + obj.tileHeight;

      bool zeroX = false;
      bool zeroY = false;

      if (obj.dir == DIR_LEFT && pX1 <= oX2 && pX1_old > oX2 &&
          ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
          ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
        zeroX = true;
      } else if (obj.dir == DIR_RIGHT && pX2 >= oX1 && pX2_old < oX1 &&
          ((pY1 <= oY2 && pY1 >= oY1) || (pY2 <= oY2 && pY2 >= oY1)) &&
          ((pY1_old <= oY2 && pY1_old >= oY1) || (pY2_old <= oY2 && pY2_old >= oY1))) {
        zeroX = true;
      }
      if (obj.dir == DIR_UP && pY1 <= oY2 && pY1_old > oY2 &&
          ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
          ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
        zeroY = true;
      } else if (obj.dir == DIR_DOWN && pY2 >= oY1 && pY2_old < oY1 &&
          ((pX1 <= oX2 && pX1 >= oX1) || (pX2 <= oX2 && pX2 >= oX1)) &&
          ((pX1_old <= oX2 && pX1_old >= oX1) || (pX2_old <= oX2 && pX2_old >= oX1))) {
        zeroY = true;
      }

      if (zeroX) {
        obj.setPos(pX1_old, obj.y);
      }
      if (zeroY) {
        obj.setPos(obj.x, pY1_old);
      }

      if (zeroX || zeroY) {
        //break;
      }
    }





    if (this._bulletCooldown > 0) {
      this._bulletCooldown--;
    }

    if (this._spawnBullet) {
      if (this._bulletCooldown == 0) {
        obj.spawnBullet();
        this._bulletCooldown = SimpleInputComponent.BULLET_COOLDOWN;
      }
      this._spawnBullet = false;
    }
  }

  void onKeyDown(KeyboardEvent e) {
    this._pressed[e.keyCode] = true;
  }
  void onKeyUp(KeyboardEvent e) {
    this._pressed[e.keyCode] = false;
  }
  void onKeyPressed(KeyboardEvent e) {
    if (e.keyCode == KeyboardListener.KEY_SPACE) {
      this._spawnBullet = true;
    }
  }
}

