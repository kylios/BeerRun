part of level;


abstract class Level implements ComponentListener {

  String _name;

  // Level design parameters
  int _rows;
  int _cols;

  int _tileWidth;
  int _tileHeight;          //

  int _storeX;
  int _storeY;
  int _startX;
  int _startY;
  int _beersToWin;
  Duration _duration; // how long you have to beat this level

  List<bool> _blocked;      // blocked tiles
  List<Trigger> _triggers;  // triggered tiles

  TutorialManager _tutorial;

  // Level functionality members
  int _layer = -1;

  CanvasManager _manager;
  DrawingInterface _drawer;

  List<Animation> _animations;
  List<List<Sprite>> _sprites;
  List<GameObject> _objects;
  List<CarFactory> _carFactories;
  Player _player;

  bool _paused = false;

  Level(this._drawer, this._manager,
      this._rows, this._cols, this._tileWidth, this._tileHeight)
  {
    this._sprites = new List<List<Sprite>>();
    this._objects = new List<GameObject>();
    this._animations = new List<Animation>();
    this._carFactories = new List<CarFactory>();
    this._triggers = new List<Trigger>(); // TODO: someday optimize this to be more location aware
    this._blocked = new List<bool>
      .filled(this._rows * this._cols, false);
    this._tutorial = new TutorialManager();
  }

  // Abstract methods
  int get storeX => this._storeX;
  int get storeY => this._storeY;
  int get startX => this._startX;
  int get startY => this._startY;
  int get beersToWin => this._beersToWin;
  Duration get duration => this._duration;

  int get tileWidth => this._tileWidth;
  int get tileHeight => this._tileHeight;
  int get rows => this._rows;
  int get cols => this._cols;
  String get name => this._name;
  CanvasManager get canvasManager => this._manager;
  CanvasDrawer get canvasDrawer => this._drawer;
  List<GameObject> get objects => this._objects;
  TutorialManager get tutorial => this._tutorial;

  int _posToIdx(int row, int col) {
    return this._cols * row + col;
  }

  void newLayer() {
    this._sprites.add(new List<Sprite>(this._rows * this._cols));
    this._layer++;
  }

  void pause() {
    this._paused = true;
  }
  void unPause() {
    this._paused = false;
  }
  bool isPaused() {
    return this._paused;
  }

  void setSpriteAt(Sprite s, int row, int col, [bool blocked]) {

    int pos = this._posToIdx(row, col);
    if (this._layer == -1 ||
        pos < 0 ||
        pos >= this._sprites[this._layer].length)
    {
      return;
    }

    if (?blocked) {
      this._blocked[pos] = blocked;
    }
    this._sprites[this._layer][pos] = s;
  }
  Sprite getSpriteAt(int row, int col) {

    int pos = this._posToIdx(row, col);
    if (this._layer == -1 ||
        pos < 0 ||
        pos >= this._sprites[this._layer].length)
    {
      return null;
    }

    return this._sprites[this._layer][pos];
  }

  void addPlayerObject(Player p) {
    this._player = p;
    this._player.setPos(this.startX, this.startY);
    this.addObject(p);
  }

  void addAnimation(Animation a) {
    this._animations.add(a);
  }

  void addTrigger(Trigger t) {
    this._triggers.add(t);
  }

  void addCarFactory(CarFactory f) {
    this._carFactories.add(f);
  }

  void addObject(GameObject obj) {
    this._objects.add(obj);
  }

  void removeObject(GameObject obj) {
    this._objects.remove(obj);
  }

  bool isOffscreen(GameObject obj) {
    return (obj.x < 0 || obj.x > this._cols * this._tileWidth ||
        obj.y < 0 || obj.y > this._rows * this._tileHeight);
  }

  void takeHit() {}

  bool isBlocking(int row, int col) {
    //return false;
    int pos = this._posToIdx(row, col);
    if (this._layer == -1 ||
        pos < 0 ||
        row >= this._rows ||
        col >= this._cols ||
        pos >= this._blocked.length)
    {
      // Keep us on the screen
      return true;
    }
    return this._blocked[pos];
  }

