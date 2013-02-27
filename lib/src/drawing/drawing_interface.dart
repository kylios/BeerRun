part of drawing;

abstract class DrawingInterface {

  // Drawing Offsets
  void setOffset(int x, int y);

  void setBounds(int x, int y);

  // DRAWING FUNCTIONS
  void clear();

  void drawImage(ImageElement i, int x, int y, [int width, int height]);

  void drawSprite(Sprite s, int x, int y, [int drawWidth, int drawHeight]);

  void drawRect(int x, int y, int width, int height, [int radiusX, int radiusY]);

  void drawText(String text, int x, int y);
}