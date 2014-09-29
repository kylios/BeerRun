library tictactoe;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:beer_run/engine.dart';

import "package:unittest/unittest.dart";
import 'package:quiver/core.dart';

part "ai_component.dart";
part "board.dart";
part "player.dart";
part "display_actor.dart";
part "test/test.dart";

void main(List<String> args) {

    if (args.contains("--test") || args.contains("-t")) {
        return testTicTacToe();
    }

    final int rows = 3;
    final int cols = 3;

    // initialize the actor responsible for displaying the game state
    final DisplayActor display =
            new DisplayActor(new ActorId("tic_tac_toe/display/1"));
    display.addComponent(new ScreenDisplayComponent());

    // initialize two players
    final Player human =
            new Player(new ActorId("tic_tac_toe/player/1"), "human", "X");
    final Player computer =
            new Player(new ActorId("tic_tac_toe/player/2"), "computer", "O");
    final Board board =
            new Board(new ActorId("tic_tac_toe/board/1"), rows, cols, display);


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
    bool operator ==(that) {
        if (that == null) {
            return false;
        }
        if (that is Position) {
            return this.row == that.row && this.col == that.col;
        }
        return false;
    }
    int get hashCode => hash2(this.row.hashCode, this.col.hashCode);
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
        return new Position(
                int.parse(matches.first.group(1)),
                int.parse(matches.first.group(2)));
    }
}




