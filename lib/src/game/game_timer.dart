part of game;

class GameTimer {

  static final Duration ONE_SECOND = new Duration(seconds: 1);

  Duration _duration;
  DateTime _end;
  List<GameTimerListener> _listeners = new List<GameTimerListener>();
  Timer _timer = null;
  Timer _ticker = null;

  GameTimer(this._duration);

  Duration get duration => this._duration;

  void startCountdown() {
    if (this._timer != null) {
      this._timer.cancel();
    }
    if (this._ticker != null) {
      this._ticker.cancel();
    }

    this._end = (new DateTime.now().add(this._duration));
    this._timer = new Timer(this._duration, () {
      this._onEnd();
    });
    this._ticker = new Timer.periodic(GameTimer.ONE_SECOND, (Timer t) {
      for (GameTimerListener l in this._listeners) {
        l.onTick(this);
      }
    });
  }

  void stop([bool invokeCallback = false]) {
    if (this._timer == null) {
      return;
    }
    this._timer.cancel();
    this._ticker.cancel();
    if (invokeCallback) {
      this._onEnd();
    }
  }

  Duration getRemainingTime() {
    if (null == this._end) {
      return null;
    }
    return this._end.difference(new DateTime.now());
  }

  void _onEnd() {
    for (GameTimerListener l in this._listeners) {
      l.onTimeOut(this);
    }
  }

  void addListener(GameTimerListener l) {
    this._listeners.add(l);
  }

  String getRemainingTimeFormat() {

    Duration d = this.getRemainingTime();
    if (d == null) {
      return '';
    }

    int minutes = d.inMinutes;
    int seconds = d.inSeconds % 60;

    String format = "${minutes}:";
    if (seconds < 10) {
      format = "${format}0${seconds}";
    } else {
      format = "${format}${seconds}";
    }

    return format;
  }
}