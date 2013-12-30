library tutorial;

import 'dart:html';
import 'dart:async';
import 'dart:math';

import 'package:beer_run/game.dart';
import 'package:beer_run/level.dart';
import 'package:beer_run/drawing.dart';

part 'src/tutorial/tutorial_manager.dart';
part 'src/tutorial/tutorial.dart';

typedef Future tutorialStep(var _);

