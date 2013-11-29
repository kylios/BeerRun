part of drawing;

class SpriteSheet {

  ImageElement _image;

  int _spriteWidth;
  int _spriteHeight;

  SpriteSheet(String imgPath, [this._spriteWidth, this._spriteHeight]) {
    this._image = new ImageElement();
    this._image.src = imgPath;
  }

  Sprite spriteAtNew(int row, int col) {

    return new Sprite(this._image,
        this._spriteWidth * col, this._spriteHeight * row,
        this._spriteWidth, this._spriteHeight);
  }
}
