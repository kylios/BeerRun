library audio;

import 'dart:web_audio';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:beer_run/loader.dart';

part 'src/audio/song.dart';
part 'src/audio/audio_manager.dart';
part 'src/audio/audio_control.dart';
part 'src/audio/audio_track.dart';
part 'src/audio/audio_state.dart';

const AudioState off = const AudioState('off');
const AudioState on = const AudioState('on');
