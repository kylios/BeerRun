part of game;

class GameNotification extends GameEvent {

  GameNotification(String message, {int seconds: 5}) {
    this.data['message'] = message;
    this.data['seconds'] = seconds;
    this.type = GameEvent.NOTIFICATION_EVENT;
  }
}
