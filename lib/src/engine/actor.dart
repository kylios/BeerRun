part of engine;

typedef void HandlerFunc(GameMessage, Actor sender);

class HandlerNotDefinedError extends _MessageError {
    HandlerNotDefinedError(String type) :
        super("No handlers defined for type '$type'");
}

class GameMessageContext {
    final GameMessage message;
    final Actor sender;
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

abstract class Actor {

    Map<String, HandlerFunc> _handlers = new Map<String, HandlerFunc>();

    StreamController<GameMessageContext> _mailboxController =
            new StreamController<GameMessageContext>();
    Stream<GameMessageContext> get _mailbox => this._mailboxController.stream;

    final ActorId actorId;

    Actor(this.actorId) {
        this._mailbox.listen(this._onMessageReceived);
    }

    Future<Actor> startUp() {
        return this._onStartUp()
                .then((_) => new Future.value(this));
    }

    Future<Actor> shutDown() {
        return this._onShutDown()
                .then((_) => this._mailboxController.close())
                .then((_) => new Future.value(this));
    }

    void sendMessage(Actor receiver, GameMessage message) {

        final GameMessageContext context =
                new GameMessageContext(message, this);

        receiver._mailboxController.add(context);
    }

    void registerMessageHandler(String type, HandlerFunc fn) {

        this._handlers[type] = fn;
    }

    void _onMessageReceived(GameMessageContext context) {

        final GameMessage message = context.message;
        final Actor sender = context.sender;

        try {
            if (this._handlers[message.type] != null) {
                this._handlers[message.type] (message);
            } else {
                throw new HandlerNotDefinedError(message.type);
            }
        } on Exception catch(e) {
            sendMessage(sender, new ExceptionMessage(e));
        } on HandlerNotDefinedError catch(e) {
            sendMessage(sender, new UnhandledMessageError.withError(e));
        }
    }



    // Implement these methods
    Future _onStartUp();
    Future _onShutDown();


}

abstract class ParentActor extends Actor implements ActorManager {

    ParentActor(ActorId actorId) :
        super(actorId);


}