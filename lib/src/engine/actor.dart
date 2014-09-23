part of engine;

typedef void HandlerFunc(GameMessage message, Actor sender);

class HandlerNotDefinedError extends _MessageError {
    HandlerNotDefinedError(String type) : super(
            "No handlers defined for type '$type'");
}

class KillActor extends GameMessage {
    static final String TYPE_STRING = "KILL_ACTOR";
    String get type => TYPE_STRING;
}

class KillMe extends GameMessage {
    static final String TYPE_STRING = "KILL_ME";
    String get type => TYPE_STRING;
    final Actor who;
    KillMe(this.who);
}

class GameMessageContext {
    final GameMessage message;
    final MessageReceiver sender;
    GameMessageContext(this.message, this.sender);
}

class ActorId implements Function {
    final String _actorId;
    ActorId(this._actorId);
    call() => this._actorId;
    String toString() => this._actorId;
    operator ==(ActorId other) => this._actorId == other._actorId;
    int get hashCode => this._actorId.hashCode;
}

abstract class Actor implements MessageReceiver {

    // TODO: this should be final and initialized in the constructor.  The
    // spawnActor function in ActorSystem should actually initialize the actor,
    // to force the use of ActorSystem.  This really also requires the use of
    // parent actors and the ability to spawn and manage child actors.
    ActorSystem _sys = null;

    Map<String, HandlerFunc> _handlers = new Map<String, HandlerFunc>();

    StreamController<GameMessageContext> _mailboxController =
            new StreamController<GameMessageContext>();
    Stream<GameMessageContext> get _mailbox => this._mailboxController.stream;

    final ActorId actorId;

    Actor(this.actorId) {
        this._mailbox.listen(this._onMessageReceived);
    }

    Future<Actor> startUp() {
        print("$this starting up...");

        if (this.onStartUp == null) {
            return new Future.value(this);
        }
        Future f = this.onStartUp();
        if (f == null) {
            f = new Future.delayed(new Duration());
        }

        this.registerMessageHandler(KillActor.TYPE_STRING,
                (KillActor message, Actor sender) {
                    this.sendMessage(this._sys, new KillMe(this));
                });

        this.registerMessageHandler(UNHANDLED_MESSAGE_ERROR_TYPE,
            (GameMessage message, Actor sender) =>
                    print("$this received $message from $sender"));

        return f.then((_) => new Future.value(this));
    }

    Future<Actor> shutDown() {
        print("$this shutting down...");
        Future f = this.onShutDown();
        if (f == null) {
            f = new Future.delayed(new Duration());
        }

        return f.then((_) => this._mailboxController.close())
                .then((_) => new Future.value(this));
    }

    void sendMessage(MessageReceiver receiver, GameMessage message) {

        final GameMessageContext context = new GameMessageContext(message, this
                );

        print("'$this' sending message to '$receiver': $message");
        receiver._mailboxController.add(context);
    }

    void registerMessageHandler(String type, HandlerFunc fn) {
        this._handlers[type] = fn;
    }

    void removeMessageHandler(String type) {
        this._handlers.remove(type);
    }

    void _onMessageReceived(GameMessageContext context) {

        final GameMessage message = context.message;
        final Actor sender = context.sender;

        print("'$this' received message from '$sender': $message");

        try {
            if (this._handlers[message.type] != null) {
                this._handlers[message.type](message, sender);
            } else {
                throw new HandlerNotDefinedError(message.type);
            }
        } on Exception catch (e) {
            sendMessage(sender, new ExceptionMessage(e));
        } on HandlerNotDefinedError catch (e) {
            sendMessage(sender, new UnhandledMessageError.withError(e));
        }
    }

    String toString() {
        return this.actorId.toString();
    }



    // Implement these methods
    Future onStartUp();
    Future onShutDown();


}

abstract class ParentActor extends Actor implements ActorManager {

    ParentActor(ActorId actorId) : super(actorId);


}
