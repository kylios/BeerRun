import 'dart:html';

import 'dart:async';

import 'package:beer_run/loader.dart';
	
Loader l = new Loader("dev-local.beer_run");

Map<String, Map> assets = new Map<String, Map>();
Completer c = new Completer();
int loadCount = 0;

Future<Resource> loadedCallback(Resource res) {

	if (--loadCount == 0) {
		c.complete();
	}

	return c.future;
}

void main(List<String> args) {

	CdnLoader cdnLoader = new CdnLoader([ 
		  'static1.dev-local.beer_run' 
		, 'static2.dev-local.beer_run'
		, 'static3.dev-local.beer_run'
		, 'static4.dev-local.beer_run'
		], 1);
	cdnLoader.loadManifest().then((var _) => window.alert("done done done"));
}