part of game;

class GameConfig {

	Map _config;

	Future<GameConfig> load() {

		Completer<GameConfig> c = new Completer<GameConfig>();
		Loader loader = new Loader("");
		loader.load('/get_config.php').then((Map data) {
			this._config = data;
			c.complete(this);
		});

		return c.future;
	}

	get([String key = null]) {

		if (null == key || null == this._config[key])  {
			return this._config;
		}
		return this._config[key];
	}
}