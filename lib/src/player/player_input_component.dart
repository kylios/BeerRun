part of player;

class PlayerInputComponent extends Component
  implements KeyboardListener {

  static final int ACCEL_MOD = 1;
  static final int MAX_ACCEL = 8;
  static final double ACCEL_EASING = 0.1;

  // Identify which keys control our character
  static final List<int> MOVE_LEFT_KEYS = [
      KeyboardListener.KEY_LEFT,
      KeyboardListener.KEY_A
                                            ];
  static final List<int> MOVE_RIGHT_KEYS = [
      KeyboardListener.KEY_RIGHT,
      KeyboardListener.KEY_D
                                            ];
  static final List<int> MOVE_UP_KEYS = [
      KeyboardListener.KEY_UP,
      KeyboardListener.KEY_W
                                         ];
  static final List<int> MOVE_DOWN_KEYS = [
      KeyboardListener.KEY_DOWN,
      KeyboardListener.KEY_S
                                           ];
  static final int DRINK_BEER_KEY = KeyboardListener.KEY_SPACE;

  Random _rng;

  double _horizAccel = 0.0;
  double _vertAccel = 0.0;
  Direction _horizDir = null;
  Direction _vertDir = null;

  Map<Direction, bool> _pressed = {
                                    DIR_UP: false,
                                    DIR_DOWN: false,
                                    DIR_LEFT: false,
                                    DIR_RIGHT: false
  };

  PlayerInputComponent() {
    this._rng = new Random();
  }

  void update(Player obj) {

    // Increase acceleration depending on what we're pressing
    if (this._pressed[DIR_UP] && this._vertAccel > -1 * MAX_ACCEL) {
      this._vertAccel -= ACCEL_MOD;
      obj.dir = DIR_UP;
    } else if (this._pressed[DIR_DOWN] && this._vertAccel < MAX_ACCEL) {
      this._vertAccel += ACCEL_MOD;
      obj.dir = DIR_DOWN;
    }
    if (this._pressed[DIR_LEFT] && this._horizAccel > -1 * MAX_ACCEL) {
      this._horizAccel -= ACCEL_MOD;
      obj.dir = DIR_LEFT;
    } else if (this._pressed[DIR_RIGHT] && this._horizAccel < MAX_ACCEL) {
      this._horizAccel += ACCEL_MOD;
      obj.dir = DIR_RIGHT;
    }


    int newX = obj.x;
    int newY = obj.y;
    bool zeroHorizAccel = false;
    bool zeroVertAccel = false;

    // If we aren't pressing any keys, decelerate
    if (! this._pressed[DIR_UP] && ! this._pressed[DIR_DOWN]){
      if (this._vertAccel > 0) {
        int tileY = ((1 + newY ~/ 16) * 16);
        int dist = (tileY - newY);
        if (dist > 1) {
          this._vertAccel -= dist * ACCEL_EASING;
          if (this._vertAccel < 1) {
            this._vertAccel = 1.0;
          }
        } else {
          this._vertAccel = (tileY - newY).toDouble();
          zeroVertAccel = true;
        }
      } else if (this._vertAccel < 0) {
        int tileY = ((newY ~/ 16) * 16);
        int dist = (newY - tileY);
        if (dist > 1) {
          this._vertAccel += dist * ACCEL_EASING;
          if (this._vertAccel > -1) {
            this._vertAccel = -1.0;
          }
        } else {
          this._vertAccel = (tileY - newY).toDouble();
          zeroVertAccel = true;
        }
      }
    }

    if (! this._pressed[DIR_LEFT] && ! this._pressed[DIR_RIGHT]) {
      if (this._horizAccel > 0) {
        int tileX = ((1 + newX ~/ 16) * 16);
        int dist = (tileX - newX);
        //window.console.log("my x: ${newX}, tile x: ${((1 + newX ~/ 16) * 16.0)}");
        //window.console.log("dist: ${dist}, horizAccel: ${this._horizAccel}");
        if (dist > 1) {
          this._horizAccel -= dist * ACCEL_EASING;
          if (this._horizAccel < 1) {
            this._horizAccel = 1.0;
          }
        } else {
          this._horizAccel = (tileX - newX).toDouble();
          zeroHorizAccel = true;
        }
      } else if (this._horizAccel < 0) {
        int tileX = ((newX ~/ 16) * 16);
        int dist = (newX - tileX);
        //window.console.log("my x: ${newX}, tile x: ${tileX}");
        //window.console.log("dist: ${dist}, horizAccel: ${this._horizAccel}");
        if (dist > 1) {
          this._horizAccel += dist * ACCEL_EASING;
          if (this._horizAccel > -1) {
            this._horizAccel = -1.0;
          }
        } else {
          this._horizAccel = (tileX - newX).toDouble();
          zeroHorizAccel = true;
        }
      }
    }

    if (this._horizAccel > 15) {
      this._horizAccel = 15.0;
    } else if (this._horizAccel < -15) {
      this._horizAccel = -15.0;
    }
    if (this._vertAccel > 15) {
      this._vertAccel = 15.0;
    } else if (this._vertAccel < -15) {
      this._vertAccel = -15.0;
    }

    // handle collisions
    Level l = obj.level;

    int row = (newY + obj.collisionYOffset) ~/ obj.level.tileHeight;
    int col = (newX + obj.collisionXOffset) ~/ obj.level.tileWidth;
    int row1 = (newY + obj.collisionYOffset + obj.collisionHeight) ~/
        obj.level.tileHeight;
    int col1 = (newX + obj.collisionXOffset + obj.collisionWidth) ~/
        obj.level.tileWidth;


    newX += this._horizAccel.toInt();
    newY += this._vertAccel.toInt();

    row = newY ~/ l.tileHeight;
    col = newX ~/ l.tileWidth;
    row1 = (newY + 64) ~/ l.tileHeight;
    col1 = (newX + 64) ~/ l.tileWidth;

    if ((this._vertAccel > 0 &&
        (l.isBlocking(row1, col) ||
            l.isBlocking(row1, col1))) ||
        (this._vertAccel < 0 &&
        (l.isBlocking(row, col) ||
            l.isBlocking(row, col1)))) {
      this._vertAccel = 0.0;
      newY = obj.y;
    }

    row = (newY + obj.collisionYOffset) ~/ obj.level.tileHeight;
    col = (newX + obj.collisionXOffset) ~/ obj.level.tileWidth;
    row1 = (newY + obj.collisionYOffset + obj.collisionHeight) ~/
        obj.level.tileHeight;
    col1 = (newX + obj.collisionXOffset + obj.collisionWidth) ~/
        obj.level.tileWidth;


    row = newY ~/ l.tileHeight;
    col = newX ~/ l.tileWidth;
    row1 = (newY + 64) ~/ l.tileHeight;
    col1 = (newX + 64) ~/ l.tileWidth;

    if ((this._horizAccel < 0 &&
        (l.isBlocking(row, col) ||
            l.isBlocking(row1, col))) ||
        (this._horizAccel > 0 &&
        (l.isBlocking(row, col1) ||
            l.isBlocking(row1, col1)))) {
      this._horizAccel = 0.0;
      newX = obj.x;
    }


    if (zeroHorizAccel) {
      this._horizAccel = 0.0;
    }
    if (zeroVertAccel) {
      this._vertAccel = 0.0;
    }

    obj.setPos(newX, newY);
  }

  void onKeyDown(KeyboardEvent e) {
    //window.console.log("Key down: ${e.keyCode}");

    if (MOVE_DOWN_KEYS.contains(e.keyCode)) {
      if (this._vertDir == DIR_UP) {
        this._vertDir = null;
      } else {
        this._vertDir = DIR_DOWN;
      }
      this._pressed[DIR_DOWN] = true;
    } else if (MOVE_UP_KEYS.contains(e.keyCode)) {
      if (this._vertDir == DIR_DOWN) {
        this._vertDir = null;
      } else {
        this._vertDir = DIR_UP;
      }
      this._pressed[DIR_UP] = true;
    }

    if (MOVE_LEFT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == DIR_RIGHT) {
        this._horizDir = null;
      } else {
        this._horizDir = DIR_LEFT;
      }
      this._pressed[DIR_LEFT] = true;
    } else if (MOVE_RIGHT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == DIR_LEFT) {
        this._horizDir = null;
      } else {
        this._horizDir = DIR_RIGHT;
      }
      this._pressed[DIR_RIGHT] = true;
    }
  }
  void onKeyUp(KeyboardEvent e) {
    //window.console.log("Key up: ${e.keyCode}");

    if (MOVE_DOWN_KEYS.contains(e.keyCode)) {
      if (this._vertDir == null) {
        this._vertDir = DIR_UP;
      } else {
        this._vertDir = null;
      }
      this._pressed[DIR_DOWN] = false;
    } else if (MOVE_UP_KEYS.contains(e.keyCode)) {
      if (this._vertDir == null) {
        this._vertDir = DIR_DOWN;
      } else {
        this._vertDir = null;
      }
      this._pressed[DIR_UP] = false;
    }

    if (MOVE_LEFT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == null) {
        this._horizDir = DIR_RIGHT;
      } else {
        this._horizDir = null;
      }
      this._pressed[DIR_LEFT] = false;
    } else if (MOVE_RIGHT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == null) {
        this._horizDir = DIR_LEFT;
      } else {
        this._horizDir = null;
      }
      this._pressed[DIR_RIGHT] = false;
    }
  }
  void onKeyPressed(KeyboardEvent e) {
    //window.console.log("Key pressed: ${e.keyCode}");

    if (e.keyCode == KeyboardListener.KEY_SPACE) {
      //this._drinkBeer = true;
    }
  }
}

