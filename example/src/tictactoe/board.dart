part of tictactoe;

class PlayerMarkedEvent extends GameMessage {
    static final String TYPE_STRING = "PLAYER_MARKED_EVENT";
    String get type => TYPE_STRING;

    final Position position;
    final Player player;

    PlayerMarkedEvent(this.position, this.player);

    String toString() => position.toString() + " by '$player'";
}

class GameStartedEvent extends GameMessage {
    static final String TYPE_STRING = "GAME_STARTED_EVENT";
    String get type => TYPE_STRING;
}

class TakeTurnEvent extends GameMessage {
    static final String TYPE_STRING = "TAKE_TURN_EVENT";
    String get type => TYPE_STRING;
    final Board board;
    TakeTurnEvent(this.board);
}

class Position {
    final int row;
    final int col;
    Position(this.row, this.col);
    String toString() => "($row, $col)";
}

class Board extends Entity {

    final int rows;
    final int cols;

    List<Player> _players = null;
    int _currentPlayerIdx;
    List<List<Player>> _board = null;

    Board(ActorId actorId, this.rows, this.cols) : super(actorId) {

        if (this.rows < 3 || this.cols < 3) {
            throw new Exception("3 is the minimum!");
        }
    }

    void addPlayer(Player player) {

        if (player == null) {
            throw new Exception("Player can't be null");
        }

        if (this._players.contains(player)) {
            throw new Exception("Can't add the same player twice!");
        }

        this._players.add(player);
    }

    void removePlayer(Player player) {

        this._players.remove(player);
    }

    Future onStartUp() {

        return new Future.delayed(new Duration(), () {
                this._board = new List<List<Player>>.generate(this.rows,
                    (int idx) => new List<Player>.filled(this.cols, null));
                this._players = new List<Player>();
                return this;
        });
    }

    Future onShutDown() {

        return new Future.delayed(new Duration(), () {
            this._board = null;
            this._players = null;
            return this;
        });
    }
}

class BoardComponent extends Component<Board> {

    void init(Board board) {

        if (board == null) {
            throw new Exception("Board cannot be null!");
        }

        board.registerMessageHandler(GameStartedEvent.TYPE_STRING,

                (GameStartedEvent message, Actor sender) {

                    print("sender: $sender, players: ${board._players}");
                    for (Player player in board._players) {
                        board.sendMessage(player, message);
                    }
                    board._currentPlayerIdx = 0;

                    board.sendMessage(board._players[board._currentPlayerIdx],
                            new TakeTurnEvent(board));
                });

        board.registerMessageHandler(PlayerMarkedEvent.TYPE_STRING,

                // create a closure, keep board in scope
                (PlayerMarkedEvent message, Player sender) =>
                    this._onPlayerMarkedEvent(board, message, sender));
    }

    void unload(Board board) {
        board.removeMessageHandler(PlayerMarkedEvent.TYPE_STRING);
    }

    void _onPlayerMarkedEvent(Board board,
                              PlayerMarkedEvent message, Player sender) {

        int row = message.position.row;
        int col = message.position.col;
        Player player = message.player;

        if (row >= board._board.length || row < 0 ||
                col >= board._board[0].length || col < 0) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Position out of range ($row, $col)")));
        }

        if (board == null) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Board cannot be null!")));
        }

        if (sender == null) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Sender cannot be null!")));
        }

        if (board._board[row][col] != null) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Space already occupied")));
        }

        if (board._players[board._currentPlayerIdx] != player) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception(
                            "Not your turn! " +
                            "The turn belongs to " +
                            "${board._players[board._currentPlayerIdx].actorId}")));
        }

        board._board[row][col] = message.player;

        board._currentPlayerIdx++;
        if (board._currentPlayerIdx >= board._players.length){
            board._currentPlayerIdx = 0;
        }

        board.sendMessage(board._players[board._currentPlayerIdx],
                new TakeTurnEvent(board));

    }
}