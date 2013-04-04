part of drawing;

class SpriteSheet {

  ImageElement _image;

  int _spriteWidth;
  int _spriteHeight;

  SpriteSheet(String imgPath, [this._spriteWidth, this._spriteHeight]) {
    this._image = new ImageElement();
    this._image.src = imgPath;
  }

  Sprite spriteAt(int x, int y, [int width, int height]) {

    if ( ! ?width) {
      width = this._spriteWidth;
    }
    if ( ! ?height) {
      height = this._spriteHeight;
    }
    return new Sprite(this._image, x, y, width, height);
  }
}
