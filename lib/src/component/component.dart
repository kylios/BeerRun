part of component;

abstract class Component {

  Component();

  void update(GameObject obj);

  void broadcast(GameEvent e, Collection<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      Timer.run(() => l.listen(e));
    }
  }
}


