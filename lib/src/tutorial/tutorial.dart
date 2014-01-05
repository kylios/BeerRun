part of tutorial;

class Tutorial {

  Level _level = null;

  List<tutorialStep> _steps = new List<tutorialStep>();
  tutorialStep _onStart = null;
  tutorialStep _onStop = null;
  bool _isStarted = false;
  bool _isComplete = false;
  bool _isSkipped = false;
  Future _cur = null;

  Tutorial(this._level);

  bool get isComplete => this._isComplete;

  void addStep(tutorialStep t) {
    this._steps.add(t);
  }

  Tutorial onStart(int row, int col) {

    tutorialStep fn = (var _) {
      Completer c = new Completer();
      window.console.log("starting at (${this._level.startX}, ${this._level.startY})");

      this._level.player.setPos(
          col * this._level.tileWidth,
          row * this._level.tileHeight);

      int halfWidth = this._level.canvasManager.width ~/ 2;
      int halfHeight = this._level.canvasManager.height ~/ 2;

      this._level.canvasDrawer.setOffset(
          col * this._level.tileWidth - halfWidth + this._level.player.tileWidth,
          row * this._level.tileHeight - halfHeight + this._level.player.tileHeight);

      Timer.run(() => c.complete());

      return c.future;
    };

    this._onStart = fn;
    return this;
  }
  Tutorial onStop(int row, int col) {

    tutorialStep fn = (var _) {

      int halfWidth = this._level.canvasManager.width ~/ 2;
      int halfHeight = this._level.canvasManager.height ~/ 2;

      this._level.canvasDrawer.setOffset(
          col * this._level.tileWidth - halfWidth + this._level.player.tileWidth,
          row * this._level.tileHeight - halfHeight + this._level.player.tileHeight
      );
    };

    this._onStop = fn;
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

    if (this._onStart == null &&
        this._onStop == null &&
        this._steps.length == 0) {
      this._isStarted = true;
      Timer.run(() {
        this._isComplete = true;
        c.complete(null);
      });
      return c.future;
    }

    if (this._isComplete) {
      c.complete();
      return c.future;
    }

    Future f = null;

    if (! this._isStarted) {
      this._isStarted = true;
      if (this._onStart != null) {
        f = this._onStart(null);
      }
    }

    for (tutorialStep fn in this._steps){
      if (null == f) {
        f = fn(null);
      } else {
        f = f.then((var _) {
          if (! this._isSkipped) {
            this._cur = fn(null);
          }
          return this._cur;
        });
      }
    }

    if (! this._isComplete) {
      if (null == f) {
        f = (() {
          this._isComplete = true;
          if (this._onStop != null) {
            return this._onStop(null);
          } else return null;
        })();
      } else {
        f = f.then((var _) {
          this._isComplete = true;
          if (this._onStop != null) {
            return this._onStop(null);
          } else return null;
        });
      }
    }

    if (f != null) {
      f.then((var _) {
        this._isSkipped = false;
        c.complete();
      });
    } else {
      this._isSkipped = false;
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

    if (null != this._onStop) {
      c.future.then(this._onStop);
    }

    return c.future;
  }

  Tutorial skip() {
    this._isSkipped = true;
    return this;
  }

  // Some useful scripting functions maybe?
  Tutorial addPan(int targetRow, int targetCol, int speed) {
    tutorialStep fn = (var _) {
      Completer c = new Completer();
      int halfWidth = this._level.canvasManager.width ~/ 2;
      int halfHeight = this._level.canvasManager.height ~/ 2;

      int tutorialDestX = targetCol * this._level.tileWidth - halfWidth + this._level.player.tileWidth;
      int tutorialDestY = targetRow * this._level.tileHeight - halfHeight + this._level.player.tileHeight;
      Timer _t = new Timer.periodic(new Duration(milliseconds: 20), (Timer t) {

        int offsetX = this._level.canvasDrawer.offsetX;
        int offsetY = this._level.canvasDrawer.offsetY;

        int moveX;
        if (tutorialDestX < offsetX) {
          moveX = max(-speed, tutorialDestX - offsetX);
        } else {
          moveX = min(speed, tutorialDestX - offsetX);
        }
        int moveY;
        if (tutorialDestY < offsetY) {
          moveY = max(-speed, tutorialDestY - offsetY);
        } else {
          moveY = min(speed, tutorialDestY - offsetY);
        }

        // Move the viewport closer to the beer store
        this._level.canvasDrawer.moveOffset(moveX, moveY);

        this._level.canvasDrawer.clear();
        this._level.draw(this._level.canvasDrawer);

        window.console.log("X: $offsetX -> $tutorialDestX, Y: $offsetY -> $tutorialDestY");
        if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
          t.cancel();
          c.complete();
        }
      });

      return c.future;
    };

    this.addStep(fn);

    return this;
  }

  Tutorial addDialog(String message) {
    tutorialStep fn = (var _) {
      Completer c = new Completer();

      GameManager mgr = new GameManager();

      mgr.ui.showView(
          new TutorialDialog(mgr.ui, this, message),
          callback: () { c.complete(); }
      );
      return c.future;
    };

    this.addStep(fn);
    return this;
  }
}
