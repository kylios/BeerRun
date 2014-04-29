part of game;

class GameLoader implements LoadProgressEmitter {



	StreamController<String> _loadQueueProgressStream;
	StreamController<String> _loadQueueResizeStream;

	GameLoader() :
		this._loadQueueProgressStream = new StreamController<String>(),
		this._loadQueueResizeStream = new StreamController<String>()
		;

	Stream<String> get onLoadQueueResize => this._loadQueueResizeStream.stream;
	Stream<String> get onLoadQueueProgress => this._loadQueueProgressStream.stream;

	Future runJob(gameLoaderJob job, [String name = null]) {

		Completer c = new Completer();
		this._loadQueueResizeStream.add(name);
		if (null != name) {
		    window.console.log("GameLoader: $name started");
		}
		Future f = job();
		f.then((var data) {
			this._loadQueueProgressStream.add(name);

			if (null != name) {
			    window.console.log("GameLoader: $name completed");
			}

			c.complete(data);
		});

		return c.future;
	}


}
