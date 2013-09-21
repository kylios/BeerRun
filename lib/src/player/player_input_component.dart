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

  bool _drinkBeer = false;

  List<bool> _pressed = [false, false, false, false];

  PlayerInputComponent() {
    this._rng = new Random();
  }

  void update(Player obj) {

    if (this._drinkBeer) {
      this._drinkBeer = false;
      obj.drinkBeer();
    }



    // TODO: make this a curve?
    double horizAccelMax = 1.5 * obj.drunkenness;
    double vertAccelMax = 1.5 * obj.drunkenness;




    // Increase acceleration depending on what we're pressing
    if (this._pressed[DIR_UP.direction]) {
      this._vertAccel -= ACCEL_MOD;
      obj.dir = DIR_UP;
    } else if (this._pressed[DIR_DOWN.direction]) {
      this._vertAccel += ACCEL_MOD;
      obj.dir = DIR_DOWN;
    }
    if (this._pressed[DIR_LEFT.direction]) {
      this._horizAccel -= ACCEL_MOD;
      obj.dir = DIR_LEFT;
    } else if (this._pressed[DIR_RIGHT.direction]) {
      this._horizAccel += ACCEL_MOD;
      obj.dir = DIR_RIGHT;
    }


    int newX = obj.x;
    int newY = obj.y;
    bool zeroHorizAccel = false;
    bool zeroVertAccel = false;

    // If we aren't pressing any keys, decelerate
    if (! this._pressed[DIR_UP.direction] && ! this._pressed[DIR_DOWN.direction]){
      if (this._vertAccel > 0) {
        int tileY = ((1 + newY ~/ 16) * 16);
        int dist = (tileY - newY);
        if (dist > 1) {
          this._vertAccel -= dist * ACCEL_EASING / obj.drunkenness;
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
          this._vertAccel += dist * ACCEL_EASING / obj.drunkenness;
          if (this._vertAccel > -1) {
            this._vertAccel = -1.0;
          }
        } else {
          this._vertAccel = (tileY - newY).toDouble();
          zeroVertAccel = true;
        }
      }
    }

    if (! this._pressed[DIR_LEFT.direction] && ! this._pressed[DIR_RIGHT.direction]) {
      if (this._horizAccel > 0) {
        int tileX = ((1 + newX ~/ 16) * 16);
        int dist = (tileX - newX);
        //window.console.log("my x: ${newX}, tile x: ${((1 + newX ~/ 16) * 16.0)}");
        //window.console.log("dist: ${dist}, horizAccel: ${this._horizAccel}");
        if (dist > 1) {
          this._horizAccel -= dist * ACCEL_EASING / obj.drunkenness;
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
          this._horizAccel += dist * ACCEL_EASING / obj.drunkenness;
          if (this._horizAccel > -1) {
            this._horizAccel = -1.0;
          }
        } else {
          this._horizAccel = (tileX - newX).toDouble();
          zeroHorizAccel = true;
        }
      }
    }

    if (this._horizAccel > horizAccelMax) {
      this._horizAccel = horizAccelMax;
    } else if (this._horizAccel < -horizAccelMax) {
      this._horizAccel = -horizAccelMax;
    }
    if (this._vertAccel > vertAccelMax) {
      this._vertAccel = vertAccelMax;
    } else if (this._vertAccel < -vertAccelMax) {
      this._vertAccel = -vertAccelMax;
    }


    newX += this._horizAccel.toInt();
    newY += this._vertAccel.toInt();


    // Add the wobble














    // handle collisions
    Level l = obj.level;

    int tileWidth = obj.level.tileWidth;
    int tileHeight = obj.level.tileHeight;

    /*
     * Thanks to https://github.com/mrspeaker
     * for the movement code.  Inspiration taken from:
     * https://raw.github.com/mrspeaker/Omega500/master/%CE%A9/entities/Entity.js
     */

    // check blocks given vertical movement TL, BL, TR, BR
    List<List<int>> yBlocks = [
      [(obj.x + obj.collisionXOffset) ~/ tileWidth, (newY + obj.collisionYOffset) ~/ tileHeight],
      [(obj.x + obj.collisionXOffset) ~/ tileWidth, (newY + obj.collisionYOffset + obj.collisionHeight) ~/ tileHeight],
      [(obj.x + obj.collisionXOffset + obj.collisionWidth) ~/ tileWidth, (newY + obj.collisionYOffset) ~/ tileHeight],
      [(obj.x + obj.collisionXOffset + obj.collisionWidth) ~/ tileWidth, (newY + obj.collisionYOffset + obj.collisionHeight) ~/ tileHeight]
    ];

    // if overlapping edges, move back a little
    if (this._vertAccel < 0 &&
        (l.isBlocking(yBlocks[0][1], yBlocks[0][0]) ||
         l.isBlocking(yBlocks[2][1], yBlocks[2][0]))) {
      this._vertAccel = 0.0;
      newY = obj.y;
    }
    else if (this._vertAccel > 0 &&
        (l.isBlocking(yBlocks[1][1], yBlocks[1][0]) ||
         l.isBlocking(yBlocks[3][1], yBlocks[3][0]))) {
      this._vertAccel = 0.0;
      newY = obj.y;
    }

    List<List<int>> xBlocks = [
      [(newX + obj.collisionXOffset) ~/ tileWidth, (obj.y + obj.collisionYOffset) ~/ tileHeight],
      [(newX + obj.collisionXOffset) ~/ tileWidth, (obj.y + obj.collisionYOffset + obj.collisionHeight) ~/ tileHeight],
      [(newX + obj.collisionXOffset + obj.collisionWidth) ~/ tileWidth, (obj.y + obj.collisionYOffset) ~/ tileHeight],
      [(newX + obj.collisionXOffset + obj.collisionWidth) ~/ tileWidth, (obj.y + obj.collisionYOffset + obj.collisionHeight) ~/ tileHeight]
    ];

    // if overlapping edges, move back a little
    if (this._horizAccel < 0 &&
        (l.isBlocking(xBlocks[0][1], xBlocks[0][0]) ||
         l.isBlocking(xBlocks[1][1], xBlocks[1][0]))) {
      this._horizAccel = 0.0;
      newX = obj.x;
    }
    else if (this._horizAccel > 0 &&
        (l.isBlocking(xBlocks[2][1], xBlocks[2][0]) ||
         l.isBlocking(xBlocks[3][1], xBlocks[3][0]))) {
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
      this._pressed[DIR_DOWN.direction] = true;
    } else if (MOVE_UP_KEYS.contains(e.keyCode)) {
      if (this._vertDir == DIR_DOWN) {
        this._vertDir = null;
      } else {
        this._vertDir = DIR_UP;
      }
      this._pressed[DIR_UP.direction] = true;
    }

    if (MOVE_LEFT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == DIR_RIGHT) {
        this._horizDir = null;
      } else {
        this._horizDir = DIR_LEFT;
      }
      this._pressed[DIR_LEFT.direction] = true;
    } else if (MOVE_RIGHT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == DIR_LEFT) {
        this._horizDir = null;
      } else {
        this._horizDir = DIR_RIGHT;
      }
      this._pressed[DIR_RIGHT.direction] = true;
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
      this._pressed[DIR_DOWN.direction] = false;
    } else if (MOVE_UP_KEYS.contains(e.keyCode)) {
      if (this._vertDir == null) {
        this._vertDir = DIR_DOWN;
      } else {
        this._vertDir = null;
      }
      this._pressed[DIR_UP.direction] = false;
    }

    if (MOVE_LEFT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == null) {
        this._horizDir = DIR_RIGHT;
      } else {
        this._horizDir = null;
      }
      this._pressed[DIR_LEFT.direction] = false;
    } else if (MOVE_RIGHT_KEYS.contains(e.keyCode)) {
      if (this._horizDir == null) {
        this._horizDir = DIR_LEFT;
      } else {
        this._horizDir = null;
      }
      this._pressed[DIR_RIGHT.direction] = false;
    }
  }
  void onKeyPressed(KeyboardEvent e) {
    //window.console.log("Key pressed: ${e.keyCode}");

    if (e.keyCode == KeyboardListener.KEY_SPACE) {
      this._drinkBeer = true;
    }
  }
}

