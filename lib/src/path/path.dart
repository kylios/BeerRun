part of path;


class GamePath {

  List<GamePoint> _points;

  GamePath(this._points);

  void addPoint(GamePoint p) {
    this._points.add(p);
  }

  /**
   * Return true if the given point resides in this path.
   */
  bool contains(GamePoint p) {
    // TODO: placeholder
    return false;
  }

  GamePoint get start => this._points[0];
  GamePoint get end => this._points[this._points.length - 1];
  int get startIdx => 0;
  int get endIdx => this._points.length;

  /**
   * Return the next logical point and direction given a point, direction, and step.
   */
  List next(GamePoint p, int step) {


  }
}

