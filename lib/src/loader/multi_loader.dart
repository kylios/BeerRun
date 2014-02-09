part of loader;

class MultiLoader {
	
	Loader _loader;
	int _count;
	Completer<Map<String, Map>> _completer;
	Map<String, Map> _loadedResults;

	MultiLoader(this._loader) {
		this._init();
	}

	void _init() {
		this._count = 0;
		this._completer = new Completer<Map<String, Map>>();
		this._loadedResults = new Map<String, Map>();
	}

	Future<Map<String, Map>> load(String resourceUrl) {

		this._count++;
		this._loader.load(resourceUrl).then((Map m) {

			this._count--;
			this._loadedResults[resourceUrl] = m;

			if (this._count == 0) {
				this._completer.complete(this._loadedResults);
				this._init();
			}
		});

		return this._completer.future;
	}

	Future<Map<String, Map>> wait() => this._completer.future;
}