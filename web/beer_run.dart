import 'dart:html';
import 'dart:async';

import 'package:beer_run/canvas_manager.dart';
import 'package:beer_run/drawing.dart';
import 'package:beer_run/input.dart';
import 'package:beer_run/game.dart';
import 'package:beer_run/level.dart';
import 'package:beer_run/player.dart';
import 'package:beer_run/ui.dart';
import 'package:beer_run/beer_run.dart';
import 'package:beer_run/tutorial.dart';
import 'package:beer_run/loader.dart';

final int CANVAS_WIDTH = 640;
final int CANVAS_HEIGHT = 480;

GameManager game;

class GameManager implements GameTimerListener, KeyboardListener, UIListener {

  StatsManager _statsManager;
  CanvasManager _canvasManager;
  CanvasDrawer _canvasDrawer;

  int _score = 0;
  int _totalScore = 0;
  bool _wonLevel = false;

  UI _ui;
  BeerRunHUD _hud;
  Player _player;

  GameTimer _timer;
  Level _currentLevel;
  int _currentLevelIdx = 0;

  bool _notifyCar = true;
  bool _notifyTheft = true;
  bool _notifyBored = true;
  bool _notifyDrunk = true;

  bool _continueLoop = false;
  bool _showHUD = false;
  bool _pause = false;
  bool _gameOver = false;
  bool _gameOverDialog = false;
  String _gameOverText = '';

  int _tutorialDestX = 0;
  int _tutorialDestY = 0;

  // HUD
  Meter _BACMeter;
  Meter _HPMeter;

  // Debug settings
  bool _DEBUG_skipTutorial = false;
  bool _DEBUG_showScoreScreen = false;

  List<Level> _levels = new List<Level>();


  PlayerInputComponent _tmpInputComponent = null;

  GameManager(CanvasElement canvasElement,
      DivElement UIRootElement,
      DivElement DialogElement,
      DivElement statsElement) {

    this._statsManager = new StatsManager(statsElement);

    this._canvasManager = new CanvasManager(canvasElement);
    this._canvasManager.resize(CANVAS_WIDTH, CANVAS_HEIGHT);

    this._canvasDrawer = new CanvasDrawer(this._canvasManager);
    this._canvasDrawer.setOffset(0, 0);
    this._canvasDrawer.backgroundColor = 'black';

    DrawingComponent drawer =
        new DrawingComponent(this._canvasManager, this._canvasDrawer, false);

    PlayerInputComponent playerInput =
        new PlayerInputComponent();
    this._canvasManager.addKeyboardListener(playerInput);
    this._canvasManager.addKeyboardListener(this);

    this._player = new Player(this._statsManager);
    this._player.setHealth(3);
    this._player.speed = 1;
    this._player.addBeers(3);
    this._player.setControlComponent(playerInput);
    this._player.setDrawingComponent(drawer);

    this._ui = new UI(UIRootElement);
    this._ui.addListener(this);

    this._hud = new BeerRunHUD(this._canvasDrawer, this._player);

    this._BACMeter = new Meter(10, 52, 10, 116, 22);
    this._HPMeter = new Meter(3, 52, 36, 116, 22);
  }

  Future init() {
    return this._setupLevels();
  }



  /**
   * Prereqs:
   * - this._canvasManager
   * - this._canvasDrawer
   */
  Future _setupLevels() {

    Completer<Level> c = new Completer<Level>();

    List<String> levels = [
        "data/levels/test_level.json",
        "data/levels/level1.json",
        "data/levels/level2.json",
        "data/levels/level5.json"
                           ];

    Loader l = new Loader();
    Future f = c.future;
    l.load(levels[0]).then((Map levelData) {
      Level level = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      this._levels.add(level);
      c.complete();
    });
    l.load(levels[1]).then((Map levelData) {
      Level level = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      f.then((var _) {
        this._levels.add(level);
        c = new Completer();
        f = c.future;
      });
    });
    l.load(levels[2]).then((Map levelData) {
      Level level = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      f.then((var _) {
        this._levels.add(level);
        c = new Completer();
        f = c.future;
      });
    });
    l.load(levels[3]).then((Map levelData) {
      Level level = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      f.then((var _) {
        this._levels.add(level);
        c = new Completer();
        f = c.future;
      });
    });


/*
    l.load("data/levels/test_level.json")
    .then((Map levelData) {
      Level l = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      this._levels.add(l);
      c.complete();
    (new Loader()).load("data/levels/level1.json")
    .then((Map levelData) {
      Level l = new Level.fromJson(levelData, this._canvasDrawer, this._canvasManager);
      this._levels.add(l);


      (new Loader()).load("data/levels/level2.json")
      .then((Map levelData) {
        this._levels.add(
            new Level.fromJson(levelData,
                               this._canvasDrawer, this._canvasManager));

        (new Loader()).load("data/levels/level5.json")
        .then((Map levelData) {
          this._levels.add(
              new Level.fromJson(levelData,
                                 this._canvasDrawer, this._canvasManager));
        });
      });
    });

      });
*/


    return c.future;
  }

