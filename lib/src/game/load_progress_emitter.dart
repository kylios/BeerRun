part of game;

abstract class LoadProgressEmitter {

    Stream<String> get onLoadQueueResize;
    Stream<String> get onLoadQueueProgress;

}