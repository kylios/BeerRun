part of tictactoe;

testTicTacToe() {

    // initialize the actor responsible for displaying the game state
    final DisplayActor display =
            new DisplayActor(new ActorId("tic_tac_toe/display/1"));
    display.addComponent(new ScreenDisplayComponent());

    // Instantiate this to get better formatted output
    //unittestConfiguration = new TestConfiguration();

    test('parser test', () {

        InputComponent ic = new InputComponent();

        // equality
        expect(
                new Position(1, 2),
                equals(new Position(1, 2))
                );

        expect(
                new Position(1, 0),
                isNot(equals(new Position(0, 1)))
                );

        expect(ic._decodeInput("1,1"), equals(new Position(1, 1)));
        expect(ic._decodeInput("0,1"), equals(new Position(0, 1)));
        expect(ic._decodeInput("1,0"), equals(new Position(1, 0)));

        expect(ic._decodeInput("1"), isNull);
        expect(ic._decodeInput("1,"), isNull);
        expect(ic._decodeInput(",1"), isNull);
        expect(ic._decodeInput("11"), isNull);
        expect(ic._decodeInput("abc"), isNull);
    });

    group('board test', () {
        test('isEmpty', () {
            Board b = new Board(new ActorId("board/board/1"), 3, 3, display);
            Player p = new Player(new ActorId("board/player/1"), "X", "test1");

            return b.startUp()
                .then((Board b) {

                    b.addPlayer(p);
                    expect(b.isEmpty, isTrue);
                    List<Position> positions = b.getPositions(p);
                    expect(positions, isNot(isNull));
                    expect(positions.length, equals(0));
                    b.set(p, new Position(0, 0));
                    expect(b.isEmpty, isFalse);
                    positions = b.getPositions(p);
                    expect(positions.length, equals(1));
                    expect(positions.first, equals(new Position(0, 0)));

                });
        });

        test('getLineFromPoints', () {

            AIComponent ai = new AIComponent();
            List<Position> points = null;

            Position p00 = new Position(0, 0);
            Position p01 = new Position(0, 1);
            points = ai._getLineFromPoints(p00, p01, 3, 3);
            expect(points,
                   unorderedEquals([
                          new Position(0, 0),
                          new Position(0, 1),
                          new Position(0, 2)
                    ]));
            expect(points.length, equals(3));

            Position p21 = new Position(2, 1);
            points = ai._getLineFromPoints(p21, p01, 3, 3);
            expect(points,
                    equals([
                          new Position(0, 1),
                          new Position(1, 1),
                          new Position(2, 1)
                    ]));
            expect(points.length, equals(3));

            Position p43 = new Position(4, 3);
            points = ai._getLineFromPoints(p21, p43, 6, 5);
            expect(points, isNull);
        });
    });

    group('ai test', () {

        test('pick first move', () {

            Board b = new Board(new ActorId("aitest/board/1"), 3, 3, display);
            Player player = new Player(new ActorId("aitest/player/1"), "X", "test");

            return b.startUp()
                .then((Board b) {

                    b.addPlayer(player);

                    AIComponent ai = new AIComponent();
                    Map<String, int> counts = {
                        "side" : 0,
                        "corner" : 0,
                        "middle" : 0
                    };

                    for (int i = 0; i < 100; i++) {
                        Position p = ai._pickRandomFirstMove(player, b);
                        if (b.isSide(p)) {
                            counts["side"]++;
                        } else if (b.isCorner(p)) {
                            counts["corner"]++;
                        } else {
                            counts["middle"]++;
                        }
                    }

                    logMessage("""
Starting move distribution:
    side: ${counts["side"]}
    corner: ${counts["corner"]}
    middle: ${counts["middle"]}
    
""");

                    // check each count with sensible error margins.
                    // increase the iterations if you want to tighten the margins

                    int sideCount = (100.0 * ai._P_SIDE).toInt();
                    int sideError = 20;
                    expect(counts["side"], inInclusiveRange(
                            sideCount - sideError, sideCount + sideError));

                    int cornerCount = (100.0 * ai._P_CORNER).toInt();
                    int cornerError = 10;
                    expect(counts["corner"], inInclusiveRange(
                            cornerCount - cornerError, cornerCount + cornerError));

                    int middleCount = (100.0 * ai._P_MIDDLE).toInt();
                    int middleError = 8;
                    expect(counts["middle"], inInclusiveRange(
                            middleCount - middleError, middleCount + middleError));
                });
        });

        test('find a winning move', () {
            Player p1 = new Player(new ActorId("aitest/player/1"), "X", "test1");
            Player p2 = new Player(new ActorId("aitest/player/2"), "O", "test2");

            Board b1 = new Board(new ActorId("aitest/board/1"), 3, 3, display);
            return b1.startUp()
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.set(p1, new Position(0, 0));
                    b.set(p1, new Position(2, 0));

                    AIComponent aiComponent = new AIComponent();

                    expect(aiComponent._winning(new Position(1, 0), b, p1), isTrue);

                    return b;
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.set(p1, new Position(0, 0));
                    b.set(p1, new Position(0, 2));

                    AIComponent aiComponent = new AIComponent();

                    expect(aiComponent._winning(new Position(0, 1), b, p1), isTrue);

                    return b;
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.set(p1, new Position(0, 0));
                    b.set(p1, new Position(2, 2));

                    AIComponent aiComponent = new AIComponent();

                    expect(aiComponent._winning(new Position(1, 1), b, p1), isTrue);

                    return b;
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.set(p1, new Position(0, 2));
                    b.set(p1, new Position(2, 0));

                    AIComponent aiComponent = new AIComponent();

                    expect(aiComponent._winning(new Position(1, 1), b, p1), isTrue);

                    return b;
                });

        });

        test('defensive strategies', () {

            Player p1 = new Player(new ActorId("aitest/player/1"), "X", "test1");
            Player p2 = new Player(new ActorId("aitest/player/2"), "O", "test2");

            Board b1 = new Board(new ActorId("aitest/board/1"), 3, 3, display);
            return b1.startUp()
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.setMany([
                           [null, p1, null],
                           [null, p2, p2],
                           [p1, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();

                    Function cb = expectAsync((Position p) {
                        print("picked move: $p");
                        expect(p, equals(new Position(1, 0)));
                    });

                    return aiComponent._pickMove(p1, b)
                        .then(cb)
                        .then((_) => b);
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.setMany([
                           [null, p1, null],
                           [p2, p2, null],
                           [p1, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();

                    Function cb = expectAsync((Position p) {
                        print("picked move: $p");
                        expect(p, equals(new Position(1, 2)));
                    });

                    return aiComponent._pickMove(p1, b)
                        .then(cb)
                        .then((_) => b);
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.setMany([
                           [null, p2, null],
                           [null, p2, p1],
                           [p1, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();

                    Function cb = expectAsync((Position p) {
                        logMessage("picked move: $p");
                        expect(p, equals(new Position(2, 1)));
                    });

                    return aiComponent._pickMove(p1, b)
                        .then(cb)
                        .then((_) => b);
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.setMany([
                           [p1, null, p2],
                           [null, p2, p1],
                           [null, null, p2]
                               ]);

                    AIComponent aiComponent = new AIComponent();

                    Function cb = expectAsync((Position p) {
                        logMessage("picked move: $p");
                        expect(p, equals(new Position(2, 0)));
                    });

                    return aiComponent._pickMove(p1, b)
                        .then(cb)
                        .then((_) => b);
                })
                ;
        });

        test("pick offensive move", () {
            Player p1 = new Player(new ActorId("aitest/player/1"), "X", "test1");
            Player p2 = new Player(new ActorId("aitest/player/2"), "O", "test2");

            Board b1 = new Board(new ActorId("aitest/board/1"), 3, 3, display);
            return b1.startUp()
                .then((Board b) {

                    b.addPlayer(p1);
                    b.addPlayer(p2);

                    b.setMany([
                           [p1, p2, null],
                           [null, null, null],
                           [null, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();

                    Position p = aiComponent._pickOffensiveMove(p1, b);
                    expect(p, anyOf([
                                     equals(new Position(1, 0)),
                                     equals(new Position(2, 0)),
                                     equals(new Position(1, 1)),
                                     equals(new Position(2, 2))
                                     ]));

                    return b;

                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);
                    b.setMany([
                            [p1, null, p2],
                            [null, null, null],
                            [null, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();
                    Position p = aiComponent._pickOffensiveMove(p1, b);

                    expect(p, anyOf([
                                     equals(new Position(1, 0)),
                                     equals(new Position(1, 1)),
                                     equals(new Position(2, 2)),
                                     equals(new Position(2, 0))
                                     ]));

                    return b;
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);
                    b.setMany([
                            [null, p1, null],
                            [null, null, null],
                            [null, p2, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();
                    Position p = aiComponent._pickOffensiveMove(p1, b);

                    expect(p, anyOf([
                                     equals(new Position(0, 0)),
                                     equals(new Position(0, 2))
                                     ]));

                    expect(p, isNot(anyOf([
                                           equals(new Position(0, 1)),
                                           equals(new Position(1, 0)),
                                           equals(new Position(1, 1)),
                                           equals(new Position(1, 2)),
                                           equals(new Position(2, 0)),
                                           equals(new Position(2, 1)),
                                           equals(new Position(2, 2))
                                         ])));

                    return b;
                })
                .then((Board b) => b.shutDown())
                .then((Board b) => b.startUp())
                .then((Board b) {
                    b.addPlayer(p1);
                    b.addPlayer(p2);
                    b.setMany([
                            [p1, null, null],
                            [null, p2, null],
                            [null, null, null]
                               ]);

                    AIComponent aiComponent = new AIComponent();
                    Position p = aiComponent._pickOffensiveMove(p1, b);

                    expect(p, anyOf([
                                     equals(new Position(0, 1)),
                                     equals(new Position(1, 0)),
                                     equals(new Position(0, 2)),
                                     equals(new Position(2, 0))
                                     ]));

                    return b;
                })
                ;
        });

        test("pick defensive move", () {
                    Player p1 = new Player(new ActorId("aitest/player/1"), "X", "test1");
                    Player p2 = new Player(new ActorId("aitest/player/2"), "O", "test2");

                    Board b1 = new Board(new ActorId("aitest/board/1"), 3, 3, display);
                    return b1.startUp()
                        .then((Board b) {

                            b.addPlayer(p1);
                            b.addPlayer(p2);

                            b.setMany([
                                   [p1, p2, null],
                                   [null, null, null],
                                   [null, null, null]
                                       ]);

                            AIComponent aiComponent = new AIComponent();

                            Position p = aiComponent._pickDefensiveMove(p1, b);
                            expect(p, anyOf([
                                             equals(new Position(0, 2)),
                                             equals(new Position(1, 2)),
                                             equals(new Position(2, 1))
                                             ]));

                            return b;

                        })
                        .then((Board b) => b.shutDown())
                        .then((Board b) => b.startUp())
                        .then((Board b) {
                            b.addPlayer(p1);
                            b.addPlayer(p2);
                            b.setMany([
                                    [p1, null, p2],
                                    [null, null, null],
                                    [null, null, null]
                                       ]);

                            AIComponent aiComponent = new AIComponent();
                            Position p = aiComponent._pickDefensiveMove(p1, b);

                            expect(p, anyOf([
                                             equals(new Position(0, 1)),
                                             equals(new Position(1, 2)),
                                             equals(new Position(2, 1))
                                             ]));

                            return b;
                        })
                        .then((Board b) => b.shutDown())
                        .then((Board b) => b.startUp())
                        .then((Board b) {
                            b.addPlayer(p1);
                            b.addPlayer(p2);
                            b.setMany([
                                    [null, p1, null],
                                    [null, null, null],
                                    [null, p2, null]
                                       ]);

                            AIComponent aiComponent = new AIComponent();
                            Position p = aiComponent._pickDefensiveMove(p1, b);

                            expect(p, anyOf([
                                             equals(new Position(1, 1)),
                                             equals(new Position(2, 0)),
                                             equals(new Position(1, 0)),
                                             equals(new Position(1, 2)),
                                             equals(new Position(2, 2))
                                             ]));

                            return b;
                        })
                        .then((Board b) => b.shutDown())
                        .then((Board b) => b.startUp())
                        .then((Board b) {
                            b.addPlayer(p1);
                            b.addPlayer(p2);
                            b.setMany([
                                    [p1, null, null],
                                    [null, p2, null],
                                    [null, null, null]
                                       ]);

                            AIComponent aiComponent = new AIComponent();
                            Position p = aiComponent._pickDefensiveMove(p1, b);

                            expect(p, anyOf([
                                             equals(new Position(2, 2)),
                                             equals(new Position(2, 1)),
                                             equals(new Position(1, 2))
                                             ]));

                            return b;
                        })
                        ;
                });
    });
}


