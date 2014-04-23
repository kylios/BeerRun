part of ui;

class LoadingScreen extends Dialog implements UIListener {
	
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

	    return new LoadingScreen._internal(ui, contents, progress);
	}

	/**
	 * Internal constructor just identical to Dialog's constructor.
     */
 	LoadingScreen._internal(UIInterface ui, View contents, this._progressView) :
    		super(ui, contents) {

		ui.addListener(this);
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


		this._progressView.style.width = "${this._currentProgress}%";

    	this._oldCompletedTasks = this._completedTasks;  
	}

   	void addTask() {
   		this._numTasks++;
   	}
   	void completeTask() {
   		this._completedTasks++;
   		this._updateProgress();
   	}

   	void onLoadQueueResize(int size) {
   		this._numTasks += size;
   		this._updateProgress();
   	}

   	void onLoadQueueProgress(int completed) {
   		this._completedTasks += completed;
   		this._updateProgress();
   	}

	void onWindowOpen(uiFunction) {
	}

	void onWindowClose(uiFunction) {
		window.console.log("LoadingScreen::onWindowClose");
		if (this._updateTimer != null) {
			this._updateTimer.cancel();
			this._updateTimer = null;
		}
	}
}