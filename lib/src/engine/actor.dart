part of engine;

class ActorId implements Function {
    final String _actorId;
    ActorId(this._actorId);
    call() => this._actorId;
    String toString() => this._actorId;
    operator ==(ActorId other) => this._actorId == other._actorId;
    int get hashCode => this._actorId.hashCode;
}

abstract class ThinActor {

    ThinActor();
}

abstract class Actor extends ThinActor with Messager {

    ActorId actorId;

    /**
     * Sets up the actor's internals.  Since Actor is intended to be a mixin, it
     * cannot declare a constructor to initialize its private members.  This
     * method MUST be called by any subclass in its constructor.
     */
    Actor createActor(ActorId actorId, Messager manager) {
        this.actorId = actorId;
        this.createMessager(manager);
        return this;
    }

    /*
    Actor(this.actorId) {
        this._mailbox.listen(this._onMessageReceived);
    }
    */

    Future<Actor> startUp() {
        print("$this starting up...");

        if (this.onStartUp == null) {
            return new Future.value(this);
        }
        Future f = this.onStartUp();
        if (f == null) {
            f = new Future.delayed(new Duration());
        }
        return f.then((_) => this.onStartUpMessager())
                .then((_) => new Future<Actor>.value(this));
    }

    Future<Actor> shutDown() {
        print("$this shutting down...");
        return this.onShutDown()
                .then((_) => this.onShutDownMessager())
                .then((_) => new Future<Actor>.value(this));
    }



    String toString() {
        return this.actorId.toString();
    }



    // Implement these methods
    Future onStartUp();
    Future onShutDown();


}
