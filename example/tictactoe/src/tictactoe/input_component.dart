
//import 'dart:async';
//import 'dart:io';
//import 'entities.dart';

part of tictactoe;

class InputComponent extends PlayerComponent {

    final RegExp _matchPosition = new RegExp(r"([0-9]+),([0-9]+)");

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
        return new Position(int.parse(matches.first.group(0)),
                int.parse(matches.first.group(1)));
    }
}
