library tictactoe;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:beer_run/engine.dart';

import "package:unittest/unittest.dart";
import "package:beer_run/test_utils.dart";

part "test/test.dart";

void main(List<String> args) {

    if (args.contains("--test") || args.contains("-t")) {
        return testTicTacToe();
    }

    final int rows = 3;
    final int cols = 3;

    // initialize two players
    final Player human =
            new Player(new ActorId("tic_tac_toe/player/1"), "human", "X");
    final Player computer =
            new Player(new ActorId("tic_tac_toe/player/2"), "computer", "O");
    final Board board = new Board(new ActorId("tic_tac_toe/board/1"), rows, cols);

    final ActorSystem system = new ActorSystem();
    system.spawnActor(human)
        .then((_) => system.spawnActor(computer))
        .then((_) => system.spawnActor(board))
        .then((_) {

            //human.addComponent(new AIComponent());
            human.addComponent(new InputComponent());
            computer.addComponent(new AIComponent());

            // initialize the board
            board.addComponent(new BoardComponent());

            // add players to the board
            board.addPlayer(human);
            board.addPlayer(computer);

            system.sendMessage(board, new GameStartedEvent());
        });




}


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
        player.registerMessageHandler(GameStartedEvent.TYPE_STRING,
                (GameStartedEvent message, Board sender) {
                    this._gameStarted();
                });

        // When we're prompted to take a turn, figure out where to place our
        // mark, then notify the board.
        player.registerMessageHandler(TakeTurnEvent.TYPE_STRING,
                (TakeTurnEvent message, Board sender) {

                    // implement the pickMove method
                    this._pickMove(player, message.board)

                        // send the message back to the board
                        .then((Position p) => player.sendMessage(message.board, new PlayerMarkedEvent(p, player)));

                });

        player.registerMessageHandler(GameOverEvent.TYPE_STRING,
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

class GameOverEvent extends GameMessage {
    static final String TYPE_STRING = "GAME_OVER_EVENT";
    String get type => TYPE_STRING;
    final Player player;
    GameOverEvent(this.player);
}

class Position {
    final int row;
    final int col;
    Position(this.row, this.col);
    String toString() => "($row, $col)";
    bool operator==(Position that) {
        if (that == null) {
            return false;
        }
        return this.row == that.row && this.col == that.col;
    }
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

    Player checkWinner() {

        // check for a winner
        // TODO

        // null indicates no winner
        return null;
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

    void set(Player player, Position p) {

        if (p.row >= this._board.length || p.row < 0 ||
                p.col >= this._board[0].length || p.col < 0) {
            throw new Exception("Position out of range $p");
            return;
        }

        if (this._board[p.row][p.col] != null) {
            throw new Exception("Space already occupied $p");
            return;
        }

        this._board[p.row][p.col] = player;
    }

    int get numRows => this._board.length;
    int get numCols => this._board.first.length;


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

        if (board == null) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Board cannot be null!")));

            return;
        }

        if (sender == null) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception("Sender cannot be null!")));

            return;
        }

        if (board._players[board._currentPlayerIdx] != player) {
            board.sendMessage(sender,
                    new ExceptionMessage(new Exception(
                            "Not your turn! " +
                            "The turn belongs to " +
                            "${board._players[board._currentPlayerIdx].actorId}")));

            return;
        }

        try {
            board.set(player, new Position(row, col));
        } on Exception catch(e) {
            board.sendMessage(sender, new ExceptionMessage(e));
        }


        // check if it was a winning move
        if (board.checkWinner() == message.player) {
            for (Player p in board._players) {
                board.sendMessage(p, new GameOverEvent(message.player));
            }

            return;
        }

        board._currentPlayerIdx++;
        if (board._currentPlayerIdx >= board._players.length){
            board._currentPlayerIdx = 0;
        }

        board.sendMessage(board._players[board._currentPlayerIdx],
                new TakeTurnEvent(board));

    }
}




class InputComponent extends PlayerComponent {

    final RegExp _matchPosition = new RegExp("([0-9]+),([0-9]+)");

    void _gameStarted() {
    }

    Future<Position> _pickMove(Player player, Board board) {

        Position p = null;

        Completer<Position> c = new Completer<Position>();

        Timer.run(() {

            // TODO: don't block
            do {
                String input = stdin.readLineSync();
                p = this._decodeInput(input);
            } while (null == p);

            c.complete(p);
        });

        return c.future;
    }

    Position _decodeInput(String input) {

        Iterable<Match> matches = this._matchPosition.allMatches(input);
        if (matches.isEmpty) {
            return null;
        }
        return new Position(int.parse(matches.first.group(1)),
                int.parse(matches.first.group(2)));
    }
}



class AIComponent extends PlayerComponent {

    void _gameStarted() {

    }

    Future<Position> _pickMove(Player player, Board board) {

        return new Future<Position>.delayed(new Duration(), () {
            final int rows = board.rows;
            final int cols = board.cols;

            // ai logic
            /*
             *
             * for each position p
             *  if winning(p)
             *      place(p)
             *      done
             *  if cornered(p)
             *      place(p)
             *      done
             *
             * // start strategic offensive
             *
             */

            // take the center spot if it is available
            if (board._board[rows ~/ 2][cols ~/ 2] == null) {
                return new Position(rows ~/ 2, cols ~/ 2);
            }

            for (int row = 0 ; row < rows; ++row) {
                for (int col = 0; col < cols; ++col) {
                    if (board._board[row][col] == null) {
                        return new Position(row, col);
                    }
                }
            }

            throw new Exception("No available spots");
        });
    }

    bool _winning(Position p, Board b, Player player) {

        /*
         * Winning positions:
         * X WiX    X . .   X . .
         * . . .    . Wi.   Wi. .
         * . . .    . . X   X . .
         *
         * The strategy is to construct a list of players at the row, col, and
         * each diagonal passing through point p.  These lists are passed into
         * _checkLine, which returns true iff the given player is the only
         * element of each list.
         */

        // check the column
        List<Player> colPlayers = new List<Player>.generate(b.numRows, (r) {
            Position rowPos = new Position(r, p.col);
            if (p == rowPos) {
                return player;
            }
            return b.getAt(rowPos);
        });
        if (this._checkLine(colPlayers, player)) {
            return true;
        }


        // check the row
        List<Player> rowPlayers = new List<Player>.generate(b.numCols, (c) {
            Position colPos = new Position(p.row, c);
            if (p == colPos) {
                return player;
            }
            return b.getAt(colPos);
        });
        if (this._checkLine(rowPlayers, player)) {
            return true;
        }


        // check the first diagonal
        List<Player> diag1Players =
                new List<Player>.generate(min(b.numRows, b.numCols), (_p) {
            Position pos = new Position(_p, _p);
            if (p == pos) {
                return player;
            }
            return b.getAt(pos);
        });
        if (this._checkLine(diag1Players, player)) {
            return true;
        }


        // check the second diagonal
        List<Player> diag2Players =
                new List<Player>.generate(min(b.numRows, b.numCols), (_p) {
            Position pos;
            if (b.numRows < b.numCols) {
                pos = new Position(b.numRows - 1 - _p, _p);
            } else {
                pos = new Position(_p, b.numCols - 1 - _p);
            }
            if (p == pos) {
                return player;
            }
            return b.getAt(pos);
        });
        if (this._checkLine(diag2Players, player)) {
            return true;
        }

        return false;
    }

    bool _checkLine(Iterable<Player> players, Player curPlayer) {
        for (Player p in players) {
            if (p != curPlayer) {
                return false;
            }
        }
        return true;
    }
}




