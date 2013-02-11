library explosion;

import 'dart:html';

import 'level.dart';
import 'sprite_sheet.dart';
import 'sprite.dart';

class Explosion extends LevelAnimation {

  factory Explosion.createAt(int x, int y, int width, int height) {
    SpriteSheet sheet = new SpriteSheet('img/Explosion.png', 128, 128);
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

    return new Explosion._fromFactory(sprites, x, y, width, height);
  }


  Explosion._fromFactory(List<Sprite> sprites, x, y, width, height) :
    super(sprites, x, y, width, height, false);

}

