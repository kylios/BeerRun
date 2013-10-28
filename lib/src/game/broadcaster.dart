part of game;

class Broadcaster {

  void broadcast(GameEvent e, List<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      Timer.run(() => l.listen(e));
    }
  }
}