  bool get continueLoop => this._continueLoop;

  void start() {
    this.startNextLevel();
    this._continueLoop = true;
  }

  void startNextLevel() {

    this._showHUD = false;
    this._pause = false;
    this._score = 0;
    this._wonLevel = false;
    this._gameOver = false;

    this._currentLevel = this._getNextLevel();
    this._canvasDrawer.setBounds(
        this._currentLevel.cols * this._currentLevel.tileWidth,
        this._currentLevel.rows * this._currentLevel.tileHeight);
    this._player.startInLevel(this._currentLevel);

    this._timer = new GameTimer(this._currentLevel.duration);
    this._timer.addListener(this);

    // TODO: super hack.  Let's figure out how to script a level, k?
    if (this._currentLevel.name == 'level1') {
      Level.setupTutorial(this._currentLevel, this._ui, this._player);
    }
    //this._currentLevel.setupTutorial(this._ui, this._player);
    this._currentLevel.addPlayerObject(this._player);

    this._canvasDrawer.clear();
    this._currentLevel.draw(this._canvasDrawer);

    /*View screen = new ScoreScreen(true,
        12, 600, 980,
        new Duration(minutes: 1, seconds: 30), new Duration(seconds: 20));*/
    View screen = new LevelRequirementsScreen(
        "Level ${this._currentLevelIdx}",
        this._currentLevel.beersToWin,
        this._currentLevel.duration);
    this._currentLevel.tutorial.run()
      .then((var _) =>
          this._ui.showView(
                            screen,
                            callback: () => this._endTutorial()));

    //this._currentLevel.tutorial.run().then((var _) => this._endTutorial());
  }

  void stopLevel() {
    int converted = 0;
    if (this._wonLevel) {
      converted = this._getConvertedScore(
        this._score,
        this._currentLevel.beersToWin,
        this._timer.getRemainingTime());
    }

    this._timer.stop();

    this._totalScore += converted;

    // TODO: set score in stats manager

    this._ui.showView(
        new ScoreScreen(
          this._wonLevel,
          this._score,
          converted,
          this._totalScore,
          this._timer.duration,
          this._timer.getRemainingTime()),
        callback: (this._wonLevel ? this.startNextLevel : this.stop));
  }

  void _endTutorial() {

    int playerStartX = this._currentLevel.startX;
    int playerStartY = this._currentLevel.startY;
    this._player.setPos(playerStartX, playerStartY);
    this._player.setDrawingComponent(new PlayerDrawingComponent(
        this._canvasManager, this._canvasDrawer, true));
    this._player.updateBuzzTime();
    this._timer.startCountdown();
  }

  int _getConvertedScore(int score, int req, Duration timeLeft) {
    int seconds = timeLeft.inSeconds;
    return req + (score - req) * seconds;
  }


