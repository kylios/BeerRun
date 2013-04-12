import 'dart:html';
import 'dart:async';
import 'dart:math';

import 'package:BeerRun/canvas_manager.dart';
import 'package:BeerRun/drawing.dart';
import 'package:BeerRun/component.dart';
import 'package:BeerRun/input.dart';
import 'package:BeerRun/game.dart';
import 'package:BeerRun/level.dart';
import 'package:BeerRun/player.dart';
import 'package:BeerRun/npc.dart';
import 'package:BeerRun/ui.dart';
import 'package:BeerRun/beer_run.dart';
import 'package:BeerRun/tutorial.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

GameManager game;

class GameManager implements GameTimerListener, KeyboardListener {

  CanvasManager _canvasManager;
  CanvasDrawer _canvasDrawer;

  int _score = 0;

  UI _ui;
  Player _player;

  GameTimer _timer;
  Level _currentLevel;

  bool _notifyCar = true;
  bool _notifyTheft = true;
  bool _notifyBored = true;

  bool _continueLoop = true;
  bool _showHUD = false;

  int _tutorialDestX = 0;
  int _tutorialDestY = 0;

  // HUD
  Meter _BACMeter;
  Meter _HPMeter;

  // Debug settings
  bool _DEBUG_skipTutorial = false;
  bool _DEBUG_showScoreScreen = false;

  GameManager(CanvasElement canvasElement,
      DivElement UIRootElement,
      SpanElement scoreElement) {

    this._canvasManager = new CanvasManager(canvasElement);
    this._canvasManager.resize(CANVAS_WIDTH, CANVAS_HEIGHT);

    this._canvasDrawer = new CanvasDrawer(this._canvasManager);
    this._canvasDrawer.setBounds(CANVAS_WIDTH, CANVAS_HEIGHT);
    this._canvasDrawer.setOffset(0, 0);
    this._canvasDrawer.backgroundColor = 'black';

    DrawingComponent drawer =
        new DrawingComponent(this._canvasManager, this._canvasDrawer, false);

    PlayerInputComponent playerInput =
        new PlayerInputComponent(drawer);
    this._canvasManager.addKeyboardListener(playerInput);
    this._canvasManager.addKeyboardListener(this);

    this._currentLevel = this._getNextLevel();
    this._timer = new GameTimer(this._currentLevel.duration);
    this._timer.addListener(this);

    this._player = new Player(this._currentLevel, DIR_DOWN,
        this._currentLevel.startX, this._currentLevel.startY);
    this._player.speed = 1;
    this._player.addBeers(3);
    this._player.setControlComponent(playerInput);
    this._player.setDrawingComponent(drawer);

    this._ui = new UI(UIRootElement, this._player);

    this._currentLevel.addPlayerObject(this._player);
    this._currentLevel.setupTutorial(this._ui, this._player);

    this._BACMeter = new Meter(10, 52, 10, 116, 22);
    this._HPMeter = new Meter(3, 52, 36, 116, 22);

  }

  bool get continueLoop => this._continueLoop;

  void start() {

    int tutorialStartX = this._currentLevel.startX;
    int tutorialStartY = this._currentLevel.startY;

    this._canvasDrawer.setOffset(tutorialStartX, tutorialStartY);

    this._canvasDrawer.clear();
    this._currentLevel.draw(this._canvasDrawer);

    // Start level tutorial
    this._ui.showView(
        new Dialog(
            "Welcome to the party of the century!  We've got music, games, dancing, booze... oh... wait... someone's gotta bring that last one.  Too bad, looks like you drew the short straw here buddy... we need you to head down to the STORE and get some BEER if you wanna come to the party.  You can find the store down here..."
        ),
        callback: () {
          (this._currentLevel.tutorial.run())
          .then((var _) => this._endTutorial());

          /*
          ((this._DEBUG_skipTutorial ?
            this._currentLevel.tutorial.end(null) :
              this._currentLevel.tutorial.run()))
              .then((var _) => this._endTutorial());*/
          }
      );
  }

  void _endTutorial() {
    this._player.setDrawingComponent(new PlayerDrawingComponent(
        this._canvasManager, this._canvasDrawer, true));
    this._player.updateBuzzTime();
  }



