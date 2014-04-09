import 'dart:html';

import 'package:beer_run/loader.dart';

void main(List<String> args) {
	
	Loader l = new Loader("dev-local.beer_run");

	l.load("/beer_run.dart", (Resource resource) {
		window.alert(resource.response);
	});
}