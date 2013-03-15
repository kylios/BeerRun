import 'dart:html';
import 'dart:async';

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
        new DrawingComponent(this._canvasManager, this._canvasDrawer, true);

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

  }

  bool get continueLoop => this._continueLoop;

  void start() {
    this._ui.showView(
        new Dialog("Welcome to the party of the century!  We've got music, games, dancing, booze... oh... wait... someone's gotta bring that last one.  Too bad, looks like you drew the short straw here buddy... we need you to go out and get some BEER if you wanna come to the party.  Oh yea, and we recommend you maintain a healthy buzz.  Good luck!"));


    /*
    this._canvasDrawer.clear();
    this._currentLevel.draw(this._canvasDrawer);

    new Timer.repeating(new Duration(milliseconds: 50), (Timer t) {

      // Move the viewport closer to the beer store
      this._canvasDrawer.moveOffset(-5, -5);

      this._canvasDrawer.clear();
      this._currentLevel.draw(this._canvasDrawer);
    });
    */


    this._timer.startCountdown();
  }

  void update() {

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

    Duration duration = this._timer.getRemainingTime();

    // Draw HUD
    // TODO: HUD class?
    this._canvasDrawer.backgroundColor = "rgba(224, 224, 224, 0.5)";
    this._canvasDrawer.fillRect(0, 0, 180, 92, 8, 8);
    this._canvasDrawer.backgroundColor = "black";
    this._canvasDrawer.font = "bold 22px sans-serif";
    this._canvasDrawer.drawText("BAC: ${(this._player.drunkenness.toDouble() / 10.0 * 0.24).toStringAsFixed(2)}%", 8, 26);
    this._canvasDrawer.drawText("Beers: ${this._player.beers}", 8, 52);
    this._canvasDrawer.drawText("HP: ${this._player.health}", 8, 80);
    this._canvasDrawer.backgroundColor = "white";
    this._canvasDrawer.font = "bold 32px sans-serif";
    this._canvasDrawer.drawText("${duration.toString()}", 320, 48);

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
