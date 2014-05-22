part of tutorial;

class _TutorialControlAction {

    static const _TutorialControlAction NOACTION = const _TutorialControlAction._(0);
    static const _TutorialControlAction UP = const _TutorialControlAction._(1);
    static const _TutorialControlAction DOWN = const _TutorialControlAction._(2);
    static const _TutorialControlAction LEFT = const _TutorialControlAction._(3);
    static const _TutorialControlAction RIGHT = const _TutorialControlAction._(4);

    static get values => [ NOACTION , UP , DOWN , LEFT , RIGHT ];

    final int value;

    const _TutorialControlAction._(this.value);
}

class TutorialControlComponent extends Component {

    _TutorialControlAction _lastAction = null;
    int _lastAmount = 0;

    TutorialControlComponent(Tutorial t) {

    }

    void moveUp([int px = 1]) {
        this._lastAction = _TutorialControlAction.UP;
        this._lastAmount = px;
    }

    void moveDown([int px = 1]) {
        this._lastAction = _TutorialControlAction.DOWN;
        this._lastAmount = px;
    }

    void moveLeft([int px = 1]) {
        this._lastAction = _TutorialControlAction.LEFT;
        this._lastAmount = px;
    }

    void moveRight([int px = 1]) {
        this._lastAction = _TutorialControlAction.RIGHT;
        this._lastAmount = px;
    }

    void update(GameObject obj) {

        switch (this._lastAction) {
            case _TutorialControlAction.NOACTION:
                break;
            case _TutorialControlAction.UP:
                obj.moveUp(this._lastAmount);
                break;
            case _TutorialControlAction.DOWN:
                obj.moveDown(this._lastAmount);
                break;
            case _TutorialControlAction.LEFT:
                obj.moveLeft(this._lastAmount);
                break;
            case _TutorialControlAction.RIGHT:
                obj.moveRight(this._lastAmount);
                break;
        }

        this._lastAction = _TutorialControlAction.NOACTION;
        this._lastAmount = 0;
    }
}