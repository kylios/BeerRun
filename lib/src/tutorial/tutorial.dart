part of tutorial;

class Tutorial {

    Level _level = null;

    List<tutorialStep> _steps = new List<tutorialStep>();
    tutorialStep _onStart = null;
    tutorialStep _onStop = null;
    bool _isStarted = false;
    bool _isComplete = false;
    Future _cur = null;

    bool get isComplete => this._isComplete;

    Tutorial(this._level);

    Tutorial.fromJson(Map tutorialData, this._level) {

        this._decodeTutorialData(tutorialData);
    }

    void addStep(tutorialStep t) {
        this._steps.add(t);
    }

    Tutorial onStart(tutorialStep fn) {
        this._onStart = fn;
    }

    Tutorial onStop(tutorialStep fn) {
        this._onStop = fn;
    }

    tutorialStep start(int row, int col) {

        tutorialStep fn = (var _) {
            Completer c = new Completer();
            window.console.log(
                    "starting at (${this._level.startX}, ${this._level.startY})");

            /*
      this._level.player.setPos(
          col * this._level.tileWidth,
          row * this._level.tileHeight);
      */

            int halfWidth = this._level.canvasManager.width ~/ 2;
            int halfHeight = this._level.canvasManager.height ~/ 2;

            window.console.log(
                    "Tutorial:start (setting offset): col=$col, row=$row, tileWidth=${this._level.tileWidth}, tileHeight=${this._level.tileHeight}, halfWidth=${halfWidth}, halfHeight=${halfHeight}, playerTileWidth=${this._level.player.tileWidth}, playerTileHeight=${this._level.player.tileHeight}"
                    );

            this._level.canvasDrawer.setOffset(col * this._level.tileWidth -
                    halfWidth + this._level.player.tileWidth, row * this._level.tileHeight -
                    halfHeight + this._level.player.tileHeight);

            Timer.run(() => c.complete(false));

            return c.future;
        };

        return fn;
    }
    tutorialStep stop(int row, int col) {

        tutorialStep fn = (var _) {

            int halfWidth = this._level.canvasManager.width ~/ 2;
            int halfHeight = this._level.canvasManager.height ~/ 2;

            this._level.canvasDrawer.setOffset(col * this._level.tileWidth -
                    halfWidth + this._level.player.tileWidth, row * this._level.tileHeight -
                    halfHeight + this._level.player.tileHeight);
        };

        return fn;
    }

    void _onStartInternal() {
        this._level.draw(this._level.canvasDrawer);
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

        Completer<bool> c = new Completer<bool>();

        this._onStartInternal();

        if (this._onStart == null && this._onStop == null) {
            this._isStarted = true;
            Timer.run(() {
                this._isComplete = true;
                c.complete(false);
            });
            return c.future;
        }

        if (this._isComplete) {
            Timer.run(() => c.complete(false));
            return c.future;
        }

        Future f = null;

        if (!this._isStarted) {
            this._isStarted = true;
            if (this._onStart != null) {
                f = this._onStart(null);
            }
        }

        for (tutorialStep fn in this._steps) {
            if (null == f) {
                f = fn(null);
            } else {
                f = f.then((bool skipped) {
                    if (!skipped) {
                        this._cur = fn(skipped);
                    }
                    return this._cur;
                });
            }
        }

        if (!this._isComplete) {
            if (null == f) {
                f = (() {
                    this._isComplete = true;
                    if (this._onStop != null) {
                        return this._onStop(null);
                    } else {
                        return null;
                    }
                })();
            } else {
                f = f.then((var _) {
                    this._isComplete = true;
                    if (this._onStop != null) {
                        return this._onStop(null);
                    } else {
                        return null;
                    }
                });
            }
        }

        if (f != null) {
            f.then((var _) {
                c.complete(false);
            });
        } else {
            c.complete(false);
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

        Completer<bool> c = new Completer<bool>();

        if (this._isComplete) {
            c.complete(false);
            return c.future;
        }

        this._isComplete = true;

        if (null != this._onStop) {
            c.future.then(this._onStop);
        }

        this._isStarted = false;
        this._isComplete = false;

        return c.future;
    }

    // Some useful scripting functions maybe?
    tutorialStep pan(int targetRow, int targetCol, int speed) {
        tutorialStep fn = (var _) {
            Completer<bool> c = new Completer<bool>();
            int halfWidth = this._level.canvasManager.width ~/ 2;
            int halfHeight = this._level.canvasManager.height ~/ 2;

            int tutorialDestX = targetCol * this._level.tileWidth - halfWidth +
                    this._level.player.tileWidth;
            int tutorialDestY = targetRow * this._level.tileHeight - halfHeight
                    + this._level.player.tileHeight;
            Timer _t = new Timer.periodic(new Duration(milliseconds: 20), (Timer
                    t) {

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

                window.console.log(
                        "X: $offsetX -> $tutorialDestX, Y: $offsetY -> $tutorialDestY");
                if (offsetX == tutorialDestX && offsetY == tutorialDestY) {
                    t.cancel();
                    c.complete(false);
                }
            });

            return c.future;
        };

        return fn;
    }

    tutorialStep dialog(String message, Map<String, String> stepVars) {

        Map<String, dynamic> vars = new Map<String, dynamic>();
        if (stepVars != null) {
            stepVars.keys.forEach((String k) => vars[k] =
                    this._level.vars[stepVars[k]]);
        }

        tutorialStep fn = (var _) {
            Completer<bool> c = new Completer<bool>();

            GameManager mgr = new GameManager();

            mgr.ui.showView(new TutorialDialog(mgr.ui, this, message, vars),
                    callback: (var skipped) {
                c.complete(skipped);
            });
            return c.future;
        };

        return fn;
    }

    tutorialStep controls() {
        tutorialStep fn = (var _) {
            Completer<bool> c = new Completer<bool>();

            GameManager mgr = new GameManager();

            mgr.ui.showView(new ControlsScreen(mgr.ui, this), callback: (var
                    skipped) {
                c.complete(skipped);
            });

            return c.future;
        };

        return fn;
    }



    void _decodeTutorialData(Map tutorialData) {

        Map startData = tutorialData['begin'];
        Map endData = tutorialData['end'];
        List<Map> bodyData = tutorialData['body'];

        if (startData != null) {
            this.onStart(this._decodeTutorialFuncData(startData));
        }
        for (Map tutorialStepData in bodyData) {
            this.addStep(this._decodeTutorialFuncData(tutorialStepData));
        }
        if (endData != null) {
            this.onStop(this._decodeTutorialFuncData(endData));
        }
    }

    tutorialStep _decodeTutorialFuncData(Map data) {
        if (data['type'] == 'begin') {
            return this.start(data['row'], data['col']);
        } else if (data['type'] == 'end') {
            return this.stop(data['row'], data['col']);
        } else if (data['type'] == 'camera_pan') {
            return this.pan(data['row'], data['col'], data['speed']);
        } else if (data['type'] == 'dialog') {
            return this.dialog(data['body'], data['vars']);
        } else if (data['type'] == 'controls') {
            return this.controls();
        }

        throw new Exception("Type ${data['type']} not supported in the tutorial"
                );

    }
}
