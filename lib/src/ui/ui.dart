part of ui;

/*
 * Requirements of a UI system for Beer Run:
 *
 * - One window at a time.
 * - Needs up to two buttons
 * - Buttons should either close window or invoke a callback
 * - Fill views with other graphics/text
 * -
 *
 * View
 * - addView
 *
 *
 * DialogView
 *   TextView
 *   View
 *     NextButton
 *     CloseButton
 *
 *
 * d = new Dialog();
 * d.addButton("next");
 * d.addButton("skip");
 *
 * window.addView(d);
 */

class UI implements UIInterface {

    WindowView _rootView;
    bool _opened = false;
    uiCallback _callback = null;
    List<UIListener> _listeners = new List<UIListener>();

    // This is to hold onto the player's input component while UI is showing
    Component _tmpInputComponent = null;

    UI(DivElement rootEl, int width, int height) {

        this._rootView = new WindowView(this, rootEl);
    }

    void addListener(UIListener listener) {
        this._listeners.add(listener);
    }

    void closeWindow(var data) {

        window.console.log("close window called");
        if (this._listeners.length > 0) {
            this._listeners.forEach((UIListener l) => l.onWindowClose(this));
        }
        this._rootView.hide();
        this._rootView.clear();
        this._opened = false;

        if (this._callback != null) {
            this._callback(data);
        }
    }

    void showView(View v, {int seconds: null, uiCallback callback: null}) {

        if (this._opened) {
            this.closeWindow(null);
        }

        if (seconds == null) {
            seconds = 0;
        }

        this._callback = callback;
        this._rootView.addView(v);
        this._rootView.show();

        if (seconds != 0) {
            new Future.delayed(new Duration(seconds: seconds), () {
                this.closeWindow(null);
            });
        } else {
            // Pause gameplay too
        }

        this._opened = true;
    }
}
