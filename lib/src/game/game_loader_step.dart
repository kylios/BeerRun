part of game;

class GameLoaderStep {

	GameManager _manager;

	Completer<GameLoaderStep> _completer;
	Future<GameLoaderStep> _future;

	List<GameLoaderJob> _jobs;
	int _runningJobs = 0;

	GameLoaderStep(this._manager) :
		this._jobs = new List<GameLoaderJob>();

	GameLoaderStep.fromFunction(String name, this._manager, gameLoaderJobFunc func, [var data = null]) :
		this._jobs = new List<GameLoaderJob>() {

		GameLoaderJob job = new GameLoaderJob(name, func, data);
		this.addJob(job);
	}

	void addJob(GameLoaderJob job) {
		if (this._completer != null) {
			this._startJob(job);
		} else {
			this._jobs.add(job);
		}
	}

	Future<GameLoaderStep> run() {

		if (null == this._completer) {

    		this._completer = new Completer<GameLoaderStep>();

    		this._jobs.forEach((GameLoaderJob job) => this._startJob(job));
		}

		return this._completer.future;
	}

	void _startJob(GameLoaderJob job) {
		this._runningJobs++;
		this._manager._loadingScreen.addTask();
		window.console.log("Starting job ${job._name}");
		job.run(this).then((var _) {
			this._runningJobs--;
			this._manager._loadingScreen.completeTask();
			window.console.log("Finished job ${job._name}");
			if (this._runningJobs == 0) {
				this._completer.complete(this);
			}
		});
	}
}