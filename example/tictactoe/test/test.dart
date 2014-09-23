part of tictactoe;

testTicTacToe() {

    // Instantiate this to get better formatted output
    unittestConfiguration = new TestConfiguration();

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

    group('ai test', () {

        test('find a winning move', () {
            Player p1 = new Player(new ActorId("aitest/player/1"), "X", "test1");
            Player p2 = new Player(new ActorId("aitest/player/2"), "O", "test2");

            Board b1 = new Board(new ActorId("aitest/board/1"), 3, 3);
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
    });
}


