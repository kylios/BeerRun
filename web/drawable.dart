library renderable;

import 'dart:html';

import 'sprite.dart';
import 'sprite_sheet.dart';
import 'drawing_component.dart';
import 'direction.dart';
import 'game_object.dart';

abstract class Drawable extends GameObject {

  int get tileWidth;
  int get tileHeight;
  int get numSteps;

  Sprite getStandSprite(Direction d);
  Sprite getWalkSprite(Direction d, int step);

  void setDrawingComponent(DrawingComponent d);
}

