part of tictactoe;

// TODO: this could be made generic by taking a "Drawable" instance instead of
// a board.  Board class would then implement Drawable
class DrawBoardMessage extends GameMessage {
    static final String TYPE_STRING = "DRAW_BOARD_MESSAGE";
    String get type => TYPE_STRING;
    final Board board;
    DrawBoardMessage(this.board);
}

class ScreenDisplayComponent extends Component {

    void init(DisplayActor a) {

        a.registerMessageHandler(DrawBoardMessage.TYPE_STRING,
                (DrawBoardMessage message, Actor sender) {

                    String str = "";
                    for (int r = 0; r < message.board.numRows; r++) {
                        for (int c = 0; c < message.board.numCols; c++) {
                            Player p = message.board.getAt(new Position(r, c));
                            if (p == null) {
                                str += ". ";
                            } else {
                                str += p.symbol + " ";
                            }
                        }
                        str += "\n";
                    }

                    print(str);
                });
    }

    void unload(DisplayActor a) {
        a.removeMessageHandler(DrawBoardMessage.TYPE_STRING);
    }
}

class DisplayActor extends Entity {

    DisplayActor(ActorId actorId) : super(actorId);

    Future onStartUp() {
        return new Future.value();
    }

    Future onShutDown() {
        return new Future.value();
    }


}
