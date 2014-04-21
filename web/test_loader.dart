import 'dart:html';

import 'dart:async';
import 'dart:convert';

import 'package:beer_run/game.dart';
import 'package:beer_run/loader.dart';


void main(List<String> args) {

	Map configData = JSON.decode(querySelector('div#config').innerHtml);
    GameConfig config = new GameConfig(configData);
    Map applicationConfig = config.get('application');

	CdnLoader cdnLoader = new CdnLoader(applicationConfig['assets']['cdn_hosts'], 1);
	cdnLoader.loadManifest().then((var _) => window.alert("done done done"));
}