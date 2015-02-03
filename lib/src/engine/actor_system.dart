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

    final Map<ActorId, Actor> _actors = new Map<ActorId, Actor>();

    Future<Actor> spawnActor(Actor actor) {

        if (this._actors[actor.actorId] != null) {
            throw new ActorIdInUseError(actor.actorId);
        }

        actor._sys = this;
        return actor.startUp().then((Actor actor) {
            this._actors[actor.actorId] = actor;
            return new Future.value(actor);
        });
    }

    Future killActor(ActorId actorId) {
        Actor a = this._actors[actorId];
        this._actors.remove(actorId);
        return a.shutDown();
    }

    Future<Actor> getActor(ActorId actorId) {
        return new Future.value(this._actors[actorId]);
    }


    Future onStartUp();
    Future onShutDown();


}

class ActorSystem extends ActorManager with Messager {

    int _CURRENT_ID = 1;

    ActorSystem() {
        this.createMessager(this);
        this.createActor(new ActorId("engine/${_CURRENT_ID++}"));
    }

    Messager get manager => this;

    Future onStartUp() {
        this.registerMessageHandler(KillMe.TYPE_STRING, (KillMe message, Actor sender) {
            this.killActor(message.who.actorId);
        });
        return new Future.value();
    }

    Future onShutDown() => new Future.value();
}
