import 'dart:html';

import 'dart:async';

import 'package:beer_run/loader.dart';
import 'package:beer_run/async_extended.dart';
	
Loader l = new Loader("dev-local.beer_run");

Map<String, Map> assets = new Map<String, Map>();
Completer c = new Completer();
int loadCount = 0;

Synchronizer<Resource> s = new Synchronizer<Resource>();

Future<Resource> loadedCallback(Resource res) {

	if (--loadCount == 0) {
		c.complete();
	}

	return c.future;
}

Future<Resource> loadManifestAssets(Resource resource) {

	return Future.forEach(resource.response['assets'], (Map res) => l.load(new JsonResource(res['uri'])));
}

void main(List<String> args) {

	JsonResource manifestResource = new JsonResource("/assets/manifest.json");
	l.load(manifestResource)
		.then(loadManifestAssets)
		.then((var _) => window.alert("all done! [3]"))
		;


/*
	s 	.add(l.load)
		.chain((Resource resource) {
			for (Map res in resource.response['assets']) {
				s 	.add((var _) => l.load(new JsonResource(res['uri'])))
					.chain(loadedCallback);
			}
		})
		.wait()
		.then((var _) =>
			s 	.add((var _) => window.alert("all done! [2]")
				.wait())
		);
*/

	/*
	l.load(manifestResource).then((Resource resource) {
		for (Map res in resource.response['assets']) {
			loadCount++;
			window.alert(loadCount.toString());
			l.load(new JsonResource(res['uri']))
				.then(loadedCallback);
		}
	});

	c.future.then((var _) {
		window.alert("all done!");
	});
	*/
}