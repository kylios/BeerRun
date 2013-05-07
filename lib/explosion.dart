library explosion;

import 'dart:html';

import 'package:beer_run/level.dart';
import 'package:beer_run/drawing.dart';
import 'package:beer_run/animation.dart';

class Explosion extends GraphicAnimation {

  factory Explosion.createAt(int x, int y, int width, int height) {
    SpriteSheet sheet = new SpriteSheet('img/explosion.png', 128, 128);
    List<Sprite> sprites = [
      sheet.spriteAt(0, 0),
      sheet.spriteAt(128, 0),
      sheet.spriteAt(256, 0),
      sheet.spriteAt(384, 0),
      sheet.spriteAt(0, 128),
      sheet.spriteAt(128, 128),
      sheet.spriteAt(256, 128),
      sheet.spriteAt(384, 128),
      sheet.spriteAt(0, 256),
      sheet.spriteAt(128, 256),
      sheet.spriteAt(256, 256),
      sheet.spriteAt(384, 256),
      sheet.spriteAt(0, 384),
      sheet.spriteAt(128, 384),
      sheet.spriteAt(256, 384),
      sheet.spriteAt(384, 384)
                            ];

    SpriteAnimation anim = new SpriteAnimation(sprites, false);

    return new Explosion._fromFactory(anim, x, y, width, height);
  }

  Explosion._fromFactory(SpriteAnimation sprites, x, y, width, height) :
    super(sprites, x, y, width, height);

}