  // This is the main update loop
  void update() {

    this._canvasDrawer.clear();
    this._currentLevel.update();
    if (this._currentLevel.tutorial.isComplete) {
      this._player.draw();
      window.console.log("drawing player");
    }

    bool gameOver = false;

    // Notify player
    if (this._notifyCar && this._player.wasHitByCar) {

      this._notifyCar = false;
      this._ui.showView(new Dialog("Fuck.  Watch where you're going!"),
          pause: false, seconds: 5);

    } else if (this._notifyTheft && this._player.wasBeerStolen) {

      this._notifyTheft = false;
      this._ui.showView(new Dialog("Ohhh, the bum stole a beer!  One less for you!"),
          pause: false, seconds: 5);
    } else if (this._notifyBored && this._player.boredNotify) {
      this._notifyBored = false;
      this._ui.showView(
          new Dialog("Better drink a beer or this is going to get real boring"),
          pause: false, seconds: 5);
    }

    if (this._player.beersDelivered > 0) {
      this._score += this._player.beersDelivered;
      query("#score").innerHtml = this._score.toString();
      this._player.resetBeersDelivered();
      this._ui.showView(new Dialog("Sick dude, beers! We'll need you to bring us more though.  Go back and bring us more beer!"), pause: true);
    }

    if (this._player.drunkenness <= 0) {
      this._ui.showView(new Dialog("You're too sober.  You got bored and go home.  GAME OVER!"), pause: true);
      gameOver = true;
    } else if (this._player.drunkenness >= 10) {
      this._ui.showView(new Dialog("You black out like a dumbass, before you even get to the party.  GAME OVER!"), pause: true);
      gameOver = true;
    }
    if (this._player.health == 0) {
      this._ui.showView(new Dialog("You are dead.  GAME OVER!"), pause: true);
      gameOver = true;
    }


    // Draw HUD
    // TODO: HUD class?
    if (this._currentLevel.tutorial.isComplete) {
      this._BACMeter.value = this._player.drunkenness;
      this._HPMeter.value = this._player.health;

      String duration = this._timer.getRemainingTimeFormat();
      this._canvasDrawer.backgroundColor = "rgba(224, 224, 224, 0.5)";
      this._canvasDrawer.fillRect(0, 0, 180, 92, 8, 8);
      this._canvasDrawer.backgroundColor = "black";
      this._canvasDrawer.drawRect(0, 0, 180, 92, 8, 8);
      this._canvasDrawer.font = "bold 16px sans-serif";
      this._canvasDrawer.drawText("BAC:", 8, 26);
      this._canvasDrawer.drawText("HP:", 8, 52);
      this._canvasDrawer.drawText("Beers: ${this._player.beers}", 8, 80);
      this._canvasDrawer.backgroundColor = "white";
      this._canvasDrawer.font = "bold 32px sans-serif";
      this._canvasDrawer.drawText("You have ${duration} minutes!", 220, 48);

      this._BACMeter.draw(this._canvasDrawer);
      this._HPMeter.draw(this._canvasDrawer);
    }

    if (gameOver) {
      this._onGameOver();
      this._continueLoop = false;
    }
  }

  void stop() {
    this._continueLoop = false;
  }

  Level _getNextLevel() {

    Level level = new Level2(
        this._canvasManager, this._canvasDrawer);

    return level;
  }

  void _onGameOver() {

    // Do gameover stuff
    stop();
  }

  void onTimeOut() {
    this.stop();

    this._ui.showView(new ScoreScreen(this._score, this._timer.duration, this._timer.getRemainingTime()));
  }

  void onKeyDown(KeyboardEvent e) {

  }

  void onKeyUp(KeyboardEvent e) {

  }

  void onKeyPressed(KeyboardEvent e) {
window.console.log("key pressed: ${e.keyCode}");
    switch (e.charCode) {

      case KeyboardListener.KEY_T:
        window.console.log("key T");
        // TODO: something like tutorialmgr.skip() ???
        //this._DEBUG_skipTutorial = true;
        this._currentLevel.tutorial.skip(null);
        break;
      case KeyboardListener.KEY_S:
        this._DEBUG_showScoreScreen = true;
        break;
    }
  }
}

void _loop(var _) {

  game.update();
  if (game.continueLoop) {
    window.requestAnimationFrame(_loop);
  } else {
    return;
  }
}

void main() {

  game = new GameManager(
      query('canvas#game_canvas'),
      query('div#root_pane'),
      query('span#score'));

  game.start();



  _loop(0);
}
