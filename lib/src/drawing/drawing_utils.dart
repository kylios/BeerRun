part of drawing;

class DrawingUtils {

  static List<String> wrapText(String text, int maxWidth) {

    CanvasRenderingContext2D ctx = _globalContext;

    List<String> tokens = text.split(" ");

    List<String> lines = new List<String>();

    int spaceWidth = ctx.measureText(" ").width.toInt();
    int len = 0;
    StringBuffer sb = new StringBuffer();
    for (String s in tokens) {

      int strlen = ctx.measureText(s).width.toInt();
      if (len + spaceWidth + strlen >= maxWidth) {

        String line = sb.toString();
        window.console.log(line);
        lines.add(line);
        sb = new StringBuffer();
        sb.add(s);
        len = strlen;
      } else {

        sb.add(s);
        sb.add(" ");
        len += strlen + spaceWidth;
      }
    }

    if (len > 0) {
      lines.add(sb.toString());
    }

    return lines;
  }

}

