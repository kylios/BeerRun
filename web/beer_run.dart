import 'dart:html';

import 'package:beer_run/game.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

GameManager game;

void _loop(var _) {

  if (game.continueLoop) {
    game.update();
  }

  window.requestAnimationFrame(_loop);
}

void main() {

  game = new GameManager(
      canvasWidth: CANVAS_WIDTH, canvasHeight: CANVAS_HEIGHT,
      canvasElement: query('canvas#game_canvas'),
      UIRootElement: query('div#root_pane'),
      DialogElement: query('div#dialog'),
      statsElement: query('div#stats'));

  game.init().then((var _) => game.start());



  _loop(0);
}
