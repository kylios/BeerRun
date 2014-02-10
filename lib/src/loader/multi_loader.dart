part of loader;

class MultiLoader {
	
	Loader _loader;
	int _count;
	Completer<Map<String, Map>> _completer;
	Map<String, Map> _loadedResults;
	var _singleCallback;

	MultiLoader(this._loader) {
		this._init();
		this._singleCallback = null;
	}

	void _init() {
		this._count = 0;
		this._completer = new Completer<Map<String, Map>>();
		this._loadedResults = new Map<String, Map>();
	}

	void onSingleLoad(var singleCallback) {
		this._singleCallback = singleCallback;
	}

	Future<Map<String, Map>> load(String resourceUrl) {

		this._count++;
		this._loader.load(resourceUrl).then((Map m) {

			this._count--;
			this._loadedResults[resourceUrl] = m;
			if (null != this._singleCallback) {
				this._singleCallback(m);
			}

			if (this._count == 0) {
				this._completer.complete(this._loadedResults);
				this._init();
			}
		});

		return this._completer.future;
	}

	Future<Map<String, Map>> wait() => this._completer.future;
}