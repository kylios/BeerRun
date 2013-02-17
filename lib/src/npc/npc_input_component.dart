part of npc;

class NPCInputComponent extends Component {

  int _paces = 0;
  int _maxPaces = 0;

  void update(GameObject obj) {

    int x1 = 0;
    int x2 = obj.level.tileWidth * obj.level.cols;
    int y1 = 0;
    int y2 = obj.level.tileHeight * obj.level.rows;

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
      this._maxPaces = r.nextInt(40);
      this._paces = 0;

      int d = r.nextInt(4);

      if (d == DIR_UP.direction) {
        obj.moveUp();
      } else if (d == DIR_DOWN.direction) {
        obj.moveDown();
      } else if (d == DIR_LEFT.direction) {
        obj.moveLeft();
      } else if (d == DIR_RIGHT.direction) {
        obj.moveRight();
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
      }
    }
  }
}


