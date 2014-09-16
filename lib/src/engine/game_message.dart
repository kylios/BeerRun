part of engine;

const NULL_MESSAGE_TYPE = "NULL";
const ERROR_MESSAGE_TYPE = "ERROR";
const EXCEPTION_MESSAGE_TYPE = "EXCEPTION";
const UNHANDLED_MESSAGE_ERROR_TYPE = "UNHANDLED";

class NullMessage extends GameMessage {
    final String type = NULL_MESSAGE_TYPE;
}

abstract class ErrorMessage extends GameMessage {
    _MessageError get error;
}

class ExceptionMessage extends GameMessage {

    final String type = EXCEPTION_MESSAGE_TYPE;
    final Exception exception;

    ExceptionMessage(this.exception);
}

class _MessageError extends Error {
    final String message;
    _MessageError(this.message);
}
class UnhandledMessageError extends ErrorMessage {

    final String type = UNHANDLED_MESSAGE_ERROR_TYPE;

    final _MessageError error;

    UnhandledMessageError(String message) : this.error = new _MessageError(
            message);
    UnhandledMessageError.withError(this.error);
}

abstract class GameMessage {

    GameMessage();

    String get type;
}