  List<GameObject> checkCollision(GameObject obj) {
    List<GameObject> targets = null;
    for (GameObject o in this._objects) {
      if (o != obj &&
          (
              (
                  o.x + o.tileWidth >= obj.x &&
                  o.x <= obj.x + obj.tileWidth
              )
              &&
              (
                  o.y + o.tileHeight >= obj.y &&
                  o.y <= obj.y + obj.tileHeight
              )
          )
      )
      {
        if (targets == null) {
          targets = new List<GameObject>();
        }
        targets.add(o);
      }
    }
    return targets;
  }

  GameObject collidesWithPlayer(GameObject obj) {

    GameObject o = this._player;
    if (o != obj &&
      (
          (
            o.x + o.collisionXOffset+ o.collisionWidth >= obj.x &&
            o.x + o.collisionXOffset <= obj.x + obj.tileWidth
          )
          &&
          (
            o.y + o.collisionYOffset + o.collisionHeight >= obj.y &&
            o.y + o.collisionYOffset <= obj.y + obj.tileHeight
          )
        )
      )
    {
      return o;
    } else {
      return null;
    }
  }

  void listen(GameEvent e) {
    if (e.type == GameEvent.CREATE_BULLET_EVENT) {
      Direction d = e.data["direction"];
      GameObject creator = e.creator;
      int x = e.data["x"];
      int y = e.data["y"];

      Bullet b = new Bullet(this, creator, d, x, y,
          new BulletInputComponent(),
          new DrawingComponent(this._manager, this._drawer, false));
      // TODO: this messes up everything.  Can we queue this somehow?  Maybe
      // queue the GameEvent before it gets to the level even.  The GameEvents
      // should not be processed during any GameObject's update loop.
      //this.addObject(b);
    }
  }

  void update() {

    // Eventually, it would be cool if drawing could be moved out of the
    // main update loop.  How we do it, I'm not positive, but I'm thinking we
    // could just call window.requestDrawFrame or whatever and pass in the main
    // draw() function, and have update() called in an interval where we
    // regulate the speed with an updatesPerSecond counter.  This would allow
    // us to better control start/stops of the update loop too, and make it
    // easier to pass in different update() functions for different modes of
    // the game.
    // TODO: for now I'm just moving player.draw() out of here, and that'll
    //    have to be called explicitly from the game's loop.
    this.draw(this._drawer);

    if ( ! this._paused) {
      //this._player.update();
      // TODO: don't draw here!  Draw in game.update().
      //this._player.draw();

      // Check if the player is standing on a trigger
      for (Trigger t in this._triggers) {
        int x = t.col * this._tileWidth;
        int y = t.row * this._tileHeight;
        GameObject o = this._player;
        if (
            (
                o.x + o.collisionXOffset + o.collisionWidth >= x &&
                o.x + o.collisionXOffset <= x + this.tileWidth
            )
            &&
            (
                o.y + o.collisionYOffset + o.collisionHeight >= y &&
                o.y + o.collisionYOffset <= y + this.tileHeight
            )
          ) {
            GameEvent e = t.event;
            Timer.run(() => o.listen(e));
        }
      }

      // Loop through the objects, calling update on each.  Remove them from the
      // list if they become removed from the level.
      List<GameObject> newObjects = new List<GameObject>.from(this._objects.where((GameObject o)
      {
        if ( ! this._paused) {
          o.update();
        }

        // TODO: fuuuuuuuuuck this is so terrible
        if (o != this._player) {
          o.draw();
        }
        return ! o.isRemoved;
      }));
      this._objects = newObjects;

      for (CarFactory f in this._carFactories) {
        f.update();
      }

      // Process any animations going on
      this._animations = new List<Animation>.from(
          this._animations.where((Animation a) {
            a.drawNext(this._drawer);
            return ! a.isDone;
          })
      );
    }
  }

  // The main draw function.  Please see above for some rationale for moving
  // this out of the update() function.
  void draw(CanvasDrawer d) {

    for (List<Sprite> layer in this._sprites) {

      int row = 0;
      int col = 0;
      for (Sprite s in layer) {
        if (s != null) {
          d.drawSprite(s, col * this._tileWidth, row * this._tileHeight,
              this._tileWidth, this._tileHeight);
        }
        //if (this.isBlocking(row, col)) {
          //d.backgroundColor = "red";
          //d.drawRect(col * this._tileWidth, row * this._tileHeight,
          //    this._tileWidth, this._tileHeight, 0, 0, true);
        //}
        col++;
        if (col >= this._cols) {
          row++;
          col = 0;
        }
      }
    }
  }

