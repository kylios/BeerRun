part of game;

class Direction {
  int direction;
  Direction(this.direction);
  int get idx => (this.direction ~/ 2);
  int get mult => (this.direction == 0 || this.direction == 2) ? -1 : 1;
  String toString() =>  (this == DIR_UP ? "up" :
                            (this == DIR_DOWN ? "down" :
                            (this == DIR_LEFT ? "left" :
                             "right")));
  bool isVertical() => (this == DIR_UP || this == DIR_DOWN);
  bool isHorizontal() => (this == DIR_LEFT || this == DIR_RIGHT);
}

final Direction DIR_UP = new Direction(0);
final Direction DIR_DOWN = new Direction(1);
final Direction DIR_LEFT = new Direction(2);
final Direction DIR_RIGHT = new Direction(3);

final List<Direction> CARDINAL_DIRS = [
	DIR_UP,
	DIR_DOWN,
	DIR_LEFT,
	DIR_RIGHT
];

final int DIR_VERT_IDX = 0;
final int DIR_HORIZ_IDX = 1;

