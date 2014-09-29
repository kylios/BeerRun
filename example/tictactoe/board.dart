part of tictactoe;


class Board extends Entity {

    final int rows;
    final int cols;

    List<Player> _players = null;
    Map<Player, List<Position>> _positions = null;
    int _currentPlayerIdx;
    List<List<Player>> _board = null;

    final DisplayActor _display;

    Board(ActorId actorId, this.rows, this.cols, this._display) : super(actorId) {

        if (this.rows < 3 || this.cols < 3) {
            throw new Exception("3 is the minimum!");
        }
    }

    List<Player> get players => this._players.toList(growable: false);

    void addPlayer(Player player) {

        if (player == null) {
            throw new Exception("Player can't be null");
        }

        if (this._players.contains(player)) {
            throw new Exception("Can't add the same player twice!");
        }

        this._players.add(player);
        this._positions[player] = new List<Position>();
    }

    void removePlayer(Player player) {

        this._players.remove(player);
        this._positions.remove(player);
    }

    Future onStartUp() {

        return new Future.delayed(new Duration(), () {
            this._board = new List<List<Player>>.generate(
                    this.rows,
                    (int idx) => new List<Player>.filled(this.cols, null));
            this._players = new List<Player>();
            this._positions = new Map<Player, List<Position>>();
            return this;
        });
    }

    Future onShutDown() {

        return new Future.delayed(new Duration(), () {
            this._board = null;
            this._players = null;
            this._positions = null;
            return this;
        });
    }

    Player checkWinner() {

        // check for a winner
        // TODO

        // null indicates no winner
        return null;
    }

    bool isCorner(Position p) {
        return (p.row == 0 || p.row == this.numRows - 1) &&
                (p.col == 0 || p.col == this.numCols - 1);
    }

    bool isSide(Position p) {
        return ((p.row == 0 || p.row == this.numRows - 1) &&
                (p.col > 0 && p.col < this.numCols - 1) ||
                (p.row > 0 && p.row < this.numRows - 1) &&
                (p.col == 0 || p.col == this.numCols - 1));
    }

    bool isMiddle(Position p) {
        return (p.row > 0 && p.row < this.numRows - 1 &&
                p.col > 0 && p.col < this.numCols - 1);
    }

    /**
     * Return true if there are no moves on the board
     */
    bool get isEmpty {

        // don't use numOccupied for this method.  We want to terminate this loop early
        for (int r = 0; r < this._board.length; r++) {
            for (int c = 0; c < this._board.first.length; c++) {
                if (null != this._board[r][c]) {    // avoid creating a Position
                    return false;
                }
            }
        }

        return true;
    }

    int get numOccupied {
        int count = 0;
        for (int r = 0; r < this._board.length; r++) {
            for (int c = 0; c < this._board.first.length; c++) {
                if (null != this._board[r][c]) {
                    count++;
                }
            }
        }
        return count;
    }

    Player getAt(Position p) {
        if (p.row < 0 || p.col < 0) {
            return null;
        }
        if (p.row >= this._board.length) {
            return null;
        }
        if (p.col >= this._board.first.length) {
            return null;
        }
        return this._board[p.row][p.col];
    }

    List<Position> getPositions(Player p) => this._positions[p];

    Set<Position> get positionSet =>
            new Set<Position>.from(
                new List<Position>.generate(numRows * numCols,
                        (i) => new Position(i ~/ numRows, i % numCols)));

    void set(Player player, Position p) {

        if (player == null) {
            throw new Exception("Player cannot be null");
        }
        if (p == null) {
            throw new Exception("Position cannot be null");
        }

        if (this._positions[player] == null) {
            throw new Exception("Player not added: $p");
        }

        if (p.row >= this._board.length ||
                p.row < 0 ||
                p.col >= this._board[0].length ||
                p.col < 0) {
            throw new Exception("Position out of range $p");
            return;
        }

        if (this._board[p.row][p.col] != null) {
            throw new Exception("Space already occupied $p");
            return;
        }

        this._board[p.row][p.col] = player;
        this._positions[player].add(p);
    }

    void setMany(List<List<Player>> players) {

        if (players == null) {
            throw new Exception("Players cannot be null");
        }

        for (int r = 0; r < players.length; r++) {
            for (int c = 0; c < players.first.length; c++) {
                if (players[r][c] == null) {
                    continue;
                }
                Position p = new Position(r, c);
                this.set(players[r][c], p);
            }
        }
    }

    int get numRows => this._board.length;
    int get numCols => this._board.first.length;


}

class BoardComponent extends Component<Board> {

    void init(Board board) {

        if (board == null) {
            throw new Exception("Board cannot be null!");
        }

        board.registerMessageHandler(
                GameStartedEvent.TYPE_STRING,
                (GameStartedEvent message, Actor sender) {

            print("sender: $sender, players: ${board._players}");
            for (Player player in board._players) {
                board.sendMessage(player, message);
            }
            board._currentPlayerIdx = 0;

            board.sendMessage(
                    board._players[board._currentPlayerIdx],
                    new TakeTurnEvent(board));
        });

        board.registerMessageHandler(
                PlayerMarkedEvent.TYPE_STRING,
                // create a closure, keep board in scope
        (PlayerMarkedEvent message, Player sender) =>
                this._onPlayerMarkedEvent(board, message, sender));

        board.sendMessage(board._display, new DrawBoardMessage(board));
    }

    void unload(Board board) {
        board.removeMessageHandler(PlayerMarkedEvent.TYPE_STRING);
    }

    void _onPlayerMarkedEvent(Board board, PlayerMarkedEvent message,
            Player sender) {

        int row = message.position.row;
        int col = message.position.col;
        Player player = message.player;

        if (board == null) {
            board.sendMessage(
                    sender,
                    new ExceptionMessage(new Exception("Board cannot be null!")));

            return;
        }

        if (sender == null) {
            board.sendMessage(
                    sender,
                    new ExceptionMessage(new Exception("Sender cannot be null!")));

            return;
        }

        if (board._players[board._currentPlayerIdx] != player) {
            board.sendMessage(
                    sender,
                    new ExceptionMessage(
                            new Exception(
                                    "Not your turn! " +
                                            "The turn belongs to " +
                                            "${board._players[board._currentPlayerIdx].actorId}")));

            return;
        }

        try {
            board.set(player, new Position(row, col));
        } on Exception catch (e) {
            board.sendMessage(sender, new ExceptionMessage(e));
        }

        board.sendMessage(board._display, new DrawBoardMessage(board));

        // check if it was a winning move
        if (board.checkWinner() == message.player) {
            for (Player p in board._players) {
                board.sendMessage(p, new GameOverEvent(message.player));
            }

            return;
        }

        board._currentPlayerIdx++;
        if (board._currentPlayerIdx >= board._players.length) {
            board._currentPlayerIdx = 0;
        }

        board.sendMessage(
                board._players[board._currentPlayerIdx],
                new TakeTurnEvent(board));

    }
}



