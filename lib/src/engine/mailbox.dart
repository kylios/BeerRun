part of engine;

abstract class Mailbox {

    /**
     * Completes with the next message to process.  The returned message is
     * removed from the mailbox and will never be returned from this function
     * again unless it is added back to the mailbox or it is stashed.
     * */
    Future<GameMessage> getNextMessage();
    void addMessage(GameMessage message);
    void deferMessage(GameMessage message);
    void reinstateAllMessages();
}