library tutorial;

import 'dart:html';
import 'dart:async';
import 'dart:math';

import 'package:beer_run/game.dart';
import 'package:beer_run/level.dart';
import 'package:beer_run/ui.dart';
import 'package:beer_run/component.dart';

part 'src/tutorial/tutorial.dart';
part 'src/tutorial/tutorial_dialog.dart';
part 'src/tutorial/controls_screen.dart';
part 'src/tutorial/tutorial_control_component.dart';

typedef Future tutorialStep(var _);
