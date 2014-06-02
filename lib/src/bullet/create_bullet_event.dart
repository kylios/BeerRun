part of bullet;

class CreateBulletEvent extends GameEvent {

  CreateBulletEvent(Direction d, GameObject creator, int x, int y) : super(GameEvent.CREATE_BULLET_EVENT) {
    this.creator = creator;
    this.data["direction"] = d;
    this.data["x"] = x;
    this.data["y"] = y;
  }
}

