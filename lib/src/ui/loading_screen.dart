part of ui;

class LoadingScreen extends Dialog {
	
	int _numTasks = 0;
	int _completedTasks = 0;
	int _oldCompletedTasks = 0;

	int _currentProgress = 0;
	int _targetProgress = 0;

	View _progressView;
	Timer _updateTimer;

	DivElement get rootElement => null;
	
	factory LoadingScreen(UIInterface ui) {

	    // the main body view
	    View contents = new View(ui);

	    TextView loading = new TextView(ui, "Pouring beer...");
	    contents.addView(loading);

	    View progress = LoadingScreen._createProgressView(ui, contents);

	    window.console.log("Creating timer: current_progress: ${this._currentProgress}, target_progress: ${this._targetProgress}");
		Timer updateTimer = new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
			window.console.log("timer: currentProgress=${this._currentProgress}, targetProgress=${this._targetProgress}");
			if (this._currentProgress > this._targetProgress) {
				this._currentProgress -= 2;
			} else if (this._currentProgress < this._targetProgress) {
				this._currentProgress += 4;
			}
			window.console.log("Progress: ${this._currentProgress}%");
			this._progressView.style.width = "${this._currentProgress}%";
		});  

	    return new LoadingScreen._internal(ui, contents, progress, updateTimer);
	}

	/**
	 * Internal constructor just identical to Dialog's constructor.
     */
 	LoadingScreen._internal(UIInterface ui, View contents, this._progressView, this._updateTimer) :
    	super(ui, contents);

    void _onClose() {
    	this._updateTimer.cancel();
    }

    static View _createProgressView(UIInterface ui, View container) {
    	View v = new View(ui);
    	v.style.width = "90%";
    	v.style.height = "64px";
    	v.style.background = "white";

    	container.addView(v);

    	View progress = new View(ui);
    	progress.style.background = "blue";
    	progress.style.height = "64px";
    	progress.style.width = "0%";

    	v.addView(progress);

    	return progress;
    }

    void _updateProgress() {

    	int widthPercent = (100 * (this._completedTasks / this._numTasks)).toInt();
    	window.console.log("Progress: ${this._completedTasks} / ${this._numTasks} = $widthPercent %");

    	this._targetProgress = widthPercent;

       	if (this._oldCompletedTasks != this._completedTasks) {
    		this._currentProgress = this._targetProgress;
    	}

    	this._oldCompletedTasks = this._completedTasks;  
	}

   	void addTask() {
   		this._numTasks++;
   	}
   	void completeTask() {
   		this._completedTasks++;
   		this._updateProgress();
   	}
}