part of car;

class CarInputComponent extends Component {

  void update(GameObject obj) {

    if (obj.dir == DIR_UP) {
      obj.moveUp();
    } else if (obj.dir == DIR_DOWN) {
      obj.moveDown();
    } else if (obj.dir == DIR_LEFT) {
      obj.moveLeft();
    } else if (obj.dir == DIR_RIGHT) {
      obj.moveRight();
    }
  }
}