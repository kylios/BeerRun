part of level;

class CreateBulletEvent extends GameEvent {

  CreateBulletEvent(Direction d, GameObject creator, int x, int y) : super() {
    this.creator = creator;
    this.type = Level.CREATE_BULLET_EVENT;
    this.data["direction"] = d;
    this.data["x"] = x;
    this.data["y"] = y;
  }
}

