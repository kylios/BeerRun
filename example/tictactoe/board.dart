part of tictactoe;


class Board extends Entity {

    final int rows;
    final int cols;

    List<Player> _players = null;
    Map<Player, List<Position>> _positions = null;
    int _currentPlayerIdx;
    List<List<Player>> _board = null;

    final DisplayActor _display;

    Board(ActorId actorId, this.rows, this.cols, this._display) : super(
            actorId) {

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

    List<int> _range(int start, int length) =>
            new List<int>.generate(length, (i) => start + i);

    Player checkWinner() {

        // check for a winner
        Board b = this;


        // check the columns
        for (int c = 0; c < cols; c++) {
            Player player = null;
            bool contains = false;
            for (int r = 0; r < rows; r++) {
                Position p = new Position(r, c);
                Player pl = this.getAt(p);
                if (player == null) {
                    if (pl == null) {
                        break; // not in this column
                    } else {
                        contains = true;
                        player = pl;
                    }
                } else {
                    if (pl == player) {
                        continue;
                    } else {
                        contains = false;
                        break; // not in this column
                    }
                }
            }
            if (contains) {
                return player;
            }
        }

        // check the rows
        for (int r = 0; r < rows; r++) {
            Player player = null;
            bool contains = false;
            for (int c = 0; c < cols; c++) {
                Position p = new Position(r, c);
                Player pl = this.getAt(p);
                if (player == null) {
                    if (pl == null) {
                        break; // not in this row
                    } else {
                        contains = true;
                        player = pl;
                    }
                } else {
                    if (pl == player) {
                        continue;
                    } else {
                        contains = false;
                        break; // not in this row
                    }
                }
            }
            if (contains) {
                return player;
            }
        }

        // check diagonals

        Player pl1 = null;
        Player pl2 = null;
        int count1 = 0;
        int count2 = 0;

        for (int i = 0; i < rows; i++) {
            Position p1 = new Position(i, i);
            Position p2 = new Position(numRows - i - 1, i);
            Player pl = this.getAt(p1);

            // this feels evil.  TODO
            (() {
                if (pl == null) {
                    return;
                } else {
                    if (pl1 == null || pl1 == pl) {
                        pl1 = pl;
                        count1++;
                    }
                }
            })();

            pl = this.getAt(p2);
            (() {
                if (pl == null) {
                    return;
                } else {
                    if (pl2 == null || pl2 == pl) {
                        pl2 = pl;
                        count2++;
                    }
                }
            })();

        }
        if (count1 == rows) {
            return pl1;
        }
        if (count2 == cols) {
            return pl2;
        }

        // null indicates no winner
        return null;
    }

    List<Position> getRow(int r) =>
            new List.generate(cols, (c) => new Position(r, c));
    List<Position> getCol(int c) =>
            new List.generate(rows, (r) => new Position(r, c));

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
        return (p.row > 0 &&
                p.row < this.numRows - 1 &&
                p.col > 0 &&
                p.col < this.numCols - 1);
    }

    /**
     * Return true if there are no moves on the board
     */
    bool get isEmpty {


                // don't use numOccupied for this method.  We want to terminate this loop early
        for (int r = 0; r < this._board.length; r++) {
            for (int c = 0; c < this._board.first.length; c++) {
                if (null != this._board[r][c]) { // avoid creating a Position
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
                    new List<Position>.generate(
                            numRows * numCols,
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
        Player winner = board.checkWinner();
        if (board.checkWinner() != null) {
            for (Player p in board._players) {
                board.sendMessage(p, new GameOverEvent(message.player));
                // send message to winner?
            }
            board.sendMessage(board._display, new TextMessageEvent("${winner.symbol} Wins!"));

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


