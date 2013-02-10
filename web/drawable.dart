library renderable;

import 'dart:html';

import 'sprite.dart';
import 'sprite_sheet.dart';
import  'sprite_animation.dart';
import 'drawing_component.dart';
import 'direction.dart';
import 'game_object.dart';

abstract class Drawable extends GameObject {

  DrawingComponent _drawer;

  int get tileWidth;
  int get tileHeight;
  DrawingComponent get drawer => this._drawer;

  Sprite getStaticSprite();
  Sprite getMoveSprite();

  Drawable(Direction d, int x, int y) : super(d, x, y);

  void setDrawingComponent(DrawingComponent d) {
    this._drawer = d;
  }
}

