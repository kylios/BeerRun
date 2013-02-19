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

    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    if ((this._pressed[KeyboardListener.KEY_UP] == true ||
        this._pressed[KeyboardListener.KEY_W] == true)) {
      if (! obj.level.isBlocking(row - 1, col)) {
        obj.moveUp();
      } else {
        obj.faceUp();
      }
    } else if ((this._pressed[KeyboardListener.KEY_DOWN] == true ||
        this._pressed[KeyboardListener.KEY_S] == true)) {
      if (! obj.level.isBlocking(row + 1, col)) {
        obj.moveDown();
      } else {
        obj.faceDown();
      }
    }
    if ((this._pressed[KeyboardListener.KEY_LEFT] == true ||
        this._pressed[KeyboardListener.KEY_A] == true)) {
      if (! obj.level.isBlocking(row, col - 1)) {
        obj.moveLeft();
      } else {
        obj.faceLeft();
      }
    } else if ((this._pressed[KeyboardListener.KEY_RIGHT] == true ||
        this._pressed[KeyboardListener.KEY_D] == true)) {
      if (! obj.level.isBlocking(row, col + 1)) {
        obj.moveRight();
      } else {
        obj.faceRight();
      }
    }


    // Translate the character's x,y into row and col

    int oldRow = obj.oldY ~/ obj.level.tileHeight;
    int oldCol = obj.oldX ~/ obj.level.tileWidth;

    bool up = (obj.y < obj.oldY);
    bool down = (obj.y > obj.oldY);
    bool left = (obj.x < obj.oldX);
    bool right = (obj.x > obj.oldX);


    // if collided from top or collided from bottom
    //if ((down && obj.level))


    /*
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

      if (row == t[0].toInt() && col == t[1].toInt()) {
        if (obj.dir == DIR_LEFT || obj.dir == DIR_RIGHT) {
          zeroX = true;
        } else if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
          zeroY = true;
        }
      }


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
        window.console.log("zeroX");
      }
      if (zeroY) {
        obj.setPos(obj.x, pY1_old);
        window.console.log("zeroY");
      }
      if (zeroX || zeroY) {
        break;
      }
    }
    */





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

