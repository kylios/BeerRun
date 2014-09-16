part of engine;

abstract class Entity extends Actor {

    final List<Component> _components = new List<Component>();

    Entity(ActorId actorId) : super(actorId);

    void addComponent(Component c) {
        c.init(this);
        this._components.add(c);
    }

    void removeComponent(Component c) {
        this._components.remove(c);
        c.unload(this);
    }
}