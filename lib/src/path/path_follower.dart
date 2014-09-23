part of path;

abstract class PathFollower extends GameObject {

    // Path following data
    int _currentPointIdx = 0;
    bool _turning = false;

    PathFollower(Direction d, int x, int y) : super(d, x, y);
}
