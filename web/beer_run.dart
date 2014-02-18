import 'dart:html';

import 'package:beer_run/game.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

GameManager game;

void main() {

  game = new GameManager(
      canvasWidth: CANVAS_WIDTH, canvasHeight: CANVAS_HEIGHT,
      canvasElement: querySelector('canvas#game_canvas'),
      UIRootElement: querySelector('div#root_pane'),
      NotificationsRootElement: querySelector('div#notifications_root'),
      DialogElement: querySelector('div#dialog'),
      statsElement: querySelector('div#stats'),
      debugStatsElement: querySelector('div#debug_stats'),
      musicOnElement: querySelector('input#music_toggle_on'),
      musicOffElement: querySelector('input#music_toggle_off'),
      sfxOnElement: querySelector('input#sfx_toggle_on'),
      sfxOffElement: querySelector('input#sfx_toggle_off'));

  game.init().then((var _) => game.run());
}
