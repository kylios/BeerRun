part of path;


class Path {

  List<Point> _points;

  Path(this._points);

  void addPoint(Point p) {
    this._points.add(p);
  }

  /**
   * Return true if the given point resides in this path.
   */
  bool contains(Point p) {
    // TODO: placeholder
    return false;
  }

  Point get start => this._points[0];
  Point get end => this._points[this._points.length - 1];
  int get startIdx => 0;
  int get endIdx => this._points.length;

  /**
   * Return the next logical point and direction given a point, direction, and step.
   */
  List next(Point p, int step) {


  }
}

