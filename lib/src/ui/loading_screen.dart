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

    factory LoadingScreen(UIInterface ui, LoadProgressEmitter emitter) {

        // the main body view
        View contents = new View(ui);

        TextView loading = new TextView(ui, "Pouring beer...");
        contents.addView(loading);

        View progress = LoadingScreen._createProgressView(ui, contents);

        return new LoadingScreen._internal(ui, contents, progress, emitter);
    }

    /**
  	 * Internal constructor just identical to Dialog's constructor.
     */
    LoadingScreen._internal(UIInterface ui, View
            contents, this._progressView, LoadProgressEmitter emitter) : super(ui, contents)
            {

        ui.addListener(this);

        emitter.onLoadQueueResize.listen(this.addTask);
        emitter.onLoadQueueProgress.listen(this.completeTask);
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

    void _updateProgress([String name = null]) {

        int widthPercent = (100 * (this._completedTasks /
                this._numTasks)).toInt();
        window.console.log(
                "Progress ${name != null ? " [${name}]" : ' '}: ${this._completedTasks} / ${this._numTasks} = $widthPercent %"
                );

        this._targetProgress = widthPercent;

        if (this._oldCompletedTasks != this._completedTasks) {
            this._currentProgress = this._targetProgress;
        }


        this._progressView.style.width = "${this._currentProgress}%";

        this._oldCompletedTasks = this._completedTasks;
    }

    void addTask([String name = null]) {
        this._numTasks += 1;
        this._updateProgress(name);
    }
    void completeTask([String name = null]) {
        this._completedTasks += 1;
        this._updateProgress(name);
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
