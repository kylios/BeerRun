part of game;

class GameManager implements GameTimerListener, KeyboardListener, UIListener,
    ComponentListener {

  int _tickNo = 0;

  StatsManager _statsManager;
  CanvasManager _canvasManager;
  CanvasDrawer _canvasDrawer;
  AudioManager _audio;

  AudioToggle _musicToggle;
  AudioToggle _soundToggle;

  final int _canvasWidth;
  final int _canvasHeight;

  int _score = 0;
  int _totalScore = 0;
  bool _wonLevel = false;

  UI _ui;
  UI _notifications;
  BeerRunHUD _hud;
  Player _player;

  GameTimer _timer;
  Level _currentLevel;
  int _currentLevelIdx = 0;

  bool _notifyDrunk = true;

  bool _continueLoop = false;
  bool _showHUD = false;
  bool _pause = false;
  bool _gameOver = true;
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

  // FPS
  int _now;
  double _fps = 0.0;
  int _lastUpdate = new DateTime.now().millisecondsSinceEpoch;

  List<Level> _levels = new List<Level>();

  int get tickNo => this._tickNo;

  PlayerInputComponent _tmpInputComponent = null;

  static GameManager _instance = null;
  factory GameManager({canvasWidth, canvasHeight,
    CanvasElement canvasElement,
      DivElement UIRootElement,
      DivElement NotificationsRootElement,
      DivElement DialogElement,
      DivElement statsElement,
      DivElement fpsElement,
      InputElement musicOnElement,
      InputElement musicOffElement,
      InputElement soundOnElement,
      InputElement soundOffElement}) {

    if (GameManager._instance == null) {
      GameManager._instance = new GameManager._internal(
          canvasWidth, canvasHeight,
          canvasElement,
          UIRootElement, NotificationsRootElement,
          DialogElement, statsElement,
          fpsElement,
          musicOnElement, musicOffElement, soundOnElement, soundOffElement);
    }

    return GameManager._instance;
  }

  GameManager._internal(this._canvasWidth, this._canvasHeight,
      CanvasElement canvasElement,
      DivElement UIRootElement,
      DivElement NotificationsRootElement,
      DivElement DialogElement,
      DivElement statsElement,
      DivElement fpsElement,
      InputElement musicOnElement,
      InputElement musicOffElement,
      InputElement soundOnElement,
      InputElement soundOffElement) {

    this._statsManager = new StatsManager(statsElement, fpsElement);

    this._canvasManager = new CanvasManager(canvasElement);
    this._canvasManager.resize(this._canvasWidth, this._canvasHeight);

    this._canvasDrawer = new CanvasDrawer(this._canvasManager);
    this._canvasDrawer.setOffset(0, 0);
    this._canvasDrawer.backgroundColor = 'black';

    PlayerInputComponent playerInput =
        new PlayerInputComponent();
    this._canvasManager.addKeyboardListener(playerInput);
    this._canvasManager.addKeyboardListener(this);

    this._player = new Player(this._statsManager);
    this._player.setControlComponent(playerInput);

    this._ui = new UI(UIRootElement, this._canvasWidth, this._canvasHeight);
    this._ui.addListener(this);

    this._notifications = new UI(NotificationsRootElement, this._canvasWidth, this._canvasHeight);

    this._hud = new BeerRunHUD(this._canvasDrawer, this._player);

    this._BACMeter = new Meter(10, 52, 10, 116, 22);
    this._HPMeter = new Meter(3, 52, 36, 116, 22);

    this._audio = new AudioManager();

    this._musicToggle = new AudioToggle(true, musicOnElement, musicOffElement);
    this._soundToggle = new AudioToggle(false, soundOnElement, soundOffElement);

    this._musicToggle.addListener(this._audio);
    this._soundToggle.addListener(this._audio);
  }

  Future init() {
    return this._setupLevels()
        .then(this._setupAudio);
  }

  UIInterface get ui => this._ui;

  /**
   * Prereqs:
   * - this._canvasManager
   * - this._canvasDrawer
   */
  Future _setupLevels() {

    List<String> levels = [
        //"data/levels/test_level.json",
        "data/levels/new_sample_level.json",
        "data/levels/level1.json",
        "data/levels/level2.json",
        "data/levels/level5.json"
                           ];

    Loader l = new Loader();

    Future f = null;
    for (String levelPath in levels) {

      var fn = (String url) {
        Completer<Level> c = new Completer<Level>();
        l.load(url)
          .then((Map levelData) {
            return new Level.fromJson(
                levelData, this._canvasDrawer,
                this._canvasManager,
                this._player);
          })
          .then((Level l) {

            window.console.log("adding level");
            this._levels.add(l);
            c.complete(l);
          })
          .catchError((e) {
            print("[1] Got error: ${e}");
            return 42;
          });
        return c.future;
      };

      if (f == null) {
        f = fn(levelPath);
      } else {
        f = f.then((Level l) {
          return fn(levelPath);
        }).catchError((e) {
          print("Got error: ${e.error}");     // Finally, callback fires.
          return 42;                          // Future completes with 42.
        });
      }


    }

    return f;
  }

  Future _setupAudio(var _) {

    Completer c = new Completer();

    this._audio.addMusic('theme', 'audio/theme.wav');
    this._audio.loadAndDecode().then((var _) {
      this._musicToggle.toggleOff();
      this._soundToggle.toggleOff();
      c.complete();
    });
    return c.future;
  }

  bool get continueLoop => this._continueLoop;

  void _runInternal(var _) {
    if (this._continueLoop) {
      this.update();
    }
    window.requestAnimationFrame(this._runInternal);
  }

  void run() {
    this.start();

    this._runInternal(Null);
  }

  void start() {

    // Start audio - TODO: make it easier to stop it
    Song s = this._audio.getSong('theme');
    window.console.log("song: $s");
    s.loop();

    this.startNextLevel();
    this._continueLoop = true;
  }

  void startNextLevel() {

    this._showHUD = false;
    this._pause = false;
    this._score = 0;
    this._wonLevel = false;

    this._currentLevel = this._getNextLevel();
    this._canvasDrawer.setBounds(
        this._currentLevel.cols * this._currentLevel.tileWidth,
        this._currentLevel.rows * this._currentLevel.tileHeight);
    this._player.startInLevel(this._currentLevel);
    this._player.setDrawingComponent(new PlayerDrawingComponent(
        this._canvasManager, this._canvasDrawer, true));
    this._timer = new GameTimer(this._currentLevel.duration);
    this._timer.addListener(this);

    this._canvasDrawer.clear();
    this._currentLevel.draw(this._canvasDrawer);

    /*View screen = new ScoreScreen(true,
        12, 600, 980,
        new Duration(minutes: 1, seconds: 30), new Duration(seconds: 20));*/
    View screen = new LevelRequirementsScreen(
        this.ui,
        "Level ${this._currentLevelIdx}",
        this._currentLevel.beersToWin,
        this._currentLevel.duration);

    // Run this level's tutorial, show level requirements,
    // and then start the game
    this._currentLevel.tutorial.run()
      .then((var _) =>
          this._ui.showView(
              screen, callback: () => this._endTutorial()));
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
          this.ui,
          this._wonLevel,
          this._score,
          converted,
          this._totalScore,
          this._timer.duration,
          this._timer.getRemainingTime()),
        callback: (this._wonLevel ? this.startNextLevel : this.stop));
  }

  void _endTutorial() {

    this._player.updateBuzzTime();
    this._timer.startCountdown();

    this._gameOver = false;
  }

  int _getConvertedScore(int score, int req, Duration timeLeft) {
    int seconds = timeLeft.inSeconds;
    return req + (score - req) * seconds;
  }

  void listen(GameEvent e) {

    if (e.type == GameEvent.GAME_WON_EVENT &&
        this._currentLevel.tutorial.isComplete && ! this._wonLevel) {
      this._wonLevel = true;
      this._gameOver = true;
      this._onGameOver();
    } else if (e.type == GameEvent.GAME_LOST_EVENT) {

    } else if (e.type == GameEvent.ADD_SCORE_EVENT) {
      int scoreDelta = e.value;
      this._score += scoreDelta;
    } else if (e.type == GameEvent.NOTIFICATION_EVENT) {
        String message = e.data['message'];
        int seconds = e.data['seconds'];

        TextView v = new TextView(this._notifications, message);
        this._notifications.showView(v, seconds: seconds);
    }

    return;
  }

  // This is the main update loop
  void update() {

    if (this._canvasDrawer != null) {
      //this._canvasDrawer.clear();
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

    this._player.update();
    this._player.draw();

    /*
    if (this._currentLevel.tutorial.isComplete && ! this._wonLevel) {

      if (this._score >= this._currentLevel.beersToWin) {
        this._wonLevel = true;
        this._gameOver = true;
      }
    }
    */

    if (this._player.drunkenness <= 0) {
      this._setGameOver(true, "You're too sober.  You got bored and go home.  GAME OVER!");
    } else if (this._player.drunkenness >= 10) {
      this._setGameOver(true, "You black out like a dumbass, before you even get to the party!");
    } else if (this._player.health == 0) {
      this._setGameOver(true, "Oops, you are dead!");
      this._currentLevel.removeObject(this._player);
    }


    // Draw HUD
    if (this._player.drunkenness == 1 || this._player.drunkenness >= 8) {
      this._hud.startFlashing();
    } else {
      this._hud.stopFlashing();
    }
    this._hud.draw();

    this._tickNo++;


    // Update fps
    this._now = new DateTime.now().millisecondsSinceEpoch;
    double thisFrameFps = 1000 / (this._now - this._lastUpdate);
    this._fps += (thisFrameFps - this._fps) / 50;
    this._lastUpdate = this._now;

    this._statsManager.fps = this._fps.toInt();
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

    this._ui.showView(
        new GameOverScreen(this.ui, text),
        callback: () => this._endTutorial());
  }

  void _onGameOver() {
    window.console.log("onGameOver");
    if (! this._wonLevel) {
      this.stop();
    }
    if (this._gameOverDialog) {
      this._pause = true;
      this._ui.showView(
        new Dialog.text(this._ui, this._gameOverText),
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
        this._currentLevel.tutorial.skip();
        break;
      case KeyboardListener.KEY_S:
        this._DEBUG_showScoreScreen = true;
        break;
    }
  }
}
