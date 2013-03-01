library ui;

import 'dart:html';

import 'package:BeerRun/input.dart';
import 'package:BeerRun/drawing.dart';

/**
 * Ok, let's not do UI in canvas.  Let's take advantage of the fact we're on a
 * web browser and do the UI with html and css (see
 * http://stackoverflow.com/questions/6856953/does-it-make-sense-to-create-canvas-based-ui-components
 * for inspiration).
 *
 * What we need:
 * - view - something that can be drawn
 * - layout - can arrange elements and position them
 * - listener - captures events from a particular element
 *
 *
 * class Layout {
 *
 *
 * }
 *
 * class View {
 *
 *   View(View parent, /* data */ ) {
 *     // set up data
 *
 *   }
 *
 *   void draw() {
 *
 *     // create html and append to parent
 *
 *   }
 * }
 */

part 'src/ui/view.dart';
part 'src/ui/dialog.dart';
part 'src/ui/ui.dart';
part 'src/ui/nine_patch.dart';