part of game;

class GameTimer {

  DateTime _end = null;
  List<GameTimerListener> _listeners = new List<GameTimerListener>();
  Timer _timer = null;

  GameTimer(this._end);

  void startCountdown() {
    if (this._timer != null) {
      this._timer.cancel();
    }

    Duration d = this.getRemainingTime();
    this._timer = new Timer(d, () {
      this._onEnd();
    });
  }

  Duration getRemainingTime() {
    return new DateTime.now().difference(this._end);
  }

  void _onEnd() {
    for (GameTimerListener l in this._listeners) {
      l.onTimeOut();
    }
  }

  void addListener(GameTimerListener l) {
    this._listeners.add(l);
  }
}