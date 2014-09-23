part of car;

class CarFactory extends GameObject {

    final SpriteSheet vert;
    final SpriteSheet horiz;

    final Level level;

    final int tileWidth = 0;
    final int tileHeight = 0;

    Sprite getStaticSprite() => null;
    Sprite getMoveSprite() => null;

    CarGeneratorComponent _generator;

    CarFactory(this.level, this.vert, this.horiz) : super(DIR_DOWN, 0, 0);

    void setGenerator(CarGeneratorComponent c) {
        this._generator = c;
    }

    void update() {
        super.update();
        this._generator.update(this);
    }

    void listen(GameEvent e) {}
}
