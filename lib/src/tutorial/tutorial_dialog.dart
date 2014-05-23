part of tutorial;

class TutorialDialog extends Dialog {

  Tutorial _tutorial = null;
  Button skipButton = null;

  TutorialDialog(UIInterface ui, this._tutorial, String text, Map<String, dynamic> vars) :
      super.text(ui, text, vars)
  {
      this._init(ui);
  }

  void _init(UIInterface ui) {

    this.addButton(new Button(ui, "Next", () {
        this.close(false);
    }));
    this.addButton(new Button(ui, "Skip", () {
      this.close(true);
    }));
  }
}