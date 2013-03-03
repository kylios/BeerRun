part of ui;

class WindowView extends View {

  WindowView();

  onDraw(Element root) {

    DivElement outer = new DivElement();
    outer.style.backgroundColor = '#125c9a';
    outer.style.border = '2px solid #125c9a';


    root.append(outer);
  }
}

