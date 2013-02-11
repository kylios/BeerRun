library player;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';
import 'component.dart';
import 'drawing_component.dart';
import 'sprite.dart';
import 'sprite_sheet.dart';
import 'sprite_animation.dart';
import 'direction.dart';
import 'level.dart';
import 'bullet.dart';
import 'bullet_input_component.dart';

class Player extends GameObject {

  static final int BUZZ_PER_BEER = 1;

  int _beers;
  int _buzz;

  // Movement parameters

  int _balance = 1;
  // TODO: add stuff for drunkenness :-P

  List<SpriteAnimation> _walkSprites = new List<SpriteAnimation>(4);

  DrawingComponent _drawer;

  Player(Level l, Direction d, int x, int y) : super(d, x, y) {

    this.setLevel(l);

    SpriteSheet sprites = new SpriteSheet(
        "img/Character1Walk.png",
        this.tileWidth, this.tileHeight);

    List<Sprite> walkUp = new List<Sprite>();
    List<Sprite> walkDown = new List<Sprite>();
    List<Sprite> walkLeft = new List<Sprite>();
    List<Sprite> walkRight = new List<Sprite>();
    for (int i = 0; i < 9; i++) {
      walkUp.add(sprites.spriteAt(i * this.tileHeight, 0 * this.tileWidth));
      walkLeft.add(sprites.spriteAt(i * this.tileHeight, 1 * this.tileWidth));
      walkDown.add(sprites.spriteAt(i * this.tileHeight, 2 * this.tileWidth));
      walkRight.add(sprites.spriteAt(i * this.tileHeight, 3 * this.tileWidth));
    }
    this._walkSprites[DIR_UP.direction] = new SpriteAnimation(walkUp);
    this._walkSprites[DIR_DOWN.direction] = new SpriteAnimation(walkDown);
    this._walkSprites[DIR_LEFT.direction] = new SpriteAnimation(walkLeft);
    this._walkSprites[DIR_RIGHT.direction] = new SpriteAnimation(walkRight);
  }

  void update() {
    super.update();
    this._drawer.update(this);
  }

  void setDrawingComponent(DrawingComponent d) {
    this._drawer = d;
  }


  void drinkBeer() {
    if (this._beers <= 0) {
      return;
    }
    this._beers--;
    this._buzz += BUZZ_PER_BEER;
  }

  void spawnBullet() {

    int x = this.x;
    int y = this.y;

    if (this.dir == DIR_RIGHT) {
      x += this.tileWidth ~/ 2;
      y += this.tileHeight ~/ 4;
    } else if (this.dir == DIR_LEFT) {
      y += this.tileHeight ~/ 4;
    } else if (this.dir == DIR_UP) {
      x += tileWidth ~/ 4;
    } else if (this.dir == DIR_DOWN) {
      x += this.tileWidth ~/ 4;
      y += this.tileHeight ~/ 2;
    }

    this.broadcast(new CreateBulletEvent(
        this.dir, this, x, y),
        [ this.level ]);
  }

  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getMoveSprite() {
    return this._walkSprites[this.dir.direction].getNext();
  }
  Sprite getStaticSprite() {
    this._walkSprites[this.dir.direction].reset();
    return this._walkSprites[this.dir.direction].getCur();
  }
}
