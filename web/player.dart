library player;

import 'dart:html';

import 'game_object.dart';
import 'game_event.dart';
import 'component.dart';
import 'drawing_component.dart';
import 'drawable.dart';
import 'sprite.dart';
import 'sprite_sheet.dart';
import 'direction.dart';

class Player extends Drawable {

  static final int BUZZ_PER_BEER = 1;

  int _beers;
  int _buzz;

  // Movement parameters

  int _balance = 1;
  // TODO: add stuff for drunkenness :-P

  SpriteSheet _sprites;

  DrawingComponent _drawer;

  Player() : super() {

    this.dir = DIR_DOWN;
    this.step = 0;

    this._sprites = new SpriteSheet(
        "img/Character1Walk.png",
        this.tileWidth, this.tileHeight);
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

  int _getSpriteSheetRowFromDir(Direction d)
  {
    int row = 0;
    if (d == DIR_UP)  row = 0;
    else if (d == DIR_LEFT) row = 1;
    else if (d == DIR_DOWN) row = 2;
    else if (d == DIR_RIGHT) row = 3;
    return row;
  }

  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getStandSprite(Direction d) {

    int row = this._getSpriteSheetRowFromDir(d);
    return this._sprites.spriteAt(0, row * this.tileWidth);
  }
  Sprite getWalkSprite(Direction d, int step) {

    int row = this._getSpriteSheetRowFromDir(d);
    return this._sprites.spriteAt(step * this.tileHeight, row * this.tileWidth);
  }
}
