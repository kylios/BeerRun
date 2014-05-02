part of ui;

class Dialog extends View {

  DivElement _rootElement = null;

  View _buttons;

  /**
   * Instantiate a dialog with another view in the body.
   */
  Dialog(UIInterface ui, View v) : this._internal(ui, v);

  /**
   * Instantiate a dialog with a string of text in the body.
   */
  Dialog.text(UIInterface ui, String text) :
    this._internal(ui, new TextView(ui, text));

  /**
   * Internal constructor of class Dialog.
   */
  Dialog._internal(UIInterface ui, View v) : super(ui) {

    this._buttons = new View(ui);
    View clear = new View(ui);

    this._buttons.style.float = "left";
    v.style.float = "left";
    clear.style.clear = "both";

    this.addView(v);
    this.addView(this._buttons);
    this.addView(clear);
  }

  void addButton(Button b) => this._buttons.addView(b);
}