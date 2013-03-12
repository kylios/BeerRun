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


  /**
   * TODO: when player gets drunk, he should accelerate as you hold down the
   * movement keys.  He should accelerate up to a certain point that gets higher
   * and higher the drunker he gets.  I think changing directions should be less
   * responsive: that is, he gains some momentum in a given direction, and when
   * you change directions, he decelerates in the original direction, but starts
   * accelerating in the new direction.  That and he can overcompensate by
   * "wobbling" back to the old direction.
   *
   *         +----- overcompensation for the turn
   *         v
   *          ...
   *        .     .   . . . .  .  .   .   .   .
   *       .        .
   *
   *       .         ^
   *                 +----------------- "bounce back", like he's stumbling
   *       .
   *
   *       .
   *
   *       .    <--- getting faster here
   *       .
   *       .
   *       X    <--- START
   *
   *
   * This effect should get greater and more pronounced the more beers he drinks
   *
   * It would also be cool if we could apply a neat blurring effect to the level
   *
   *
   * Algorithm:
   *
   * We'll implement a directional acceleration system.  There will be a
   * 4-element array of ints, representing the acceleration in each given
   * direction.  Each frame, the acceleration is applied to the player's
   * position.
   *
   *
   *
   *
   *
   */
  void _moveObj(Player obj, Direction dir) {



    if (this._holdFrames == 0) {
      obj.speed = 4;
    }

    if (this._holding) {
      this._holdFrames++;
      obj.speed = 4 + (this._holdFrames * obj.drunkenness ~/ 16);
    } else {
      if (this._holdFrames == 1) {
        this._holdFrames = 0;
      } else {
        this._holdFrames =
            (this._holdFrames ~/ obj.drunkenness) * (obj.drunkenness - 2);
      }
      obj.speed = 4 + this._holdFrames * obj.drunkenness;
    }

    if (obj.speed > 16) {
      obj.speed = 16;
    }

    // Do a wobble thing, back and forth, because you're drunk
    int wobble = this._rng.nextInt(18 - obj.speed);
    if (wobble == 0)
    {
      Direction wobbleDir;
      int dir = this._rng.nextInt(2);
      if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
        if (dir == 0) {
          this._moveLeft(obj, obj.speed ~/ 4);
        } else {
          this._moveRight(obj, obj.speed ~/ 4);
        }
      } else {
        if (dir == 0) {
          this._moveUp(obj, obj.speed ~/ 4);
        } else {
          this._moveDown(obj, obj.speed ~/ 4);
        }
      }
    }

    if (dir == DIR_UP) {
      this._moveUp(obj);
    } else if (dir == DIR_DOWN) {
      this._moveDown(obj);
    } else if (dir == DIR_LEFT) {
      this._moveLeft(obj);
    } else if (dir == DIR_RIGHT) {
      this._moveRight(obj);
    }

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

  }

  void _moveLeft(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    obj.setPos(obj.x - speed, obj.y);
    obj.faceLeft();
  }
  void _moveRight(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    obj.setPos(obj.x + speed, obj.y);
    obj.faceRight();
  }
  void _moveUp(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    obj.setPos(obj.x, obj.y - speed);
    obj.faceUp();
  }
  void _moveDown(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    obj.setPos(obj.x, obj.y + speed);
    obj.faceDown();
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
        if ((11 - obj.drunkenness) == this._holdFrames) {
          this._accel[i] += obj.speed;
          if (this._accel[i] > obj.drunkenness * 2) {
            this._accel[i] = obj.drunkenness * 2;
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

    playerX = playerX + (this._accel[DIR_RIGHT.direction] - this._accel[DIR_LEFT.direction]);
    playerY = playerY + (this._accel[DIR_DOWN.direction] - this._accel[DIR_UP.direction]);

  // Do a wobble thing, back and forth, because you're drunk
    if (speed > 0) {
      int wobble = this._rng.nextInt(21 - this._accel[obj.dir.direction]);
      if (wobble == 0)
      {
        Direction wobbleDir;
        int dir = this._rng.nextInt(2);
        if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
          if (dir == 0) {
            playerX -= 2;
          } else {
            playerX += 2;
          }
        } else {
          if (dir == 0) {
            playerY -= 2;
          } else {
            playerY += 2;
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

