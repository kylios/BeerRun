library sprite_animation;

import 'dart:html';

import 'sprite.dart';
import 'sprite_sheet.dart';

class SpriteAnimation {

  List<Sprite> _sprites;
  int _cur;

  SpriteAnimation(this._sprites){
    this._cur = 0;
  }

  Sprite getNext() {
    Sprite s = this._sprites[this._cur++];
    if (this._cur == this._sprites.length) {
      this._cur = 0;
    }
    return s;
  }

  Sprite getCur() {
    return this._sprites[this._cur];
  }

  void reset() {
    this._cur = 0;
  }
}

