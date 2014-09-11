part of engine;

class NullMessage extends GameMessage {
    final String type = GameMessage.NULL_MESSAGE_TYPE;
}

abstract class ErrorMessage extends GameMessage {
    final String type = GameMessage.ERROR_MESSAGE_TYPE;

    _MessageError get error;
}

class ExceptionMessage extends GameMessage {
    final String type = GameMessage.EXCEPTION_MESSAGE_TYPE;

    final Exception exception;

    ExceptionMessage(this.exception);
}

class _MessageError extends Error {
    final String message;
    _MessageError(this.message);
}
class UnhandledMessageError extends ErrorMessage {

    final _MessageError error;

    UnhandledMessageError(String message) :
        this.error = new _MessageError(message);
    UnhandledMessageError.withError(this.error);
}

abstract class GameMessage {

    GameMessage();

    String get type;

    static final String NULL_MESSAGE_TYPE = "NULL";
    static final String ERROR_MESSAGE_TYPE = "ERROR";
    static final String EXCEPTION_MESSAGE_TYPE = "EXCEPTION";
}