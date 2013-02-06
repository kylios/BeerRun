import 'dart:html';

import 'canvas_manager.dart';
import 'canvas_drawer.dart';
import 'sprite.dart';
import 'sprite_sheet.dart';

import 'component.dart';
import 'input_component.dart';
import 'drawing_component.dart';
import 'game_object.dart';
import 'game_event.dart';

import 'level.dart';
import 'level1.dart';
import 'player.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

CanvasManager canvasManager;
CanvasDrawer canvasDrawer;

Level level;

InputComponent keyboard;
DrawingComponent drawer;

Player player;

DivElement fpsDisplay;
final int MAXSAMPLES = 100;
int tickindex=0;
int ticksum=0;
List<int> ticklist = new List<int>.filled(MAXSAMPLES, 0);
int starttime = 0;
int endtime = 0;

void _loop(var _) {

  ticksum-=ticklist[tickindex];  /* subtract value falling off */
  ticksum+=(endtime - starttime);              /* add new value */
  ticklist[tickindex]=(endtime - starttime);   /* save new value so it can be subtracted later */
  if(++tickindex==MAXSAMPLES)    /* inc buffer index */
    tickindex=0;
  fpsDisplay.innerHtml = (ticksum.toDouble() / MAXSAMPLES.toDouble()).toString();

  starttime = new Date.now().millisecondsSinceEpoch;
  level.draw(canvasDrawer);

  player.update();

  endtime = new Date.now().millisecondsSinceEpoch;

  window.requestAnimationFrame(_loop);
}

void main() {

  fpsDisplay = query('div#fps');

  level = new Level1();

  canvasManager = new CanvasManager(query('canvas#game_canvas'));
  canvasManager.resize(CANVAS_WIDTH, CANVAS_HEIGHT);

  canvasDrawer = new CanvasDrawer(canvasManager);
  canvasDrawer.setBounds(CANVAS_WIDTH, CANVAS_HEIGHT);
  canvasDrawer.setOffset(0, 0);
  canvasDrawer.backgroundColor = 'black';

  drawer = new DrawingComponent(canvasDrawer);

  keyboard = new InputComponent();
  canvasManager.addKeyboardListener(keyboard);

  player = new Player();
  player.setControlComponent(keyboard);
  player.setDrawingComponent(drawer);

  _loop(0);
}
