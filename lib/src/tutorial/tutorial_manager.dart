part of tutorial;

typedef Future tutorialStep(var _);

class TutorialManager {

  List<tutorialStep> _steps;
  tutorialStep _startStep = null;
  tutorialStep _finishStep = null;

  Future _cur;
  bool _isStarted = false;
  bool _isComplete = false;

  TutorialManager() {
    this._steps = new List<tutorialStep>();
  }

  bool get isStarted => this._isStarted;
  bool get isComplete => this._isComplete;

  TutorialManager addStep(tutorialStep step) {
    this._steps.add(step);
    return this;
  }

  TutorialManager onStart(tutorialStep step) {
    this._startStep = step;
    return this;
  }

  TutorialManager onFinish(tutorialStep step) {
    this._finishStep = step;
    return this;
  }

  /**
   * Run through every stage of the tutorial synchronously.  First, the
   * _startStep is called if it has been defined.  Then each tutorial function
   * executes in sequence, passing a future down amongst themselves.  When the
   * final function has finished, stop() is called.
   * This function does nothing if the tutorial has already completed.  You
   * must first call reset()
   */
  Future run() {

    Completer c = new Completer();

    if (this._isComplete) {
      c.complete();
      return c.future;
    }

    Future f = null;

    if (! this._isStarted) {
      this._isStarted = true;
      if (this._startStep != null) {
        f = this._startStep(null);
      }
    }

    for (tutorialStep fn in this._steps){
      if (null == f) {
        f = fn(null);
      } else {
        f = f.then(fn);
      }
    }

    if (! this._isComplete) {
      if (null == f) {
        f = (() {
          this._isComplete = true;
          if (this._finishStep != null) {
            return this._finishStep(null);
          } else return null;
        })();
      } else {
        f = f.then((var _) {
          this._isComplete = true;
          if (this._finishStep != null) {
            return this._finishStep(null);
          } else return null;
        });
      }
    }

    if (f != null) {
      f.then((var _) => c.complete());
    } else {
      c.complete();
      f = c.future;
    }

    return f;
  }

  /**
   * Call at any time to take the tutorial to its end state and mark it
   * complete.  This function does nothing if the tutorial is already complete.
   * This is useful for skipping the tutorial.
   *
   *
   */
  Future end(var v) {

    Completer c = new Completer();

    if (this._isComplete) {
      c.complete();
      return c.future;
    }

    this._isComplete = true;

    if (null != this._finishStep) {
      c.future.then(this._finishStep);
    }

    return c.future;
  }

  Future skip(var _) {
    Completer c = new Completer();

    if (this._isComplete) {
      c.complete();
      return c.future;
    }

    Future f = null;

    if (! this._isStarted) {
      this._isStarted = true;
      if (this._startStep != null) {
        f = this._startStep(null);
      }
    }
    if (! this._isComplete) {
      if (null == f) {
        f = (() {
          this._isComplete = true;
          if (this._finishStep != null) {
            return this._finishStep(null);
          } else return null;
        })();
      } else {
        f = f.then((var _) {
          this._isComplete = true;
          if (this._finishStep != null) {
            return this._finishStep(null);
          } else return null;
        });
      }
    }

    if (f != null) {
      f.then((var _) => c.complete());
    } else {
      c.complete();
      f = c.future;
    }

    return f;
  }
}