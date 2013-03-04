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

// Notification flags.
bool notifyCar = true;
bool notifyTheft = true;
bool gameOver = false;
bool notifyBored = true;

int score = 0;

void onGameOver() {

}

void _loop(var _) {

  /*
  ticksum-=ticklist[tickindex];  /* subtract value falling off */
  ticksum+=(endtime - starttime);              /* add new value */
  ticklist[tickindex]=(endtime - starttime);   /* save new value so it can be subtracted later */
  if(++tickindex==MAXSAMPLES)    /* inc buffer index */
    tickindex=0;
  fpsDisplay.innerHtml = (ticksum.toDouble() / MAXSAMPLES.toDouble()).toString();
  */

  canvasDrawer.clear();

  starttime = new DateTime.now().millisecondsSinceEpoch;

  level.update();

  // Notify player
  if (notifyCar && player.wasHitByCar) {

    notifyCar = false;
    ui.showView(new Dialog("Fuck.  Watch where you're going!"),
        pause: false, seconds: 5);

  } else if (notifyTheft && player.wasBeerStolen) {

    notifyTheft = false;
    ui.showView(new Dialog("Ohhh, the bum stole a beer!  One less for you!"),
        pause: false, seconds: 5);
  } else if (notifyBored && player.boredNotify) {
    notifyBored = false;
    ui.showView(
        new Dialog("Better drink a beer or this is going to get real boring"),
        pause: false, seconds: 5);
  }

  if (player.beersDelivered > 0) {
    score += player.beersDelivered;
    query("#score").innerHtml = score.toString();
    player.resetBeersDelivered();
    ui.showView(new Dialog("Sick dude, beers! We'll need you to bring us more though.  Go back and bring us more beer!"), pause: true);
  }

  if (player.drunkenness <= 0) {
    ui.showView(new Dialog("You're too sober.  You got bored and go home.  GAME OVER!"), pause: true);
    gameOver = true;
  } else if (player.drunkenness >= 10) {
    ui.showView(new Dialog("You black out like a dumbass, before you even get to the party.  GAME OVER!"), pause: true);
    gameOver = true;
  }
  if (player.health == 0) {
    ui.showView(new Dialog("You are dead.  GAME OVER!"), pause: true);
    gameOver = true;
  }

  // Draw HUD
  // TODO: HUD class?
  canvasDrawer.backgroundColor = "rgba(224, 224, 224, 0.5)";
  canvasDrawer.fillRect(0, 0, 180, 92, 8, 8);
  canvasDrawer.backgroundColor = "black";
  canvasDrawer.font = "bold 22px sans-serif";
  canvasDrawer.drawText("BAC: ${(player.drunkenness.toDouble() / 10.0 * 0.24).toStringAsFixed(2)}%", 8, 26);
  canvasDrawer.drawText("Beers: ${player.beers}", 8, 52);
  canvasDrawer.drawText("HP: ${player.health}", 8, 80);

  endtime = new DateTime.now().millisecondsSinceEpoch;

  if (gameOver) {
    onGameOver();
    return;
  } else {
    window.requestAnimationFrame(_loop);
  }
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

  keyboard = new PlayerInputComponent(drawer);
  canvasManager.addKeyboardListener(keyboard);

  level = new Level1(canvasManager, canvasDrawer);

  player = new Player(level, DIR_DOWN, 32 * 36, 32 * 5);
  player.addBeers(3);
      //16, level.tileHeight * level.rows - 64);
  player.setControlComponent(keyboard);
  player.setDrawingComponent(drawer);

  level.addPlayerObject(player);

  NPC npc1 = new NPC(level, DIR_RIGHT, 0, 400);
  NPC npc2 = new NPC(level, DIR_DOWN, 20, 320);
  NPC npc3 = new NPC(level, DIR_LEFT, 160, 420);
  NPC npc4 = new NPC(level, DIR_UP, 17 * level.tileWidth, 20);
  NPC npc5 = new NPC(level, DIR_DOWN, 17 * level.tileWidth, 28 * level.tileHeight);
  NPC npc6 = new NPC(level, DIR_UP, 36 * level.tileWidth, 25 * level.tileHeight);
  NPC npc7 = new NPC(level, DIR_RIGHT, 33 * level.tileWidth, 11 * level.tileHeight);
  npc1.speed = 2;
  npc2.speed = 2;
  npc3.speed = 3;
  npc4.speed = 2;
  npc5.speed = 2;
  npc6.speed = 1;
  npc7.speed = 1;
  npc1.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc2.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc3.setControlComponent(new NPCInputComponent(level.npcRegion1));
  npc4.setControlComponent(new NPCInputComponent(level.npcRegion2));
  npc5.setControlComponent(new NPCInputComponent(level.npcRegion2));
  npc6.setControlComponent(new NPCInputComponent(level.npcRegion3));
  npc7.setControlComponent(new NPCInputComponent(level.npcRegion4));
  npc1.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc2.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc3.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc4.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc5.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc6.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));
  npc7.setDrawingComponent(new DrawingComponent(canvasManager, canvasDrawer, false));

  level.addObject(npc1);
  level.addObject(npc2);
  level.addObject(npc3);
  level.addObject(npc4);
  level.addObject(npc5);
  level.addObject(npc6);
  level.addObject(npc7);

  ui = new UI(query("#root_pane"), player);

  // Don't invoke UI every frame
  ui.showView(new Dialog("Welcome to the party of the century!  We've got music, games, dancing, booze... oh... wait... someone's gotta bring that last one.  Too bad, looks like you drew the short straw here buddy... we need you to go out and get some BEER if you wanna come to the party.  Oh yea, and we recommend you maintain a healthy buzz.  Good luck!"));

  _loop(0);
}
