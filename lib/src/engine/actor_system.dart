part of engine;

class ActorIdInUseError extends Error {
    final ActorId actorId;
    ActorIdInUseError(this.actorId);
}

class ActorNotFoundError extends Error {
    final ActorId actorId;
    ActorNotFoundError(this.actorId);
}

abstract class ActorManager {

    Future<Actor> spawnActor(Actor actor);
    Future killActor(ActorId actorId);
    Future<Actor> getActor(ActorId actorId);
}

abstract class MessageReceiver {
    void sendMessage(MessageReceiver receiver, GameMessage message);
    StreamController<GameMessageContext> get _mailboxController;
}

class ActorSystem extends Actor implements ActorManager {

    static int _CURRENT_ID = 1;

    final Map<ActorId, Actor> _actors = new Map<ActorId, Actor>();

    ActorSystem() : super(new ActorId("engine/${_CURRENT_ID++}"));

    Future<Actor> spawnActor(Actor actor) {

        if (this._actors[actor.actorId] != null) {
            throw new ActorIdInUseError(actor.actorId);
        }

        return actor.startUp().then((Actor actor) {
            this._actors[actor.actorId] = actor;
            return new Future.value(actor);
        });
    }

    Future killActor(ActorId actorId) {
        this._actors.remove(actorId);
        return new Future.delayed(new Duration());
    }

    Future<Actor> getActor(ActorId actorId) {
        return new Future.value(this._actors[actorId]);
    }


    Future onStartUp() => null;
    Future onShutDown() => null;


}