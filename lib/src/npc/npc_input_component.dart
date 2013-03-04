part of npc;

class NPCInputComponent extends Component {

  int _paces = 0;
  int _maxPaces = 0;

  Region _region;

  NPCInputComponent(this._region);

  void update(GameObject obj) {

    int x1 = this._region.left;
    int x2 = this._region.right;
    int y1 = this._region.top;
    int y2 = this._region.bottom;

    bool changeDirs = (this._maxPaces == 0 || this._paces >= this._maxPaces);

    if (obj.x <= x1 && obj.dir != DIR_RIGHT) {
      changeDirs = true;
    } else if (obj.x + obj.tileWidth >= x2 && obj.dir != DIR_LEFT) {
      changeDirs = true;
    } else if (obj.y <= y1 && obj.dir != DIR_DOWN) {
      changeDirs = true;
    } else if (obj.y + obj.tileHeight >= y2 && obj.dir != DIR_UP) {
      changeDirs = true;
    }

    Random r = new Random();

    if (changeDirs) {
      this._maxPaces = r.nextInt(40) + 100;
      this._paces = 0;

      int d = r.nextInt(2);

      if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
        if (d == 0) {
          obj.moveLeft();
        } else {
          obj.moveRight();
        }
      } else {
        if (d == 0) {
          obj.moveUp();
        } else {
          obj.moveDown();
        }
      }
      this._paces++;
    } else {
      this._paces++;

      if (r.nextInt(100) != 0) {
        if (obj.dir == DIR_UP) {
          obj.moveUp();
        } else if (obj.dir == DIR_DOWN) {
          obj.moveDown();
        } else if (obj.dir == DIR_LEFT) {
          obj.moveLeft();
        } else if (obj.dir == DIR_RIGHT) {
          obj.moveRight();
        }
      } else if (r.nextInt(2) == 0) {
        this._paces = this._maxPaces;
      }
    }
  }
}


