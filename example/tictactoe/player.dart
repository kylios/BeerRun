part of tictactoe;


class Player extends Entity {

    final String name;
    final String symbol;

    Player(ActorId actorId, this.name, this.symbol) : super(actorId);

    Future onStartUp() => null;

    Future onShutDown() => null;
}

abstract class PlayerComponent extends Component<Player> {

    void init(Player player) {

        // When the game starts, do what you need to do
        player.registerMessageHandler(
                GameStartedEvent.TYPE_STRING,
                (GameStartedEvent message, Board sender) {
            this._gameStarted();
        });

        // When we're prompted to take a turn, figure out where to place our
        // mark, then notify the board.
        player.registerMessageHandler(
                TakeTurnEvent.TYPE_STRING,
                (TakeTurnEvent message, Board sender) {

            // implement the pickMove method
            this._pickMove(
                    player,
                    message.board)// send the message back to the board
            .then(
                    (Position p) =>
                            player.sendMessage(message.board, new PlayerMarkedEvent(p, player)));

        });

        player.registerMessageHandler(
                GameOverEvent.TYPE_STRING,
                (GameOverEvent message, Board sender) {

            player.sendMessage(player, new KillActor());
        });
    }

    void unload(Player player) {

        player.removeMessageHandler(GameStartedEvent.TYPE_STRING);
        player.removeMessageHandler(TakeTurnEvent.TYPE_STRING);
    }

    void _gameStarted();

    Future<Position> _pickMove(Player player, Board board);
}





