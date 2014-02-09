part of level;

class TutorialDialog extends Dialog {

  Tutorial _tutorial = null;
  Button skipButton = null;

  TutorialDialog(UIInterface ui, this._tutorial, String text) :
      super.text(ui, text) {

    this.addButton(new Button(ui, "Next", () {
        this.close(false);
    }));
    this.addButton(new Button(ui, "Skip", () {
      this.close(true);
    }));
  }
}