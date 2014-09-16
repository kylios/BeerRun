library tictactoe;

import 'dart:async';

import 'package:beer_run/engine.dart';

part 'src/tictactoe/board.dart';
part 'src/tictactoe/player.dart';
part 'src/tictactoe/ai_component.dart';


void main(List<String> args) {

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

            human.addComponent(new AIComponent());
            computer.addComponent(new AIComponent());

            // initialize the board
            board.addComponent(new BoardComponent());

            // add players to the board
            board.addPlayer(human);
            board.addPlayer(computer);

            system.sendMessage(board, new GameStartedEvent());
        });




}



