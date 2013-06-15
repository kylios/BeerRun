part of level;

class TutorialDialog extends Dialog {

  TutorialManager _tutorial = null;
  Button skipButton = null;

  TutorialDialog(this._tutorial, String text) : super(text) {
    this.closeButton = new Button("Next", this.close);
    this.skipButton = new Button("Skip", () {
      this._tutorial.skip(null);
      this.close();
    });
  }

  void draw(Element root) {
    this.onDraw(root);
    this.skipButton.draw(this.rootElement);
    this.closeButton.draw(this.rootElement);
  }
}