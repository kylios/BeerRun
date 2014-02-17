part of game;

class GameManager implements GameTimerListener, KeyboardListener, UIListener,
    GameEventListener {

    int _tickNo = 0;

    StatsManager _statsManager;
    CanvasManager _canvasManager;
    CanvasDrawer _canvasDrawer;
    AudioManager _audio;
    Loader _loader;
    GameConfig _config;
    PageStats _pageStats;
    LoadingScreen _loadingScreen;

    AudioToggle _musicToggle;
    AudioToggle _soundToggle;

    final int _canvasWidth;
    final int _canvasHeight;

    int _beersDelivered = 0;
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
    bool _gameOver = true;
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

    Map<String, Level> _levels = new Map<String, Level>();
    List<String> _levelIdxs = new List<String>();

    int get tickNo => this._tickNo;

    PlayerInputComponent _tmpInputComponent = null;

    static GameManager _instance = null;
    factory GameManager({canvasWidth, canvasHeight,
        CanvasElement canvasElement,
        DivElement UIRootElement,
        DivElement NotificationsRootElement,
        DivElement DialogElement,
        DivElement statsElement,
        DivElement debugStatsElement,
        InputElement musicOnElement,
        InputElement musicOffElement,
        InputElement soundOnElement,
        InputElement soundOffElement}) {

        if (GameManager._instance == null) {
            GameManager._instance = new GameManager._internal(
                canvasWidth, canvasHeight,
                canvasElement,
                UIRootElement, NotificationsRootElement,
                DialogElement, statsElement, debugStatsElement,
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
            DivElement debugStatsElement,
            InputElement musicOnElement,
            InputElement musicOffElement,
            InputElement soundOnElement,
            InputElement soundOffElement) {

        this._statsManager = new StatsManager(statsElement);

        this._pageStats = new PageStats(debugStatsElement);

        this._canvasManager = new CanvasManager(canvasElement);
        this._canvasManager.resize(this._canvasWidth, this._canvasHeight);

        this._canvasDrawer = new CanvasDrawer(this._canvasManager, this._pageStats);
        this._canvasDrawer.setOffset(0, 0);
        this._canvasDrawer.backgroundColor = 'black';

        PlayerInputComponent playerInput =
            new PlayerInputComponent();
        this._canvasManager.addKeyboardListener(playerInput);
        this._canvasManager.addKeyboardListener(this);

        this._player = new Player(this, this._statsManager);
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

        this._loadingScreen = new LoadingScreen(this._ui);
    }

    UIInterface get ui => this._ui;

    Future init() {
        this._setupPageStats();

        this._ui.showView(this._loadingScreen);

        GameLoader gl = new GameLoader();
        gl.addStep(new GameLoaderStep.fromFunction("_setupConfig", this, this._setupConfig, null));
        gl.addStep(new GameLoaderStep.fromFunction("_loadLevels", this, this._loadLevels, "/data/level_config.json"));
        gl.addStep(new GameLoaderStep.fromFunction("_setupAudio", this, this._setupAudio, null));
        return gl
                .run()
                .then((var _) {
            this._pageStats.stopTimer("game_manager_init");
            this._ui.closeWindow(null);
        });
    }

    void _setupPageStats() {

        this._pageStats.startMovingAverage('fps');
        this._pageStats.startTimer("game_manager_init");
    }

    Future _setupConfig(GameLoaderStep step, var __) {

        Completer c = new Completer();

        GameConfig config = new GameConfig();
        config.load().then((loadedConfig) {
            this._config = loadedConfig;
            this._parseConfig(loadedConfig);
            c.complete(loadedConfig);
        });

        return c.future;
    }

    void _parseConfig(GameConfig config) {

        Map<String, dynamic> cfg = config.get();
        List<String> cdnHosts = cfg['application']['assets']['cdn_hosts'];
        Random r = new Random();
        String cdnHost = '';
        if (cdnHosts.length > 0) {
            cdnHost = cdnHosts[r.nextInt(cdnHosts.length)];
        }
        String assetsPath = cfg['application']['assets']['path'];
        int version = cfg['application']['assets']['version'];
        bool useCdn = (cdnHosts.length > 0);

        String url = '';
        if (useCdn) {
          url = "https://${cdnHost}${assetsPath}${version}/";
        } else {
            url = assetsPath;
        }

        this._loader = new Loader(url);
    }

    Future _loadLevels(GameLoaderStep step, String levelConfigPath) {
        return this._loader.load(levelConfigPath).then((Map config) {
            config['levels'].forEach((Map levelConfig) {
                this._levelIdxs.add(levelConfig['name']);
                GameLoaderJob loadLevel = new GameLoaderJob("Loading level ${levelConfig['name']}", this._loadLevel, levelConfig);
                step.addJob(loadLevel);
            });
        });
    }

    Future _loadLevel(GameLoaderStep step, Map levelConfig) {

        return this._loader.load(levelConfig['path']).then((Map levelData) {
            step.addJob(new GameLoaderJob("Parsing level ${levelConfig['name']}", this._parseLevel, [levelConfig, levelData]));
        });
    }

    Future _parseLevel(GameLoaderStep step, List<Map> levelInfo) {

        Map levelConfig = levelInfo[0];
        Map levelData = levelInfo[1];

        Completer c = new Completer();

        Timer.run(() {
            window.console.log("_parseLevel(${levelConfig['name']})");
            this._pageStats.startTimer("new_level_from_json");
            Level l = new Level.fromJson(
              levelData, this._canvasDrawer,
              this._canvasManager, this._player);
            this._levels[levelConfig['name']] = l;

            this._pageStats.stopTimer("new_level_from_json");
            this._pageStats.writeStat("new_level_from_json");

            c.complete();
        });

        return c.future;
    }

  Future _setupAudio(GameLoaderStep step, var _) {

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

    this._currentLevelIdx = 0;
    this._currentLevel = null;

    this._continueLoop = true;
    this.startNextLevel();
  }

  void startNextLevel() {

    this._showHUD = false;
    this._beersDelivered = 0;
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

    View screen = new LevelRequirementsScreen(
        this.ui,
        "Level ${this._currentLevelIdx}",
        this._currentLevel.beersToWin,
        this._currentLevel.duration);

    // Run this level's tutorial, show level requirements,
    // and then start the game
    this._currentLevel.runTutorial()
      .then((var _) =>
          this._ui.showView(screen,
                  callback: (var _) => this._endTutorial()));
  }

  void stopLevel(int score) {

    this._timer.stop(false);
    this._gameOver = true;

    this._totalScore += score;

    // TODO: set score in stats manager

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

      int score = this._getConvertedScore(
              this._beersDelivered,
              this._currentLevel.beersToWin,
              this._timer.getRemainingTime());

      this.stopLevel(score);
      this._ui.showView(
              new ScoreScreen(
                      this.ui,
                      this._wonLevel,
                      this._beersDelivered,
                      score,
                      this._totalScore,
                      this._timer.duration,
                      this._timer.getRemainingTime()),
                      callback: (var _) => this.startNextLevel());

    } else if (e.type == GameEvent.GAME_LOST_EVENT) {

    } else if (e.type == GameEvent.ADD_BEERS_DELIVERED_EVENT) {
      int scoreDelta = e.value;
      this._beersDelivered += scoreDelta;
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

        this._pageStats.writeAll();

        // Can't do anything without a level object
        if (this._currentLevel == null) {
            return;
        }

        // this._statsManager.duration = this._timer.duration;

        this._currentLevel.update();
        this._statsManager.update();

        // this._pageStats.setStat('fps', this._fps);

        // By exiting here on game over, we let the level objects continue updating
        // while the player is reading the game over summary
        if (this._gameOver) {
            return;
        }

        this._player.update();
        this._player.draw();

        if (this._player.drunkenness <= 0) {
            this._setGameOver("You're too sober.  You got bored and go home.  GAME OVER!");
        } else if (this._player.drunkenness >= 10) {
            this._setGameOver("You black out like a dumbass, before you even get to the party!");
        } else if (this._player.health == 0) {
            this._setGameOver("Oops, you are dead!");
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

        this._pageStats.setStat('fps', thisFrameFps);
    }

    void stop() {
        this._continueLoop = false;
    }

    Level _getNextLevel() {

        window.console.log("levelIdxs: ${this._levelIdxs}");
        window.console.log("levels: ${this._levels}");

        if (window.location.hash != '') {
            window.console.log("Hash: ${window.location.hash}");
            return this._levels[window.location.hash.substring(1)];
        } else {
            window.console.log("Idx: ${this._currentLevelIdx}, name: ${this._levelIdxs[this._currentLevelIdx]}");
            return this._levels[this._levelIdxs[this._currentLevelIdx++]];
        }
    }

  void _setGameOver(String text) {
    this._gameOverText = text;
    this._gameOver = true;

    this._ui.showView(
        new GameOverScreen(this.ui, text),
        callback: (var _) => this.run());
  }

  void onWindowOpen(UI ui) {

  }
  void onWindowClose(UI ui) {

    if (this._tmpInputComponent != null) {
      this._player.setControlComponent(this._tmpInputComponent);
    }
    if (this._player.level != null) {
      this._player.level.unPause();
    }
  }

  void onTimeOut(GameTimer t) {
      this._setGameOver("Darn... you're out of time... party's over... for you!  "
                              "Better luck next time.");
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

    }
  }
}
