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

import 'level1.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

GameManager game;

class GameManager implements GameTimerListener {

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

  bool _inTutorial = true;
  int _tutorialDestX = 0;
  int _tutorialDestY = 0;

  // HUD
  Meter _BACMeter;
  Meter _HPMeter;

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

    this._currentLevel = this._getNextLevel();
    this._timer = new GameTimer(this._currentLevel.duration);
    this._timer.addListener(this);

    this._player = new Player(this._currentLevel, DIR_DOWN, 32 * 36, 32 * 5);
    this._player.speed = 1;
    this._player.addBeers(3);
    this._player.setControlComponent(playerInput);
    this._player.setDrawingComponent(drawer);

    this._currentLevel.addPlayerObject(this._player);

    this._ui = new UI(UIRootElement, this._player);

    this._BACMeter = new Meter(10, 52, 10, 116, 22);
    this._HPMeter = new Meter(3, 52, 36, 116, 22);

  }

  bool get continueLoop => this._continueLoop;

  void _endTutorial() {

    this._player.setPos(32 * 36, 32 * 5);
    this._timer.startCountdown();
    this._inTutorial = false;
    this._player.setDrawingComponent(
        new PlayerDrawingComponent(this._canvasManager, this._canvasDrawer, true)
      );
  }

  void _continueTutorial3() {
    window.console.log("continueTutorial3");

    this._ui.showView(
        new Dialog("Well, what are you waiting for!?  Better get going!  Oh yea, and don't forget to keep your buzz going... don't get bored and bail on us!"),
        callback: this._endTutorial
      );
  }

  void _continueTutorial2() {
    window.console.log("continueTutorial2");

    int tutorialDestX = this._currentLevel.startX;
    int tutorialDestY = this._currentLevel.startY;
    Timer _t = new Timer.periodic(new Duration(milliseconds: 5), (Timer t) {

      int offsetX = this._canvasDrawer.offsetX;
      int offsetY = this._canvasDrawer.offsetY;

      window.console.log("$offsetX - $offsetY");
      if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
        t.cancel();
        this._continueTutorial3();
        return;
      }

      int moveX;
      if (tutorialDestX < offsetX) {
        moveX = max(-5, tutorialDestX - offsetX);
      } else {
        moveX = min(5, tutorialDestX - offsetX);
      }
      int moveY;
      if (tutorialDestY < offsetY) {
        moveY = max(-5, tutorialDestY - offsetY);
      } else {
        moveY = min(5, tutorialDestY - offsetY);
      }


      // Move the viewport closer to the beer store
      this._canvasDrawer.moveOffset(moveX, moveY);

      this._canvasDrawer.clear();
      this._currentLevel.draw(this._canvasDrawer);
    });
  }

  void _continueTutorial() {

    this._ui.showView(
        new Dialog("Grab us a 24 pack and bring it back.  Better avoid the bums... they like to steal your beer, and then you'll have to go BACK and get MORE!"),
        callback: this._continueTutorial2
      );
  }

  void _startTutorial() {

    this._inTutorial = true;
    int tutorialDestX = this._currentLevel.storeX;
    int tutorialDestY = this._currentLevel.storeY;
    Timer _t = new Timer.periodic(new Duration(milliseconds: 20), (Timer t) {

      int offsetX = this._canvasDrawer.offsetX;
      int offsetY = this._canvasDrawer.offsetY;

      if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
        t.cancel();
        this._continueTutorial();
        return;
      }

      int moveX;
      if (tutorialDestX < offsetX) {
        moveX = max(-5, tutorialDestX - offsetX);
      } else {
        moveX = min(5, offsetX - tutorialDestX);
      }
      int moveY;
      if (tutorialDestY < offsetY) {
        moveY = max(-5, offsetY - tutorialDestY);
      } else {
        moveY = min(5, tutorialDestY - offsetY);
      }


      // Move the viewport closer to the beer store
      this._canvasDrawer.moveOffset(moveX, moveY);

      this._canvasDrawer.clear();
      this._currentLevel.draw(this._canvasDrawer);
    });
  }

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
        callback: this._startTutorial //this._endTutorial //
      );
  }

  void update() {

    // Check win condition
    if (true || this._currentLevel.beersToWin <= this._player.beers) {
      // you win.. next level.
      // TODO:
      ScoreScreen ss = new ScoreScreen();
      this._ui.showView(ss, pause: true);
    }

    this._canvasDrawer.clear();
    this._currentLevel.update();

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
    if (!this._inTutorial) {
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

    Level level = new Level1(
        this._canvasManager, this._canvasDrawer);

    return level;
  }

  void _onGameOver() {

    // Do gameover stuff
    stop();
  }

  void onTimeOut() {
    this.stop();

    this._ui.showView(
        new Dialog("You took way too long.  Go home!  GAME OVER"),
        pause: true);
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
