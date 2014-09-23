part of ui;

class View {

    Element _root;
    UIInterface _ui;

    View(this._ui, {Element root: null}) {

        if (root == null) {
            this._root = new DivElement();
        } else {
            this._root = root;
        }
    }

    void show() {
        window.console.log("showing: ${this._root.id}");
        this._root.style.display = "block";
    }

    void close(var data) {
        this._ui.closeWindow(data);
    }

    void hide() {
        this._root.style.display = "none";
    }

    void clear() {
        List<Element> toRemove = new List<Element>();
        this._root.children.forEach((Element e) {
            if (null != e) {
                toRemove.add(e);
            }
        });
        for (Element e in toRemove) {
            e.remove();
        }
    }

    void addView(View v) {
        this._root.append(v._root);
    }

    void floatElements() {
        for (Element e in this._root.children) {
            e.style.float = "left";
        }

        this.addView(new ClearView(this._ui));
    }

    DivElement _render() {
        return this._root;
    }


    // Expose some inner html functions
    // TODO: maybe encapsulate this stuff better?
    CssStyleDeclaration get style => this._root.style;
}
