library drawing_component;

import 'dart:html';

import 'canvas_drawer.dart';
import 'canvas_manager.dart';
import 'component.dart';
import 'component_listener.dart';
import 'game_object.dart';
import 'game_event.dart';
import 'drawable.dart';
import 'sprite.dart';
import 'direction.dart';

class DrawingComponent extends Component
  implements ComponentListener
{

  static final DIRECTION_CHANGE_EVENT = 1;
  static final UPDATE_STEP_EVENT = 2;

  CanvasDrawer _drawer;
  CanvasManager _manager;

  DrawingComponent(this._manager, this._drawer);

  void update(Drawable obj) {

    this._drawer.setOffset(
      obj.x + obj.tileWidth - (this._manager.width ~/ 2),
      obj.y + obj.tileHeight - (this._manager.height ~/ 2)
    );

    Sprite s = obj.getWalkSprite(obj.dir, obj.step);
    this._drawer.drawSprite(s, obj.x, obj.y);


  }

  void listen(GameEvent e) {

    if (null == e) {
      return;
    }
  }

  static GameEvent directionChangeEvent(Direction d) {

    GameEvent e = new GameEvent();
    e.type = DrawingComponent.DIRECTION_CHANGE_EVENT;
    e.data["dir"] = d;
    return e;
  }
}

