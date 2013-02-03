library level;

import 'dart:html';

import 'sprite.dart';
import 'sprite_sheet.dart';
import 'canvas_drawer.dart';

class Level {

  int _rows;
  int _cols;

  int _tileWidth;
  int _tileHeight;

  int _layer = -1;

  List<List<Sprite>> _sprites;

  Level(this._rows, this._cols, this._tileWidth, this._tileHeight) {
    this._sprites = new List<List<Sprite>>();
  }

  int get tileWidth => this._tileWidth;
  int get tileHeight => this._tileHeight;
  int get rows => this._rows;
  int get cols => this._cols;

  int _posToIdx(int row, int col) {
    return this._cols * row + col;
  }

  void newLayer() {
    this._sprites.add(new List<Sprite>(this._rows * this._cols));
    this._layer++;
  }

  void setSpriteAt(Sprite s, int row, int col) {

    int pos = this._posToIdx(row, col);
    if (this._layer == -1 ||
        pos < 0 ||
        pos >= this._sprites[this._layer].length)
    {
      return;
    }

    this._sprites[this._layer][pos] = s;
  }
  Sprite getSpriteAt(int row, int col) {

    int pos = this._posToIdx(row, col);
    if (this._layer == -1 ||
        pos < 0 ||
        pos >= this._sprites[this._layer].length)
    {
      return null;
    }

    return this._sprites[this._layer][pos];
  }

  void draw(CanvasDrawer d) {

    for (List<Sprite> layer in this._sprites) {

      int row = 0;
      int col = 0;
      for (Sprite s in layer) {
        if (s != null) {
          d.drawSprite(s, col * this._tileWidth, row * this._tileHeight);
        }
        col++;
        if (col >= this._cols) {
          row++;
          col = 0;
        }
      }
    }
  }

  static Map<String, Sprite> parseSpriteSheet(
      SpriteSheet sheet, Map<String, List<int>> data)
  {

    Map<String, Sprite> sprites = new Map<String, Sprite>();

    for (String sName in data.keys) {
      int x = data[sName][0];
      int y = data[sName][1];
      sprites[sName] = sheet.spriteAt(x, y);
    }

    return sprites;
  }
}
