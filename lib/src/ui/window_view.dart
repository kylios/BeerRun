part of ui;

class WindowView extends View {

  UI _parent;

  DivElement _uiElement;
  DivElement _closeButton;
  DivElement _rootElement;

  WindowView(this._parent, this._uiElement) {

    this._closeButton = this._uiElement.query('div.ui.title > div.ui.x');
    this._rootElement = this._uiElement.query('div.ui.body > div.ui.root');

    this._closeButton.onClick.listen((MouseEvent e) {
      // Call the parent UI object to handle switching control back to the game
      this._parent.closeWindow();
    });
  }

  DivElement get rootElement => this._rootElement;

  void show() {
    this._uiElement.style.display = "block";
  }

  void hide() {
    this._uiElement.style.display = "none";
  }

  void clear() {
    this._rootElement.children.forEach((Element e) {e.remove();});
  }

  onDraw(Element root) {

    DivElement outer = new DivElement();
    outer.style.backgroundColor = '#125c9a';
    outer.style.border = '2px solid #125c9a';


    root.append(outer);
  }
}

