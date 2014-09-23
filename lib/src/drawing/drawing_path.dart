part of drawing;

class DrawingPath {

    List _pathComponents = new List();

    CanvasRenderingContext2D _c = null;

    String _fgColor;
    String _bgColor;
    bool _fill = false;

    DrawingPath(this._c);

    void addPoint(GamePoint p) {
        this._pathComponents.add(p);
    }
    void addCurve(GameCurve c) {
        this._pathComponents.add(c);
    }

    void setForegroundColor(String color) {
        this._fgColor = this._c.strokeStyle;
        this._c.strokeStyle = color;
    }
    void setBackgroundColor(String color) {
        this._bgColor = this._c.fillStyle;
        this._c.fillStyle = color;
    }
    void setFill(bool fill) {
        this._fill = fill;
    }
    void draw() {
        this._c.beginPath();
        window.console.log("start path");

        int lastX = -1;
        int lastY = -1;

        num lastStartAngle = -1;
        num lastEndAngle = -1;
        bool lastCounterClockwise = false;

        bool first = true;
        for (var c in this._pathComponents) {
            if (first) {
                if (c is! GamePoint) {
                    throw new Exception("first element must be a point!");
                }
                this._c.moveTo(c.x, c.y);
                lastX = c.x;
                lastY = c.y;
                first = false;
            } else {
                if (c is GamePoint && c.x != -1 && c.y != -1) {

                    if (lastStartAngle != -1 && lastEndAngle != -1) {

                        int distance = sqrt((c.x - lastX) * (c.x - lastX) + (c.y
                                - lastY) * (c.y - lastY)).toInt().abs();
                        int radius = distance ~/ 2;
                        window.console.log("distance=$distance, radius=$radius"
                                );

                        window.console.log(
                                "arc from ($lastX, $lastY) to (${c.x},${c.y}) from $lastStartAngle to $lastEndAngle, counterClockWise? ${lastCounterClockwise}"
                                );
                        this._c.arc(lastX + radius, lastY, radius,
                                lastStartAngle, lastEndAngle, lastCounterClockwise);
                    } else {
                        window.console.log("line to (${c.x},${c.y})");
                        this._c.lineTo(c.x, c.y);
                    }

                    lastStartAngle = -1;
                    lastEndAngle = -1;
                    lastX = c.x;
                    lastY = c.y;
                } else {

                    lastStartAngle = c.startAngle;
                    lastEndAngle = c.endAngle;
                    lastCounterClockwise = c.counterClockwise;
                }
            }
        }
        if (this._fill) {
            this._c.fill();
        } else {
            this._c.stroke();
        }
        this._c.closePath();
        window.console.log("end path");

        this._c.strokeStyle = this._fgColor;
        this._c.fillStyle = this._bgColor;
    }
}
