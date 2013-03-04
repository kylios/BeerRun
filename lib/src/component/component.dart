part of component;

abstract class Component {

  Component();

  void update(GameObject obj);

  void broadcast(GameEvent e, Collection<ComponentListener> listeners) {
    for (ComponentListener l in listeners) {
      new Timer(0, (var _) => l.listen(e));
    }
  }
}


