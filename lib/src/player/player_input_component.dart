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

    if (this._pressed[KeyboardListener.KEY_UP] == true) {
      obj.moveUp();
    } else if (this._pressed[KeyboardListener.KEY_DOWN] == true) {
      obj.moveDown();
    }
    if (this._pressed[KeyboardListener.KEY_LEFT] == true) {
      obj.moveLeft();
    } else if (this._pressed[KeyboardListener.KEY_RIGHT] == true) {
      obj.moveRight();
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

