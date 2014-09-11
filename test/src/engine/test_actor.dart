part of engine;

class TestActor extends Actor {

    TestActor(ActorId actorId) : super(actorId);

    Future _onStartUp() {
        return new Future.value(null);
    }

    Future _onShutDown() {
        return new Future.value(null);
    }

}