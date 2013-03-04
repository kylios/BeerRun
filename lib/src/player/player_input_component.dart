part of player;

class PlayerInputComponent extends Component
  implements KeyboardListener {

  static final int BULLET_COOLDOWN = 10;
  static final int MAX_ACCELERATION = 4;

  Random _rng;

  Map<int, bool> _pressed;
  DrawingComponent _drawer;

  bool _spawnBullet = false;
  bool _drinkBeer = false;
  int _bulletCooldown = 0;

  int _holdFrames = 0;
  bool _holding = false;

  PlayerInputComponent(this._drawer) {
    this._pressed = new Map<int, bool>();
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
   * if keypressed:
   *    increment holdKey
   *
   * acceleration = holdKey * drunkenness
   * speed += acceleration
   *
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

    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    obj.setPos(obj.x - speed, obj.y);
    obj.faceLeft();
  }
  void _moveRight(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    obj.setPos(obj.x + speed, obj.y);
    obj.faceRight();
  }
  void _moveUp(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    obj.setPos(obj.x, obj.y - speed);
    obj.faceUp();
  }
  void _moveDown(Player obj, [int speed]) {
    if (! ?speed) {
      speed = obj.speed;
    }

    int row = obj.y ~/ obj.level.tileHeight;
    int col = obj.x ~/ obj.level.tileWidth;

    obj.setPos(obj.x, obj.y + speed);
    obj.faceDown();
  }

  void update(Player obj) {

    if ((this._pressed[KeyboardListener.KEY_UP] == true ||
        this._pressed[KeyboardListener.KEY_W] == true) ||
        (this._holdFrames > 0 && obj.dir == DIR_UP)) {

      this._moveObj(obj, DIR_UP);
    } else if ((this._pressed[KeyboardListener.KEY_DOWN] == true ||
        this._pressed[KeyboardListener.KEY_S] == true) ||
        (this._holdFrames > 0 && obj.dir == DIR_DOWN)) {

      this._moveObj(obj, DIR_DOWN);
    }
    if ((this._pressed[KeyboardListener.KEY_LEFT] == true ||
        this._pressed[KeyboardListener.KEY_A] == true) ||
        (this._holdFrames > 0 && obj.dir == DIR_LEFT)) {

      this._moveObj(obj, DIR_LEFT);
    } else if ((this._pressed[KeyboardListener.KEY_RIGHT] == true ||
        this._pressed[KeyboardListener.KEY_D] == true) ||
        (this._holdFrames > 0 && obj.dir == DIR_RIGHT)) {

      this._moveObj(obj, DIR_RIGHT);
    }


    // Translate the character's x,y into row and col

    int oldRow = obj.oldY ~/ obj.level.tileHeight;
    int oldCol = obj.oldX ~/ obj.level.tileWidth;

    bool up = (obj.y < obj.oldY);
    bool down = (obj.y > obj.oldY);
    bool left = (obj.x < obj.oldX);
    bool right = (obj.x > obj.oldX);

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

