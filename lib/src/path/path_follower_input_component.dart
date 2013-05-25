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

    // Move horizontally or vertically?
    if ((nextX - obj.x).abs() > (nextY - obj.y).abs()) {
      // Move horizontally
      if (obj.x < nextX) {
        obj.moveRight();
        // Did we reach the next point yet?
        if (obj.x > nextX) {
          this._currentPointIdx++;
        }
      } else if (obj.x > nextX) {
        obj.moveLeft();
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
        if (obj.y < nextY) {
          this._currentPointIdx++;
        }
      }
    }
  }
}