  // This is the main update loop
  void update() {

    if (this._canvasDrawer != null) {
      this._canvasDrawer.clear();
    }

    // Can't do anything without a level object
    if (this._currentLevel == null) {
      return;
    }

   // this._statsManager.duration = this._timer.duration;

    this._currentLevel.update();
    this._statsManager.update();

    if (this._gameOver) {
      return;
    }

    this._player.draw();
    if (this._currentLevel.tutorial.isComplete && ! this._wonLevel) {

      if (this._score >= this._currentLevel.beersToWin) {
        this._wonLevel = true;
        this._gameOver = true;
      }
    }

    // Notify player
    if (this._notifyCar && this._player.wasHitByCar) {

      this._notifyCar = false;
      this._pause = true;
      this._ui.showView(new Dialog("Fuck.  Watch where you're going!"),
          seconds: 5);

    } else if (this._notifyTheft && this._player.wasBeerStolen) {

      this._notifyTheft = false;
      this._pause = true;
      this._ui.showView(
          new Message("Ohhh, the bum stole a beer!  One less for you!"),
          seconds: 5);
    } else if (this._notifyBored && this._player.boredNotify) {
      this._notifyBored = false;
      this._pause = true;
      this._ui.showView(
          new Message(
              "Your buzz is wearing off!  Drink a beer before things get too boring."),
          seconds: 5);
    } else if (this._notifyDrunk && this._player.drunkNotify) {
      this._notifyDrunk = false;
      this._ui.showView(
          new Message("Be careful, don't get too drunk!"), seconds: 5);
    }

    if (this._player.beersDelivered > 0) {
      this._score += this._player.beersDelivered;
      this._player.resetBeersDelivered();

      this._ui.showView(
          new Message("Sick dude, beers! We'll need you to bring us more though.  Go back and bring us more beer!"));
    }

    if (this._player.drunkenness <= 0) {
      this._setGameOver(true, "You're too sober.  You got bored and go home.  GAME OVER!");
    } else if (this._player.drunkenness >= 10) {
      this._setGameOver(true, "You black out like a dumbass, before you even get to the party.");
    }
    if (this._player.health == 0) {
      this._setGameOver(true, "You are dead.");
      this._currentLevel.removeObject(this._player);
    }


    // Draw HUD
    if (this._player.drunkenness == 1 || this._player.drunkenness >= 8) {
      this._hud.startFlashing();
    } else {
      this._hud.stopFlashing();
    }
    this._hud.draw();
/*
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
      */

    if (this._gameOver) {
      this._onGameOver();
    }
  }

  void stop() {
    this._continueLoop = false;
  }

  Level _getNextLevel() {
    window.console.log(window.location.hash);
    if (window.location.hash == '#level1') {
      return this._levels[0];
    } else if (window.location.hash == '#level2') {
      return this._levels[1];
    } else if (window.location.hash == '#level5') {
      return this._levels[2];
    } else {
      return this._levels[this._currentLevelIdx++];
    }
  }

  void _setGameOver(bool dialog, String text) {
    this._gameOverDialog = dialog;
    this._gameOverText = text;
    this._gameOver = true;
  }

  void _onGameOver() {
window.console.log("onGameOver");
    if (! this._wonLevel) {
      this.stop();
    }
    if (this._gameOverDialog) {
      this._pause = true;
      this._ui.showView(
        new Dialog(this._gameOverText),
        callback: () {
          this._pause = true;
          this._player.level.pause();
          this.stopLevel();
      });
    } else {
      this.stopLevel();
    }
  }

  void onWindowOpen(UI ui) {
    // only IF we NEED to
    if (this._pause) {
      this._player.level.pause();
      this._tmpInputComponent = this._player.getControlComponent();
      this._player.setControlComponent(new NullInputComponent());
      this._pause = false;
    }
  }
  void onWindowClose(UI ui) {

    if (this._tmpInputComponent != null) {
      this._player.setControlComponent(this._tmpInputComponent);
    }
    this._player.level.unPause();
  }

  void onTimeOut(GameTimer t) {
    this.stopLevel();
  }

  void onTick(GameTimer t) {
    this._statsManager.duration = t.getRemainingTime();
  }

  void onKeyDown(KeyboardEvent e) {

  }

  void onKeyUp(KeyboardEvent e) {

  }

  void onKeyPressed(KeyboardEvent e) {
window.console.log("key pressed: ${e.keyCode}");
    switch (e.charCode) {

      case KeyboardListener.KEY_T:
        this._currentLevel.tutorial.skip(null);
        break;
      case KeyboardListener.KEY_S:
        this._DEBUG_showScoreScreen = true;
        break;
    }
  }
}

void _loop(var _) {

  if (game.continueLoop) {
    game.update();
  }

  window.requestAnimationFrame(_loop);
}

void main() {

  game = new GameManager(
      query('canvas#game_canvas'),
      query('div#root_pane'),
      query('div#dialog'),
      query('div#stats'));

  game.init().then((var _) => game.start());



  _loop(0);
}
