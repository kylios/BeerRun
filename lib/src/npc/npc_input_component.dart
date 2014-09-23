part of npc;

class NPCInputComponent extends Component {

    int _paces = 0;
    int _maxPaces = 0;

    // count how many times we hit a wall in different directions.
    // this should help us avoid being spastic tweakers
    // in narrow regions
    int _chDirLeft = 0;
    int _chDirRight = 0;
    int _chDirUp = 0;
    int _chDirDown = 0;

    Region _region;

    NPCInputComponent(this._region);

    void update(GameObject obj) {

        int x1 = this._region.left;
        int x2 = this._region.right;
        int y1 = this._region.top;
        int y2 = this._region.bottom;

        bool changeDirs = (this._maxPaces == 0 || this._paces >=
                this._maxPaces);

        if (obj.x <= x1 && obj.dir == DIR_LEFT) {
            //this._chDirLeft += 1;
            changeDirs = true;
        } else if (obj.x + obj.tileWidth >= x2 && obj.dir == DIR_RIGHT) {
            //this._chDirRight += 1;
            changeDirs = true;
        } else if (obj.y <= y1 && obj.dir == DIR_UP) {
            //this._chDirUp += 1;
            changeDirs = true;
        } else if (obj.y + obj.tileHeight >= y2 && obj.dir == DIR_DOWN) {
            //this._chDirDown += 1;
            changeDirs = true;
        }

        Random r = new Random();

        if (changeDirs) {
            int _max = max(this._chDirDown, max(this._chDirLeft, max(
                    this._chDirRight, this._chDirUp)));
            int _min = min(this._chDirDown, min(this._chDirLeft, min(
                    this._chDirRight, this._chDirUp)));
            this._maxPaces = r.nextInt(2 * _max - _min + 1) + 400;
            this._paces = 0;

            int d = r.nextInt(2);

            if (obj.dir == DIR_UP || obj.dir == DIR_DOWN) {
                if (/*this._chDirLeft< this._chDirRight) { */d == 0) {
                    obj.moveLeft();
                    this._chDirLeft++;
                } else {
                    obj.moveRight();
                    this._chDirRight++;
                }
            } else {
                if (/*this._chDirUp < this._chDirDown) { */d == 0) {
                    obj.moveUp();
                    this._chDirUp++;
                } else {
                    obj.moveDown();
                    this._chDirDown++;
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

