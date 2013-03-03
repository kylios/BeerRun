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
import 'package:BeerRun/ui.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

CanvasManager canvasManager;
CanvasDrawer canvasDrawer;

UI ui;

Level1 level;

PlayerInputComponent keyboard;
DrawingComponent drawer;

Player player;

DivElement fpsDisplay;
final int MAXSAMPLES = 100;
int tickindex=0;
int ticksum=0;
List<int> ticklist = new List<int>.fixedLength(MAXSAMPLES, fill: 0);
int starttime = 0;
int endtime = 0;

bool introPopup = true;

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

  // Draw HUD
  // TODO: HUD class?
  canvasDrawer.backgroundColor = "blue";
  canvasDrawer.drawRect(0, 0, 180, 92, 8, 8);
  canvasDrawer.font = "bold 12px sans-serif";
  canvasDrawer.drawText("Drunkenness: ${player.drunkenness}", 8, 8);
  canvasDrawer.drawText("Speed: ${player.speed}", 8, 26);

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

  ui = new UI(new CanvasDrawer(canvasManager));

  drawer = new DrawingComponent(canvasManager, canvasDrawer, true);

  keyboard = new PlayerInputComponent(drawer);
  canvasManager.addKeyboardListener(keyboard);

  level = new Level1(canvasManager, canvasDrawer);

  player = new Player(level, DIR_DOWN, 32 * 36, 32 * 5);
      //16, level.tileHeight * level.rows - 64);
  player.setControlComponent(keyboard);
  player.setDrawingComponent(drawer);

  level.addPlayerObject(player);

  NPC npc1 = new NPC(level, DIR_RIGHT, 0, 400);
  NPC npc2 = new NPC(level, DIR_DOWN, 20, 320);
  NPC npc3 = new NPC(level, DIR_LEFT, 160, 420);
  npc1.speed = 2;
  npc2.speed = 2;
  npc3.speed = 3;
  npc1.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc2.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc3.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc1.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc2.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc3.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));

  level.addObject(npc1);
  level.addObject(npc2);
  level.addObject(npc3);

  // Don't invoke UI every frame
  ui.showView(new Dialog("Welcome to the party of the century!  We've got music, games, dancing, booze... oh... wait... someone's gotta bring that last one.  Too bad, looks like you drew the short straw here buddy... we need you to go out and get some BEER if you wanna come to the party.  Oh yea, and we recommend you maintain a healthy buzz.  Good luck!"));

  _loop(0);
}
