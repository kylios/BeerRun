library bullet_input_compontent;

import 'dart:html';

import 'component.dart';
import 'game_object.dart';
import 'direction.dart';

class BulletInputComponent extends Component {

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
