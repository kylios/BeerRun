library explosion;

import 'package:beer_run/drawing.dart';
import 'package:beer_run/animation.dart';

class Explosion extends GraphicAnimation {

  factory Explosion.createAt(int x, int y, int width, int height) {
    SpriteSheet sheet = new SpriteSheet('img/explosion.png', 128, 128);
    List<Sprite> sprites = [
      sheet.spriteAtNew(0, 0),
      sheet.spriteAtNew(0, 1),
      sheet.spriteAtNew(0, 2),
      sheet.spriteAtNew(0, 3),
      sheet.spriteAtNew(1, 0),
      sheet.spriteAtNew(1, 1),
      sheet.spriteAtNew(1, 2),
      sheet.spriteAtNew(1, 3),
      sheet.spriteAtNew(2, 0),
      sheet.spriteAtNew(2, 1),
      sheet.spriteAtNew(2, 2),
      sheet.spriteAtNew(2, 3),
      sheet.spriteAtNew(3, 0),
      sheet.spriteAtNew(3, 1),
      sheet.spriteAtNew(3, 2),
      sheet.spriteAtNew(3, 3)
                            ];

    SpriteAnimation anim = new SpriteAnimation(sprites, false);

    return new Explosion._fromFactory(anim, x, y, width, height);
  }

  Explosion._fromFactory(SpriteAnimation sprites, x, y, width, height) :
    super(sprites, x, y, width, height);

}

