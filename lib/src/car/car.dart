part of car;

class Car extends PathFollower {

    int _type;


    final SpriteSheet _horiz;
    final SpriteSheet _vert;

    Car(GamePath p, Direction d, this._type, this._vert, this._horiz) : super(d,
            p.start.x, p.start.y) {
        this.speed = 6;
        this.setControlComponent(new PathFollowerInputComponent(p));
    }

    void update() {
        super.update();

        GameObject obj = this.level.collidesWithPlayer(this);
        if (obj != null) {
            GameEvent e = new GameEvent(GameEvent.TAKE_HIT_EVENT, 1);
            Timer.run(() => obj.listen(e));
        }
    }

    void takeHit() {}

    GamePoint get point => new GamePoint(this.x, this.y);

    int get tileWidth {
        if (this.dir == DIR_UP || this.dir == DIR_DOWN) {
            return 64;
        } else {
            return 106;
        }
    }

    int get tileHeight {
        if (this.dir == DIR_UP || this.dir == DIR_DOWN) {
            return 106;
        } else {
            return 64;
        }
    }

    Sprite getMoveSprite() {
        int t = this._type;
        if (this.dir == DIR_UP) {
            return this._vert.spriteAtNew(0, t * 2 + 1);
        } else if (this.dir == DIR_RIGHT) {
            return this._horiz.spriteAtNew(t, 1);
        } else if (this.dir == DIR_DOWN) {
            return this._vert.spriteAtNew(0, t * 2);
        } else { // if (this.dir == DIR_LEFT) {
            return this._horiz.spriteAtNew(t, 0);
        }
    }
    Sprite getStaticSprite() {
        return this.getMoveSprite();
    }

    void listen(GameEvent e) {}
}
