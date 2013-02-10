library bullet;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';
import 'component.dart';
import 'drawable.dart';
import 'drawing_component.dart';
import 'sprite.dart';
import 'sprite_animation.dart';
import 'sprite_sheet.dart';
import 'direction.dart';

class Bullet extends Drawable {

  List<Sprite> _moveSprites = new List<Sprite>(4);

  Bullet(Direction d, int x, int y, Component c, DrawingComponent drw) :
    super(d, x, y)
  {

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
    this.drawer.update(this);
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

