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

class ActorSystem implements ActorManager {


    final Map<ActorId, Actor> _actors = new Map<ActorId, Actor>();

    ActorSystem();

    Future<Actor> spawnActor(Actor actor) {

        if (this._actors[actor.actorId] != null) {
            throw new ActorIdInUseError(actor.actorId);
        }

        return
            actor.startUp()
            .then((Actor actor) {
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
}
