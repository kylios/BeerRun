part of game;

class GameConfig {

	Map _config;

	GameConfig(this._config);

	get([String key = null]) {

		if (null == key || null == this._config[key])  {
			return this._config;
		}
		return this._config[key];
	}
}