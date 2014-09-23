part of game;

class Broadcaster {

    void broadcast(GameEvent e, List<GameEventListener> listeners) {
        for (GameEventListener l in listeners) {
            Timer.run(() => l.listen(e));
        }
    }
}
