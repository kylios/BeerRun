part of game;

/*

Loading steps
Step must be synchronous
Steps contain a collection of asynchronous jobs, or a single job


*/

class GameLoader {

	// Current job

	// Add subjob

	// Next job

	List<GameLoaderStep> _steps;

	GameLoader() :
		this._steps = new List<GameLoaderStep>();

	void addStep(GameLoaderStep step) {
		this._steps.add(step);
	}

	// TODO: we'll want to run an intermediary job between each step to update load progress and stuff
	Future run() {

	    Future f = new Future(() => null);
	    for (GameLoaderStep step in this._steps){
	        f = f.then((var _) => step.run());
	    }

	    return f;
	}
}
