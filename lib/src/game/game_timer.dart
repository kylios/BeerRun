part of game;

class GameTimer {

  Duration _duration;
  DateTime _end;
  List<GameTimerListener> _listeners = new List<GameTimerListener>();
  Timer _timer = null;

  GameTimer(this._duration);

  void startCountdown() {
    if (this._timer != null) {
      this._timer.cancel();
    }

    this._end = (new DateTime.now().add(this._duration));
    this._timer = new Timer(this._duration, () {
      this._onEnd();
    });
  }

  Duration getRemainingTime() {
    return this._end.difference(new DateTime.now());
  }

  void _onEnd() {
    for (GameTimerListener l in this._listeners) {
      l.onTimeOut();
    }
  }

  void addListener(GameTimerListener l) {
    this._listeners.add(l);
  }

  String getRemainingTimeFormat() {

    Duration d = this.getRemainingTime();

    int minutes = d.inMinutes;
    int seconds = d.inSeconds % 60;

    return "${minutes}:${seconds}";
  }
}