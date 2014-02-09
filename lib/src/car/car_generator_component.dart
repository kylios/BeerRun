part of car;

class CarGeneratorComponent extends Component {

  Random _rng = new Random();

  Level _level;
  GamePath _path;

  int _spawnCount = 0;
  int _spawnAt;

  CarGeneratorComponent(this._path, this._spawnAt);

  void update(CarFactory factory) {

    this._spawnCount++;
    if (this._spawnCount >= this._spawnAt) {

      int blah = this._rng.nextInt(2);
      Car c = new Car(this._path, DIR_UP, blah, factory.vert, factory.horiz);
      c.setLevel(factory.level);
      c.setDrawingComponent(
          new DrawingComponent(
              factory.level.canvasManager,
              factory.level.canvasDrawer, false));
      factory.level.addObject(c);
      // Sorta randomize the interval that we spawn cars
      this._spawnCount = this._rng.nextInt(this._spawnAt ~/ 2);
    }
  }
}