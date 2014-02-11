part of game;


class GameLoaderJob {

	String _name;
	gameLoaderJobFunc _func;
	var _data;

	GameLoaderJob(this._name, this._func, [this._data = null]);

	Future run(GameLoaderStep step) {
		return this._func(step, this._data);
	}
}
