part of ui;

class ImageView extends View {

  ImageView.fromSrc(UIInterface ui, String src, int width, int height) :
      super(ui, root: new ImageElement(src: src, width: width, height: height));
}