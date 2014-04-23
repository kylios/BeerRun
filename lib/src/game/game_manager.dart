part of game;

class GameManager implements GameTimerListener, KeyboardListener, UIListener,
    GameEventListener {

    int _tickNo = 0;

    StatsManager _statsManager;
    CanvasManager _canvasManager;
    CanvasDrawer _canvasDrawer;
    AudioManager _audio;
    CdnLoader _cdnLoader;
    GameConfig _config;
    PageStats _pageStats;
    LoadingScreen _loadingScreen;

    AudioControl _musicToggle;
    AudioControl _sfxToggle;

    InputElement _musicOnElement;
    InputElement _musicOffElement;
    InputElement _sfxOnElement;
    InputElement _sfxOffElement;

    Song _theme;

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
        DivElement configElement,
        InputElement musicOnElement,
        InputElement musicOffElement,
        InputElement sfxOnElement,
        InputElement sfxOffElement}) {

        if (GameManager._instance == null) {
            GameManager._instance = new GameManager._internal(
                canvasWidth, canvasHeight,
                canvasElement,
                UIRootElement, NotificationsRootElement,
                DialogElement, statsElement, debugStatsElement,
                configElement,
                musicOnElement, musicOffElement,
                sfxOnElement, sfxOffElement);
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
            DivElement configElement,
            this._musicOnElement,
            this._musicOffElement,
            this._sfxOnElement,
            this._sfxOffElement) {

        this._statsManager = new StatsManager(statsElement);

        this._pageStats = new PageStats(debugStatsElement);

        Map configData = JSON.decode(configElement.innerHtml);
        this._config = new GameConfig(configData);

        this._canvasManager = new CanvasManager(canvasElement);
        this._canvasManager.resize(this._canvasWidth, this._canvasHeight);

        this._canvasDrawer = new CanvasDrawer(this._canvasManager);
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

        this._loadingScreen = new LoadingScreen(this._ui);

        this._parseConfig();
    }

    UIInterface get ui => this._ui;


    void _parseConfig() {

        GameConfig config = this._config;

        Map<String, dynamic> cfg = config.get();
        List<String> cdnHosts = cfg['application']['assets']['cdn_hosts'];
        int version = cfg['application']['assets']['version'];

        this._cdnLoader = new CdnLoader(cdnHosts, version);
        this._cdnLoader.loadQueueResizeStream.listen(
            this._loadingScreen.onLoadQueueResize);
        this._cdnLoader.loadQueueProgressStream.listen(
            this._loadingScreen.onLoadQueueProgress);
    }

    Future init() {

        this._startPageStats();

        this._ui.showView(this._loadingScreen);

        return this._cdnLoader.loadManifest()
            .then(this._loadLevels)
            .then(this._loadAudio);
    }

    void _startPageStats() {

        this._pageStats.startMovingAverage('fps');
        this._pageStats.startTimer("game_manager_init");
    }

    void _stopPageStats() {
        this._pageStats.stopTimer("game_manager_init");
    }

    Future _loadLevels(var _) {

        Map levelConfig = this._cdnLoader.getAsset('level_config');
        List<Future> futures = new List<Future>();

        return Future.forEach(levelConfig['levels'], (Map levelConfigData) => new Future(() {

                String id = levelConfigData['id'];
                String name = levelConfigData['name'];
                Map levelData = this._cdnLoader.getAsset(id);
                this._levelIdxs.add(name);
                Level l = new Level.fromJson(levelData,
                    this._canvasDrawer, this._canvasManager,
                    this._player);
                this._levels[name] = l;

            }));
    }

    void _loadAudio(var _) {
        this._audio = new AudioManager.fromConfig(this._cdnLoader, this._cdnLoader.getAsset('sfx_config'));
    }
/*
    Future _loadLevels(GameLoaderStep step, String levelConfigPath) {
        return this._cdnLoader.load(levelConfigPath).then((Map config) {
            config['levels'].forEach((Map levelConfig) {
                this._levelIdxs.add(levelConfig['name']);
                GameLoaderJob loadLevel = new GameLoaderJob("Loading level ${levelConfig['name']}", this._loadLevel, levelConfig);
                step.addJob(loadLevel);
            });
        });
    }

    Future _loadLevel(GameLoaderStep step, Map levelConfig) {

        return this._cdnLoader.load(levelConfig['path']).then((Map levelData) {
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
*/

/*
  Future _setupAudio(GameLoaderStep step, var _) {

    Completer c = new Completer();

    this._audio.loadAndDecode().then((var _) {
      this._theme = this._audio.getSong('theme');

      Song drinkBeer = this._audio.getSong('drink_beer');
      this._player.drinkBeerSfx = drinkBeer;

      this._musicOnElement.onClick.listen((Event e) {
        this._audio.getTrack('music').state = on;
        this._theme.loop();
      });
      this._musicOffElement.onClick.listen((Event e) => this._audio.getTrack('music').state = off);

      this._sfxOnElement.onClick.listen((Event e) => this._audio.getTrack('sfx').state = on);
      this._sfxOffElement.onClick.listen((Event e) => this._audio.getTrack('sfx').state = off);

      this._musicOffElement.click();
      this._sfxOnElement.click();

      c.complete();
    });
    return c.future;
  }
*/

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
            this._setGameOver("You're too sober.  You got bored and go home.");
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
