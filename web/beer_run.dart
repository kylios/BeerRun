import 'dart:html';

import 'canvas_manager.dart';
import 'canvas_drawer.dart';
import 'sprite.dart';
import 'sprite_sheet.dart';

import 'level.dart';
import 'level1.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

CanvasManager canvasManager;
CanvasDrawer canvasDrawer;

Level level;

void _loop(var _) {

  canvasDrawer.clear();
  level.draw(canvasDrawer);

  window.requestAnimationFrame(_loop);
}

void main() {

  level = new Level1();

  canvasManager = new CanvasManager(query('canvas#game_canvas'));
  canvasManager.resize(CANVAS_WIDTH, CANVAS_HEIGHT);

  canvasDrawer = new CanvasDrawer(canvasManager);
  canvasDrawer.setBounds(CANVAS_WIDTH, CANVAS_HEIGHT);
  canvasDrawer.setOffset(0, 0);
  canvasDrawer.backgroundColor = 'black';

  _loop(0);
}
