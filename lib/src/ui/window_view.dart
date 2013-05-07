part of ui;

class WindowView extends View {

  DivElement _uiElement;
  DivElement _closeButton;
  DivElement _rootElement;

  WindowView(UI parent, this._uiElement) :
      super() {

    this._container = parent;

    this._closeButton = this._uiElement.query('div.ui.title > div.ui.x');
    this._rootElement = this._uiElement.query('div.ui.body > div.ui.root');

    this.attachCloseButton(this._closeButton);
  }

  DivElement get rootElement => this._rootElement;

  void show() {
    this._uiElement.style.display = "block";
  }

  void hide() {
    this._uiElement.style.display = "none";
  }

  void clear() {
    List<Element> toRemove = new List<Element>();
    this._rootElement.children.forEach((Element e) {
      if (null != e) {
        toRemove.add(e);
      }
    });
    for (Element e in toRemove) {
      e.remove();
    }
  }
  void onClose() {
    this.hide();
    this.clear();
  }

  void hideX() {
    this._closeButton.style.display = "none";
  }
  void showX() {
    this._closeButton.style.display = "block";
  }

  onDraw(Element root) {

    DivElement outer = new DivElement();
    outer.style.backgroundColor = '#125c9a';
    outer.style.border = '2px solid #125c9a';

    root.append(outer);
  }
}

