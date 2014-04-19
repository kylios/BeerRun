library loader;

import 'dart:html';
import 'dart:async';
import 'dart:convert';

part 'src/loader/loader.dart';
part 'src/loader/cdn_loader.dart';
part 'src/loader/resource.dart';
part 'src/loader/json_resource.dart';
//part 'src/loader/audio_resource.dart';

typedef Future loaderCallback(Resource resource);


/*
Loader loader = new Loader(cdnUrl);

loader.load(new JsonResource(uri: manifestUri, callback: manifestLoadedCallback));



void manifestLoadedCallback(JsonResource resource) {


}
*/