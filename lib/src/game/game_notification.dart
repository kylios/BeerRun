part of game;

class GameNotification extends GameEvent {

  GameNotification(String message, {int seconds: 5, String imgUrl: null}) {
    this.data['message'] = message;
    this.data['seconds'] = seconds;
    this.data['img_url'] = imgUrl;
    this.type = GameEvent.NOTIFICATION_EVENT;
  }
}
