import 'dart:html';

import 'package:BeerRun/canvas_manager.dart';
import 'package:BeerRun/drawing.dart';
import 'package:BeerRun/component.dart';
import 'package:BeerRun/input.dart';
import 'package:BeerRun/game.dart';
import 'package:BeerRun/level.dart';
import 'level1.dart';
import 'package:BeerRun/player.dart';
import 'package:BeerRun/npc.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

CanvasManager canvasManager;
CanvasDrawer canvasDrawer;

Level level;

SimpleInputComponent keyboard;
DrawingComponent drawer;

Player player;

DivElement fpsDisplay;
final int MAXSAMPLES = 100;
int tickindex=0;
int ticksum=0;
List<int> ticklist = new List<int>.fixedLength(MAXSAMPLES, fill: 0);
int starttime = 0;
int endtime = 0;

void _loop(var _) {

  ticksum-=ticklist[tickindex];  /* subtract value falling off */
  ticksum+=(endtime - starttime);              /* add new value */
  ticklist[tickindex]=(endtime - starttime);   /* save new value so it can be subtracted later */
  if(++tickindex==MAXSAMPLES)    /* inc buffer index */
    tickindex=0;
  fpsDisplay.innerHtml = (ticksum.toDouble() / MAXSAMPLES.toDouble()).toString();

  canvasDrawer.clear();

  starttime = new Date.now().millisecondsSinceEpoch;

  level.update();

  endtime = new Date.now().millisecondsSinceEpoch;

  window.requestAnimationFrame(_loop);
}

void main() {

  fpsDisplay = query('div#fps');

  canvasManager = new CanvasManager(query('canvas#game_canvas'));
  canvasManager.resize(CANVAS_WIDTH, CANVAS_HEIGHT);

  canvasDrawer = new CanvasDrawer(canvasManager);
  canvasDrawer.setBounds(CANVAS_WIDTH, CANVAS_HEIGHT);
  canvasDrawer.setOffset(0, 0);
  canvasDrawer.backgroundColor = 'black';

  drawer = new DrawingComponent(canvasManager, canvasDrawer, true);

  keyboard = new SimpleInputComponent(drawer);
  canvasManager.addKeyboardListener(keyboard);

  level = new Level1(canvasManager, canvasDrawer);

  player = new Player(level, DIR_DOWN, CANVAS_WIDTH ~/ 2, CANVAS_HEIGHT ~/ 2);
  player.setControlComponent(keyboard);
  player.setDrawingComponent(drawer);

  level.addPlayerObject(player);

  NPC npc1 = new NPC(level, DIR_RIGHT, 0, 0);
  NPC npc2 = new NPC(level, DIR_DOWN, 20, 48);
  npc1.setSpeed(2);
  npc2.setSpeed(2);
  npc1.setControlComponent(new NPCInputComponent());
  npc2.setControlComponent(new NPCInputComponent());
  npc1.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc2.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));

  level.addObject(npc1);
  level.addObject(npc2);

  _loop(0);
}
