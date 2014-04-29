part of path;

class PathFollowerInputComponent extends Component {

  GamePath _boundPath;

  PathFollowerInputComponent(this._boundPath);


  void update(PathFollower obj) {

    if (obj._currentPointIdx == this._boundPath.endIdx - 1) {
      obj.remove();
      return;
    }

    GamePoint nextPoint = this._boundPath._points[obj._currentPointIdx + 1];

    // Compare object's current point and the point at the next index in th
    // path.
    // Determine direction to travel to get to the next point.
    // Assume that paths always follow one of the four cardinal directions


    int widthBefore = obj.tileWidth;
    int heightBefore = obj.tileHeight;
    Direction prevDir = obj.dir;

    int nextX = nextPoint.x;
    int nextY = nextPoint.y;

    String action = (obj._turning ? "turning" : "moving");
    //window.console.log("Car $action ${obj.dir.toString()}: X = ${obj.x} -> $nextX, Y = ${obj.y} -> $nextY");

    if (obj.dir.isVertical()) {

      if (obj._turning) {
        if (obj.x < nextX) {
          obj.moveRight(min(obj.speed, nextX - obj.x));
          // Adjust for changes in width/height
          if (widthBefore < obj.tileWidth) {
            obj.setPos(obj.x + widthBefore + (obj.tileWidth - widthBefore), obj.y);
          }
        } else if (obj.x > nextX) {
          obj.moveLeft(min(obj.speed, obj.x - nextX));
          if (widthBefore < obj.tileWidth) {
            obj.setPos(obj.x - (obj.tileWidth - widthBefore), obj.y);
          }
        } else {
          throw new Exception("shouldn't be here with turning = true");
        }

        obj._turning = false;

      } else {

        if (obj.y < nextY) {
          obj.moveDown(min(obj.speed, nextY - obj.y));
        } else if (obj.y > nextY) {
          obj.moveUp(min(obj.speed, obj.y - nextY));
          if (prevDir == DIR_LEFT || prevDir == DIR_RIGHT) {
            obj.setPos(obj.x, obj.y - (obj.tileHeight - heightBefore));
          }
        } else {
          obj._currentPointIdx++;
          obj._turning = true;
        }
      }
    } else {

      if (obj._turning) {

        if (obj.y < nextY) {
          obj.moveDown(min(obj.speed, nextY - obj.y));
        } else if (obj.y > nextY) {
          obj.moveUp(min(obj.speed, obj.y - nextY));
        } else {
          throw new Exception("shouldn't be here without turning = true");
        }

        obj._turning = false;

      } else {
        if (obj.x < nextX) {
          obj.moveRight(min(obj.speed, nextX - obj.x));
        } else if (obj.x > nextX) {
          obj.moveLeft(min(obj.speed, obj.x - nextX));
        } else {
          obj._currentPointIdx++;
          obj._turning = true;
        }
      }
    }
  }
}