library audio;

import 'dart:web_audio';
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

part 'src/audio/song.dart';
part 'src/audio/audio_manager.dart';
part 'src/audio/audio_event_listener.dart';
part 'src/audio/audio_control.dart';
part 'src/audio/audio_toggle.dart';

typedef void audioCallback(Event e);
