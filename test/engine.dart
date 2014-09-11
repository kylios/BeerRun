library engine;

import 'dart:async';

import 'package:unittest/unittest.dart';

part 'src/engine/test_actor.dart';

part '../lib/src/engine/actor.dart';
part '../lib/src/engine/actor_system.dart';
part '../lib/src/engine/game_message.dart';


main() {

    group("Actor System Test", () {
        test("Basic ActorSystem functionality", () {

            ActorSystem system = new ActorSystem();

            Actor a1 = new TestActor(new ActorId("test/actor1"));
            Actor a2 = new TestActor(new ActorId("test/actor2"));

            return system.spawnActor(a1)
                .then((Actor a) {
                    print("spawned actor a1");
                    expect(a, a1, reason: "The actor returned by the future did not equal the spawned actor");
                })
                .then((_) => system.spawnActor(a2))
                .then((Actor a) {
                    print("spawned actor a2");
                    expect(a, a2, reason: "The actor returned by the future did not equal the spawned actor");
                })
                .then((_) => system.getActor(new ActorId("test/actor1")))
                .then((Actor a) {
                    print("checking actor a1");
                    expect(a, a1, reason: "The actor returned did not match the actor spawned with the same actor Id");
                })
                .then((_) => system.getActor(new ActorId("test/actor2")))
                .then((Actor a) {
                    print("checking actor a2");
                    expect(a, a2, reason: "The actor returned did not match the actor spawned with the same actor Id");
                })
                .then((_) => system.killActor(new ActorId("test/actor1")))
                .then((_) => print("removing actor a1"))
                .then((_) => system.getActor(new ActorId("test/actor1")))
                .then((Actor a) {
                    expect(a, null, reason: "An actor was returned, even though the actor was killed");
                })
                .then((_) => system.killActor(new ActorId("test/actor2")))
                .then((_) => print("removing actor a2"))
                .then((_) => system.getActor(new ActorId("test/actor2")))
                .then((Actor a) {
                    expect(a, null, reason: "An actor was returned, even though the actor was killed");
                })
                ;
        });
    });

    group("Message Passing Test", () {

        setUp(() {

        });

        tearDown(() {

        });
    });
}
