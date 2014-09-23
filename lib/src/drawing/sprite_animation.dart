part of drawing;

class SpriteAnimation {

    List<Sprite> _sprites;
    int _cur;
    bool _loop = true;

    SpriteAnimation(this._sprites, [this._loop]) {
        this._cur = 0;
    }

    Sprite getNext() {
        if (this._cur >= this._sprites.length) {
            if (this._loop == false) {
                return null;
            } else {
                this._cur = 0;
            }
        }
        return this._sprites[this._cur++];
    }

    Sprite getCur() {
        if (this._cur < this._sprites.length) {
            return this._sprites[this._cur];
        } else {
            return null;
        }
    }

    void reset() {
        this._cur = 0;
    }

    bool isDone() {
        return this._loop == false && this._cur >= this._sprites.length;
    }
}
