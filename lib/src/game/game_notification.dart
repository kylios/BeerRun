part of game;

class GameNotification extends GameEvent {

  GameNotification(String message, {int seconds: 5, String imgUrl: null}) :
  		super(GameEvent.NOTIFICATION_EVENT) {
    this.data['message'] = message;
    this.data['seconds'] = seconds;
    this.data['img_url'] = imgUrl;
  }
}
