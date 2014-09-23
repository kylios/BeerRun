part of ui;

class TextView extends View {

    String _text;
    var _variables;

    TextView(UIInterface ui, this._text, [Map<String, dynamic> vars = null]) :
            super(ui, root: new DivElement()) {
        if (vars != null && vars.keys.length > 0) {
            this._variables = vars;
        } else {
            this._variables = new Map<String, dynamic>();
        }
    }

    Map<String, dynamic> get vars => this._variables;

    void evaluateVars() {

        // Substitute vars in text for vars in our object.  Look for ${varName}
        for (String k in this.vars.keys) {
            var v = this.vars[k];
            this._text = this._text.replaceAll("_$k", v.toString());
        }

        this._root.innerHtml = this._text;
    }
}
