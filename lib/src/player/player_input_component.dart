part of player;

class PlayerInputComponent extends Component
  implements KeyboardListener {

  static final int BULLET_COOLDOWN = 10;
  static final int MAX_ACCELERATION = 4;

  Random _rng;

  Map<int, bool> _pressed;
  List<int> _accel;
  List<bool> _dirsPressed;
  DrawingComponent _drawer;

  bool _spawnBullet = false;
  bool _drinkBeer = false;
  int _bulletCooldown = 0;

  int _holdFrames = 0;
  bool _holding = false;

  PlayerInputComponent(this._drawer) {
    this._pressed = new Map<int, bool>();
    this._accel = new List<int>.filled(4, 0);
    this._dirsPressed = new List<bool>.filled(4, false);
    this._rng = new Random();
  }
  void update(Player obj) {

    for (int i = 0; i < 4; i++) {
      this._dirsPressed[i] = false;
    }
    if ((this._pressed[KeyboardListener.KEY_UP] == true ||
        this._pressed[KeyboardListener.KEY_W] == true)) {

      this._dirsPressed[DIR_UP.direction] = true;
      obj.dir = DIR_UP;
      this._holdFrames++;
    } else if ((this._pressed[KeyboardListener.KEY_DOWN] == true ||
        this._pressed[KeyboardListener.KEY_S] == true)) {

      this._dirsPressed[DIR_DOWN.direction]= true;
      obj.dir = DIR_DOWN;
      this._holdFrames++;
    }
    if ((this._pressed[KeyboardListener.KEY_LEFT] == true ||
        this._pressed[KeyboardListener.KEY_A] == true)) {

      this._dirsPressed[DIR_LEFT.direction]= true;
      obj.dir = DIR_LEFT;
      this._holdFrames++;
    } else if ((this._pressed[KeyboardListener.KEY_RIGHT] == true ||
        this._pressed[KeyboardListener.KEY_D] == true)) {

      this._dirsPressed[DIR_RIGHT.direction]= true;
      obj.dir = DIR_RIGHT;
      this._holdFrames++;
    }

    int playerX = obj.x;
    int playerY = obj.y;

    // Increase the acceleration in the direction that's being pressed.  For
    // every other direction, bring the acceleration back to zero.
    int speed = 0;
    for (int i = 0; i < 4; i++) {
      if (this._dirsPressed[i]) {
        if ((11 - obj.drunkenness) <= this._holdFrames) {
          this._accel[i] += 2 * obj.speed;
          if (this._accel[i] > obj.drunkenness * 2 * 2) {
            this._accel[i] = obj.drunkenness * 2 * 2;
          }
          this._holdFrames = 0;
        }
      } else if (this._accel[i] > 0) {
        this._accel[i]--;
      } else if (this._accel[i] < 0) {
        this._accel[i]++;
      }
      speed += this._accel[i];
    }

    playerX = playerX +
        (this._accel[DIR_RIGHT.direction] - this._accel[DIR_LEFT.direction]);// ~/ 2;
    playerY = playerY +
        (this._accel[DIR_DOWN.direction] - this._accel[DIR_UP.direction]);// ~/ 2;

  // Do a wobble thing, back and forth, because you're drunk
    if (speed > 0) {
      int max = min(this._accel[obj.dir.direction], 20);
      //window.console.log("accel: ${this._accel[obj.dir.direction]}, drunkenness: ${obj.drunkenness}");
      int wobble = this._rng.nextInt(11 - obj.drunkenness);
      if (wobble == 0)
      {
        Direction wobbleDir;
        int dir = this._rng.nextInt(2);
        if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
          if (dir == 0) {
            playerX -= obj.speed;
          } else {
            playerX += obj.speed;
          }
        } else {
          if (dir == 0) {
            playerY -= obj.speed;
          } else {
            playerY += obj.speed;
          }
        }
      }
    }

    obj.setPos(playerX, playerY);



    // Handle collision detection
    int row = (obj.y + obj.collisionYOffset) ~/ obj.level.tileHeight;
    int col = (obj.x + obj.collisionXOffset) ~/ obj.level.tileWidth;
    int row1 = (obj.y + obj.collisionYOffset + obj.collisionHeight) ~/
        obj.level.tileHeight;
    int col1 = (obj.x + obj.collisionXOffset + obj.collisionWidth) ~/
        obj.level.tileWidth;

    if (obj.level.isBlocking(row, col) ||
        obj.level.isBlocking(row1, col) ||
        obj.level.isBlocking(row, col1) ||
        obj.level.isBlocking(row1, col1)) {
      obj.setPos(obj.oldX, obj.oldY);
    }

    if (this._bulletCooldown > 0) {
      this._bulletCooldown--;
    }

    if (this._spawnBullet) {
      if (this._bulletCooldown == 0) {
        obj.spawnBullet();
        this._bulletCooldown = PlayerInputComponent.BULLET_COOLDOWN;
      }
      this._spawnBullet = false;
    }

    if (this._drinkBeer) {
      obj.drinkBeer();
      this._drinkBeer = false;
    }
  }

  void onKeyDown(KeyboardEvent e) {
    this._pressed[e.keyCode] = true;

    this._holding = true;
  }
  void onKeyUp(KeyboardEvent e) {
    this._pressed[e.keyCode] = false;

    this._holding = false;
  }
  void onKeyPressed(KeyboardEvent e) {
    if (e.keyCode == KeyboardListener.KEY_SPACE) {
      //this._spawnBullet = true;
      this._drinkBeer = true;
    }
  }
}

