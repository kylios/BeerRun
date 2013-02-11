library bullet;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';
import 'component.dart';
import 'drawing_component.dart';
import 'sprite.dart';
import 'sprite_animation.dart';
import 'sprite_sheet.dart';
import 'direction.dart';
import 'level.dart';
import 'player.dart';

class Bullet extends GameObject {

  List<Sprite> _moveSprites = new List<Sprite>(4);

  GameObject _creator = null;

  Bullet(Level l, this._creator, Direction d, int x, int y,
      Component c, DrawingComponent drw) :
    super(d, x, y)
  {
    this.setLevel(l);
    this.setControlComponent(c);
    this.setDrawingComponent(drw);

    this.setSpeed(8);

    SpriteSheet sprites = new SpriteSheet(
        "img/Muzzleflashes-Shots.png",
        32, 32);

    this._moveSprites[DIR_DOWN.direction] = sprites.spriteAt(0, 32, 32, 32);
    this._moveSprites[DIR_RIGHT.direction] = sprites.spriteAt(32, 32, 32, 32);
    this._moveSprites[DIR_UP.direction] = sprites.spriteAt(64, 32, 32, 32);
    this._moveSprites[DIR_LEFT.direction] = sprites.spriteAt(96, 32, 32, 32);
  }

  void update() {
    super.update();

    if (this.level.isOffscreen(this)) {
      this.remove();
    } else {

      // Check collisions.  Remove bullet from map and deal some damage
      List<GameObject> objs = this.level.checkCollision(this);
      if (objs != null) {
        GameObject o = objs.removeLast();
        while (objs.length > 0 && o == this._creator) {
          assert(o != this);
          o = objs.removeLast();
        }
        if (o != this._creator) {
          if (o is Player) {
            o.takeHit();
          }
          this.remove();
        }
      } else {

        this.drawer.update(this);
      }
    }
  }

  int get tileWidth => 32;
  int get tileHeight => 32;

  Sprite getStaticSprite() {
    return this._moveSprites[this.dir.direction];
  }
  Sprite getMoveSprite() {
    return this._moveSprites[this.dir.direction];
  }
}

