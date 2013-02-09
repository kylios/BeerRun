library renderable;

import 'dart:html';

import 'sprite.dart';
import 'sprite_sheet.dart';
import  'sprite_animation.dart';
import 'drawing_component.dart';
import 'direction.dart';
import 'game_object.dart';

abstract class Drawable extends GameObject {

  int get tileWidth;
  int get tileHeight;

  SpriteAnimation getWalkAnimation(Direction d);

  void setDrawingComponent(DrawingComponent d);
}

