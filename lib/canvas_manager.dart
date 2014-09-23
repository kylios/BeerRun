library canvas_manager;

import 'dart:html';

import 'package:beer_run/input.dart';

class CanvasManager {

    CanvasElement _canvas;

    int _width;
    int _height;

    CanvasManager(this._canvas);

    int get width => this._width;
    int get height => this._height;
    CanvasElement get canvas => this._canvas;

    void resize(int width, int height) {

        this._width = width;
        this._height = height;

        // Set the canvas size.
        // Note: if the style and attributes don't match, the canvas will not be
        //  scaled 1:1 and will look funny.
        this._canvas.style.width = "${this._width.toString()}px";
        this._canvas.style.height = "${this._height.toString()}px";

        this._canvas.attributes['width'] = this._width.toString();
        this._canvas.attributes['height'] = this._height.toString();

    }

    void addKeyboardListener(KeyboardListener l) {

        document.onKeyDown.listen(l.onKeyDown);
        document.onKeyUp.listen(l.onKeyUp);
        document.onKeyPress.listen(l.onKeyPressed);
    }
}
