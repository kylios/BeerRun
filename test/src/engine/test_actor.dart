part of engine;

class TestMessage extends GameMessage {

    static final String TYPE_STRING = "TEST";

    final String type = TYPE_STRING;

    final String message;

    TestMessage(this.message);
}

class UnhandledMessage extends GameMessage {

    static final String TYPE_STRING = "UNHANDLED";

    final String type = TYPE_STRING;
}

class TestActor extends Actor {

    TestActor(ActorId actorId) : super(actorId);

    Future _onStartUp() {
        return new Future.value(null);
    }

    Future _onShutDown() {
        return new Future.value(null);
    }
}