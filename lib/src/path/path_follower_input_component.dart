part of path;

class PathFollowerInputComponent extends Component {

  int _currentPointIdx = 0;
  GamePath _boundPath;

  PathFollowerInputComponent(this._boundPath);


  void update(GameObject obj) {

    if (this._currentPointIdx == this._boundPath.endIdx - 1) {
      obj.remove();
      return;
    }

    GamePoint nextPoint = this._boundPath._points[this._currentPointIdx + 1];

    // Compare object's current point and the point at the next index in th
    // path.
    // Determine direction to travel to get to the next point.
    int nextX = nextPoint.x;
    int nextY = nextPoint.y;

    int widthBefore = obj.tileWidth;
    int heightBefore = obj.tileHeight;

    Direction prevDir = obj.dir;

    // Move horizontally or vertically?
    if ((nextX - obj.x).abs() > (nextY - obj.y).abs()) {
      // Move horizontally
      if (obj.x < nextX) {
        obj.moveRight();

        // Adjust for changes in width/height
        if (widthBefore < obj.tileWidth) {
          obj.setPos(obj.x + widthBefore + (obj.tileWidth - widthBefore), obj.y);
        }

        // Did we reach the next point yet?
        if (obj.x > nextX) {
          this._currentPointIdx++;
        }
      } else if (obj.x > nextX) {
        obj.moveLeft();

        // Adjust for changes in width/height
        if (widthBefore < obj.tileWidth) {
          obj.setPos(obj.x - (obj.tileWidth - widthBefore), obj.y);
        }

        // Did we reach the next point yet?
        if (obj.x < nextX) {
          this._currentPointIdx++;
        }
      }
    } else {
      // Move vertically
      if (obj.y < nextY) {
        obj.moveDown();

        if (obj.y > nextY) {
          this._currentPointIdx++;
        }
      } else if (obj.y > nextY) {
        obj.moveUp();

        // Adjust for changes in width/height
        if (prevDir == DIR_LEFT || prevDir == DIR_RIGHT) {
          obj.setPos(obj.x, obj.y - (obj.tileHeight - heightBefore));
        }

        if (obj.y < nextY) {
          this._currentPointIdx++;
        }
      }
    }
  }
}