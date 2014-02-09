library drawing;

import 'dart:html';
import 'dart:math';

import 'package:beer_run/canvas_manager.dart';
import 'package:beer_run/component.dart';
import 'package:beer_run/input.dart';
import 'package:beer_run/game.dart';
import 'package:beer_run/animation.dart';

part 'src/drawing/drawing_interface.dart';
part 'src/drawing/sprite.dart';
part 'src/drawing/sprite_sheet.dart';
part 'src/drawing/sprite_animation.dart';
part 'src/drawing/drawing_component.dart';
part 'src/drawing/canvas_drawer.dart';
part 'src/drawing/drawing_utils.dart';
part 'src/drawing/hud/meter.dart';
part 'src/drawing/drawing_path.dart';
part 'src/drawing/path_object.dart';

// This is ugly and I hate it
CanvasRenderingContext2D _globalContext = null;
