part of car;

class Car extends GameObject {

  SpriteSheet _sheet;
  List<List<int>> _spriteCoords;

  Car(Direction d, int x, int y, this._sheet, this._spriteCoords) :
    super(d, x, y) {

    this.setSpeed(6);
    this.setControlComponent(new CarInputComponent());
  }

  void update() {
    super.update();
  }




  int get tileWidth => 64;
  int get tileHeight => 64;

  Sprite getMoveSprite() {
    int x = this._spriteCoords[this.dir.direction][0];
    int y = this._spriteCoords[this.dir.direction][1];
    return this._sheet.spriteAt(x, y, this.tileWidth, this.tileHeight);
  }
  Sprite getStaticSprite() {
    int x = this._spriteCoords[this.dir.direction][0];
    int y = this._spriteCoords[this.dir.direction][1];
    return this._sheet.spriteAt(x, y, this.tileWidth, this.tileHeight);
  }
}