  static Map<String, Sprite> parseSpriteSheet(
      SpriteSheet sheet, Map<String, List<int>> data)
  {

    Map<String, Sprite> sprites = new Map<String, Sprite>();

    for (String sName in data.keys) {
      int x = data[sName][0];
      int y = data[sName][1];
      sprites[sName] = sheet.spriteAt(x, y);
    }

    return sprites;
  }

  Sprite getStaticSprite() {}
  Sprite getMoveSprite() {}








  // TODO: temporary until I figure out how to script tutorials
  static void setupTutorial(Level level, UI ui, Player p) {

    level.tutorial.onStart((var _) {
      Completer c = new Completer();
      level.canvasDrawer.setOffset(20 * 32, 0);

      View v = new TutorialDialog(level.tutorial,
          "What.. who's level drunk idiot who wants to come to OUR party? "
          "I suppose you can come in.. BUT, we're running low on beer! "
          "Why don't you stumble on down to the store over there and grab us "
          "some beers!"
      );

      ui.showView(v, callback: c.complete);

      return c.future;
    }).addStep((var _) {

      Completer c = new Completer();

      int tutorialDestX = level.storeX;
      int tutorialDestY = level.storeY;
      Timer _t = new Timer.periodic(new Duration(milliseconds: 20), (Timer t) {

        int offsetX = level.canvasDrawer.offsetX;
        int offsetY = level.canvasDrawer.offsetY;

        if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
          t.cancel();
          c.complete();
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
        level.canvasDrawer.moveOffset(moveX, moveY);

        level.canvasDrawer.clear();
        level.draw(level.canvasDrawer);
      });

      return c.future;
    })
    .addStep((var _) {
      Completer c = new Completer();
      ui.showView(
          new TutorialDialog(level.tutorial,
              "Grab us a ${level.beersToWin} pack and bring it back.  Better "
              "avoid the bums... they like to steal your beer, and then you'll "
              "have to go BACK and get MORE!"),
          callback: c.complete
      );
      return c.future;
    })
    .addStep((var _) {
      window.console.log("continueTutorial2");

      Completer c = new Completer();

      int tutorialDestX = 20 * 32;
      int tutorialDestY = 0;
      Timer _t = new Timer.periodic(new Duration(milliseconds: 5), (Timer t) {

        int offsetX = level.canvasDrawer.offsetX;
        int offsetY = level.canvasDrawer.offsetY;

        window.console.log("$offsetX - $offsetY");
        if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
          t.cancel();
          c.complete();
          return c.future;
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
        level.canvasDrawer.moveOffset(moveX, moveY);

        level.canvasDrawer.clear();
        level.draw(level.canvasDrawer);
      });

      return c.future;
    })
    .addStep((var _) {
      window.console.log("continueTutorial3");
      Completer c = new Completer();

      ui.showView(
          new TutorialDialog(level.tutorial,
              "Well, what are you waiting for!?  Get moving, and don't sober "
              "up too much!"),
          callback: () { c.complete(); }
      );
      return c.future;
    })
    .onFinish((var _) {

      p.setPos(level.startX, level.startY);
    });
  }





