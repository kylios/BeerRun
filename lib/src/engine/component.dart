part of engine;

abstract class Component<T extends Entity> {

    void init(T entity);
    void unload(T entity);


}