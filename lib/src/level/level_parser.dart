part of level;


/**
 *
 */
class _LevelParseException {
  String _message;
  _LevelParseException([this._message = ""]);
  String toString() => this._message;
}

/**
 *
 */
class _LevelTileset {

  final int firstgid;
  final String image;
  final int imageheight;
  final int imagewidth;
  final String name;
  final int tilewidth;
  final int tileheight;

  SpriteSheet _sprites;

  _LevelTileset(this.firstgid, this.image, this.imageheight, this.imagewidth,
      this.name, this.tilewidth, this.tileheight) {
    this._sprites =
        new SpriteSheet(
            this.image.replaceAll('../../', ''),
            this.tilewidth, this.tileheight);
  }

  Sprite tile(int gid) {

    if (gid < this.firstgid) {
      return null;
    }

    int rows = this.imageheight ~/ this.tileheight;
    int cols = this.imagewidth ~/ this.tilewidth;

    int diff = gid - this.firstgid;
    int r = diff ~/ cols;
    int c = (r == 0 ? diff : diff % (r * cols));

    int x = c * this.tilewidth;
    int y = r * this.tileheight;

    return this._sprites.spriteAt(x, y);
  }

  factory _LevelTileset.fromJson(Map json) {

    if (null == json['firstgid']) {
      throw new _LevelParseException('"firstgid" is null');
    } else if (null == json['image']) {
      throw new _LevelParseException('"image" is null');
    } else if (null == json['imageheight']) {
      throw new _LevelParseException('"imageheight" is null');
    } else if (null == json['imagewidth']) {
      throw new _LevelParseException('"imagewidth" is null');
    } else if (null == json['name']) {
      throw new _LevelParseException('"name" is null');
    } else if (null == json['tilewidth']) {
      throw new _LevelParseException('"tilewidth" is null');
    } else if (null == json['tileheight']) {
      throw new _LevelParseException('"tileheight" is null');
    }

    _LevelTileset s = new _LevelTileset(
      json['firstgid'],
      json['image'],
      json['imageheight'],
      json['imagewidth'],
      json['name'],
      json['tilewidth'],
      json['tileheight']
    );

    return s;
  }
}

/**
 *
 */
class _LevelLayer {

  final String name;
  final String type;
  final int opacity;
  final bool visible;
  final List<int> data;
  final int height;
  final int width;
  final int x;
  final int y;
  final bool blocking;

  _LevelLayer(this.name, this.type, this.opacity, this.visible,
      this.height, this.width, this.x, this.y, this.blocking, this.data);

  factory _LevelLayer.fromJson(Map json) {

    if (null == json['name']) {
      throw new _LevelParseException('"name" is null');
    } else if (null == json['type']) {
      throw new _LevelParseException('"type" is null');
    } else if (null == json['opacity']) {
      throw new _LevelParseException('"opacity" is null');
    } else if (null == json['visible']) {
      throw new _LevelParseException('"visible" is null');
    } else if (null == json['data']) {
      throw new _LevelParseException('"data" is null');
    } else if (null == json['height']) {
      throw new _LevelParseException('"height" is null');
    } else if (null == json['width']) {
      throw new _LevelParseException('"width" is null');
    } else if (null == json['x']) {
      throw new _LevelParseException('"x" is null');
    } else if (null == json['y']) {
      throw new _LevelParseException('"y" is null');
    } else if (null == json['properties']) {
      throw new _LevelParseException('"properties" is null');
    } else if (null == json['properties']['blocking']) {
      throw new _LevelParseException('"blocking" is null');
    }

    _LevelLayer s = new _LevelLayer(
      json['name'],
      json['type'],
      json['opacity'],
      json['visible'],
      json['height'],
      json['width'],
      json['x'],
      json['y'],
      (json['properties']['blocking'] == "true"),
      json['data']
    );

    return s;
  }
}

class _LayerRegion {

  final String name;
  final int x;
  final int y;
  final int width;
  final int height;

  _LayerRegion(this.name, this.x, this.y, this.width, this.height);

  factory _LayerRegion.fromJson(Map json) {

    if (null == json['name']) {
      throw new _LevelParseException('"name" is null');
    } else if (null == json['x']) {
      throw new _LevelParseException('"x" is null');
    } else if (null == json['y']) {
      throw new _LevelParseException('"y" is null');
    } else if (null == json['width']) {
      throw new _LevelParseException('"width" is null');
    } else if (null == json['height']) {
      throw new _LevelParseException('"height" is null');
    }

    return new _LayerRegion(json["name"], json["x"], json["y"],
        json["width"], json["height"]);
  }
}

class _LayerNPC {

  final String name;
  final int x;
  final int y;
  final int width;
  final int height;
  final int speed;
  final String direction;
  final String region;

  _LayerNPC(this.name, this.x, this.y, this.width, this.height,
      this.speed, this.direction, this.region);

  factory _LayerNPC.fromJson(Map json) {

    if (null == json['name']) {
      throw new _LevelParseException('"name" is null');
    } else if (null == json['x']) {
      throw new _LevelParseException('"x" is null');
    } else if (null == json['y']) {
      throw new _LevelParseException('"y" is null');
    } else if (null == json['width']) {
      throw new _LevelParseException('"width" is null');
    } else if (null == json['height']) {
      throw new _LevelParseException('"height" is null');
    } else if (null == json['properties']) {
      throw new _LevelParseException('"properties" is null');
    } else if (null == json['properties']['speed']) {
      throw new _LevelParseException('"speed" is null');
    } else if (null == json['properties']['direction']) {
      throw new _LevelParseException('"direction" is null');
    } else if (null == json['properties']['region']) {
      throw new _LevelParseException('"region" is null');
    }

    return new _LayerNPC(json["name"], json["x"], json["y"],
        json["width"], json["height"],
        int.parse(json["properties"]["speed"]), json["properties"]["direction"],
        json["properties"]["region"]);
  }
}

class _TilesetIndex {

  Map<int, _LevelTileset> _tilesets;

  _TilesetIndex(List<_LevelTileset> ts) {

    this._tilesets = new Map<int, _LevelTileset>();

    for (_LevelTileset t in ts) {
      this._tilesets[t.firstgid] = t;
    }
  }

  _LevelTileset tilesetByTileGID(int gid) {

    assert(gid > 0);

    _LevelTileset t;

    List<int> gids = this._tilesets
        .keys
        .toList(growable: false);
    gids.sort((int a, int b) => b - a);

    for (int g in gids) {
      if (gid >= g) {
        t = this._tilesets[g];
        break;
      }
    }

    if (t == null) {
      window.console.log("T is null: $gid, $gids");
    }

    return t;
  }

  Sprite tileByTileGID(int gid) => this.tilesetByTileGID(gid).tile(gid);
}

class _LoadableLevel extends Level {

  _LoadableLevel(CanvasDrawer drawer, CanvasManager manager,
      int rows, int cols, int tileWidth, int tileHeight) :
        super(drawer, manager, rows, cols, tileWidth, tileHeight);

  void setupTutorial(UI ui, Player p) {


    this.tutorial.onFinish((var _) {

      p.setPos(this.startX, this.startY);
    });
  }
}