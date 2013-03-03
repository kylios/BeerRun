part of ui;

class WindowView extends View {

  DivElement _uiElement;
  DivElement _rootElement;

  WindowView(this._uiElement) {

    this._rootElement = this._uiElement.query('div.ui.body > div.ui.root');
  }

  DivElement get rootElement => this._rootElement;

  void show() {
    this._uiElement.style.display = "block";
  }

  void hide() {
    this._uiElement.style.display = "none";
  }

  onDraw(Element root) {

    DivElement outer = new DivElement();
    outer.style.backgroundColor = '#125c9a';
    outer.style.border = '2px solid #125c9a';


    root.append(outer);
  }
}

