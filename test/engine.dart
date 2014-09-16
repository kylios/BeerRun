library engine;

import 'dart:async';

import 'package:unittest/unittest.dart';

part 'src/engine/test_actor.dart';
part 'src/engine/test_configuration.dart';


// include the package source to test
// TODO: there's probably a better way to do this.
part '../lib/src/engine/actor.dart';
part '../lib/src/engine/actor_system.dart';
part '../lib/src/engine/game_message.dart';

main() {

    // Instantiate this to get better formatted output
    unittestConfiguration = new TestConfiguration();

    var isUnhandledMessageError =
        predicate((m) => m is UnhandledMessageError, "is an UnhandledMessageError");

    var isTestMessage =
        predicate((m) => m is TestMessage, "is a TestMessage");


    group("Actor System", () {
        test("basic functionality", () {

            ActorSystem system = new ActorSystem();

            Actor a1 = new TestActor(new ActorId("test/actor1"));
            Actor a2 = new TestActor(new ActorId("test/actor2"));

            return system.spawnActor(a1)
                .then((Actor a) {
                    logMessage("spawned actor a1");
                    expect(a, a1, reason: "The actor returned by the future did not equal the spawned actor");
                })
                .then((_) => system.spawnActor(a2))
                .then((Actor a) {
                    logMessage("spawned actor a2");
                    expect(a, a2, reason: "The actor returned by the future did not equal the spawned actor");
                })
                .then((_) => system.getActor(new ActorId("test/actor1")))
                .then((Actor a) {
                    logMessage("checking actor a1");
                    expect(a, a1, reason: "The actor returned did not match the actor spawned with the same actor Id");
                })
                .then((_) => system.getActor(new ActorId("test/actor2")))
                .then((Actor a) {
                    logMessage("checking actor a2");
                    expect(a, a2, reason: "The actor returned did not match the actor spawned with the same actor Id");
                })
                .then((_) => system.killActor(new ActorId("test/actor1")))
                .then((_) => logMessage("removing actor a1"))
                .then((_) => system.getActor(new ActorId("test/actor1")))
                .then((Actor a) {
                    expect(a, null, reason: "An actor was returned, even though the actor was killed");
                })
                .then((_) => system.killActor(new ActorId("test/actor2")))
                .then((_) => logMessage("removing actor a2"))
                .then((_) => system.getActor(new ActorId("test/actor2")))
                .then((Actor a) {
                    expect(a, null, reason: "An actor was returned, even though the actor was killed");
                })
                ;
        });
    });

    group("Message Passing", () {

        setUp(() {

        });

        tearDown(() {

        });

        test("a single message", () {

            final String actor1Id = "test/actor1";
            final String actor2Id = "test/actor2";
            final String testMessage1Text = "This is a test message from a1!";

            TestActor a1 = new TestActor(new ActorId(actor1Id));
            TestActor a2 = new TestActor(new ActorId(actor2Id));

            a2.registerMessageHandler(TestMessage.TYPE_STRING, expectAsync((GameMessage message, Actor sender) {

                expect(sender, a1, reason: "The sender did not match the actor who sent the message");
                expect(message.type, TestMessage.TYPE_STRING, reason: "The type of the message was '${message.type}'");

                TestMessage testMessage = message as TestMessage;

                expect(testMessage.message, testMessage1Text);

                logMessage("a1 received: ${testMessage.message}");
            }));

            ActorSystem system = new ActorSystem();
            system.spawnActor(a1)
                .then((_) => system.spawnActor(a2))
                .then((_) => a1.sendMessage(a2, new TestMessage(testMessage1Text)));
        });

        test("an unhandled message", () {

            final String actor1Id = "test/actor1";
            final String actor2Id = "test/actor2";
            final String testMessage1Text = "hello!";
            final String testMessage2Text = "goodbye!";

            TestActor a1 = new TestActor(new ActorId(actor1Id));
            TestActor a2 = new TestActor(new ActorId(actor2Id));

            a1.registerMessageHandler(UNHANDLED_MESSAGE_ERROR_TYPE, expectAsync((GameMessage message, Actor sender) {
                expect(message, isUnhandledMessageError, reason: "Message is type '${message.type}'");
                expect(sender, a2);
                logMessage("a1: caught $message");
            }));
            a1.registerMessageHandler(TestMessage.TYPE_STRING, expectAsync((GameMessage message, Actor sender) {
                expect(message, isTestMessage, reason: "Message is type '${message.type}'");
                TestMessage t = message as TestMessage;
                expect(sender, a2);
                expect(t.message, testMessage2Text);
                logMessage("a1: received $message");
            }));
            a2.registerMessageHandler(TestMessage.TYPE_STRING, expectAsync((GameMessage message, Actor sender) {
                expect(message, isTestMessage, reason: "Message is type '${message.type}'");
                TestMessage t = message as TestMessage;
                expect(sender, a1);
                expect(t.message, testMessage1Text);
                logMessage("a2: received $message");
            }));

            ActorSystem system = new ActorSystem();

            system.spawnActor(a1)
                .then((_) => system.spawnActor(a2))
                .then((_) => a1.sendMessage(a2, new UnhandledMessage()))
                .then((_) => a1.sendMessage(a2, new TestMessage(testMessage1Text)))
                .then((_) => a2.sendMessage(a1, new TestMessage(testMessage2Text)));
        });
    });
}