  /**
   * Load a level from a file.  Eventually we should move methods like these
   * out into driver classes or something like that, I think, but for now,
   * this'll do to get the logic straight.
   * */
  factory Level.fromJson(Map level, CanvasDrawer drawer, CanvasManager manager)
  {
    int height = level["height"].toInt();
    int width = level["width"].toInt();
    int tileHeight = level["tileheight"].toInt();
    int tileWidth = level["tilewidth"].toInt();

    List<Map> _tilesets = level["tilesets"];
    List<Map> _layers = level["layers"];
    Map _properties = level["properties"];

    Level l = new _LoadableLevel(drawer, manager,
        height, width, tileWidth, tileHeight);
    l._name = _properties["name"];

    List<_LevelTileset> tilesets = new List<_LevelTileset>();
    for (Map tset in _tilesets) {
      tilesets.add(new _LevelTileset.fromJson(tset));
    }

    _TilesetIndex idx = new _TilesetIndex(tilesets);

    Map<String, Region> _regions = new Map<String, Region>();
    Map<String, _LayerPath> _paths = new Map<String, _LayerPath>();
    List<_LayerNPC> _npcs = new List<_LayerNPC>();

    List<_LevelLayer> layers = new List<_LevelLayer>();
    for (Map ll in _layers) {
      if (ll["type"] == "tilelayer") {
        layers.add(new _LevelLayer.fromJson(ll));
      } else {
        // objects
        // TODO: this could be a lot better managed
        for (Map object in ll["objects"]) {
          int x = object["x"];
          int y = object["y"];
          int row = y ~/ tileHeight;
          int col = x ~/ tileWidth;
          int width = object["width"];
          int height = object["height"];
          String type = object["type"];
          if (type == "trigger") {
            if (object["properties"]["type"] == "beer_store") {
              GameEvent beerStoreEvent = new GameEvent();
              beerStoreEvent.type = GameEvent.BEER_STORE_EVENT;
              beerStoreEvent.value = 24;
              l.addTrigger(new Trigger(beerStoreEvent, row, col));
            } else if (object["properties"]["type"] == "party_arrival") {
              GameEvent partyArrivalEvent = new GameEvent();
              partyArrivalEvent.type = GameEvent.PARTY_ARRIVAL_EVENT;
              l.addTrigger(new Trigger(partyArrivalEvent, row, col));
            }
          } else if (type == "region") {
            _LayerRegion r = new _LayerRegion.fromJson(object);
            Region reg = new Region(r.x, r.x + r.width, r.y, r.y + r.height);
            _regions[r.name] = reg;
          } else if (type == "path") {
            _LayerPath p = new _LayerPath.fromJson(object);
            _paths[p.name] = p;
            GamePath path = new GamePath(new List<GamePoint>());
            for (_Point po in p.points) {
              path.addPoint(new GamePoint(po.x, po.y));
            }
            _LevelTileset _tVert = idx.tilesetByName("cars_vert");
            _LevelTileset _tHoriz = idx.tilesetByName("cars_horiz");
            window.console.log("vert tset: ${_tVert}");
            window.console.log("horiz tset: ${_tHoriz}");
            SpriteSheet vert = _tVert.sprites;
            SpriteSheet horiz = _tHoriz.sprites;
            CarFactory f = new CarFactory(l, vert, horiz);
            f.setGenerator(new CarGeneratorComponent(path, p.spawnAt));
            l.addCarFactory(f);
          } else if (type == "npc") {
            _LayerNPC n = new _LayerNPC.fromJson(object);
            _npcs.add(n);
          }
        }
      }
    }

    for (_LayerNPC n in _npcs) {
      Direction dir = (n.direction == "down" ? DIR_DOWN :
                      n.direction == "up" ? DIR_UP :
                        n.direction == "left" ? DIR_LEFT :
                          n.direction == "right" ? DIR_RIGHT :
                            null);
      NPC npc = new NPC(l, dir, n.x, n.y);
      npc.speed = n.speed;
      npc.setDrawingComponent(new DrawingComponent(manager, drawer, false));
      npc.setControlComponent(new NPCInputComponent(_regions[n.region]));
      l.addObject(npc);
    }

    l._storeX = int.parse(_properties["store_x"]);
    l._storeY = int.parse(_properties["store_y"]);
    l._startX = int.parse(_properties["start_x"]);
    l._startY = int.parse(_properties["start_y"]);
    l._beersToWin = int.parse(_properties["beers_to_win"]);
    l._duration = new Duration(seconds: int.parse(_properties["seconds"]));

    // Load the tilesets into the level
    for (_LevelLayer ll in layers) {
      l.newLayer();

      int row = 0;
      int col = 0;
      bool blocking = ll.blocking;
      List<int> data = ll.data;
      for (int gid in data) {

        if (col >= ll.width) {
          col = 0;
          row++;
        }

        if (gid > 0) {
          l.setSpriteAt(idx.tileByTileGID(gid), row, col, blocking);
        }

        col++;
      }
    }

    return l;
  }
}
