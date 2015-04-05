#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart';

void main(List<String> arguments) {
	final parser = new ArgParser();

	if (arguments.length < 1) {
		throw new Exception("Not enough arguments supplied!");
	}

	String envName = arguments[0];
	loadEnv(envName)
		.then(copyFiles)
		.catchError((Exception e) {
			print(e);
		})
		;
}


Future<Map> loadEnv(String envName) {

	String fileName = "../config/${envName}.json";
	print("Loading config $envName at $fileName");

	Stream<List<int>> fileStream = new File(fileName).openRead();
	String configString = "";
	Map config;
	Completer<Map> completer = new Completer<Map>();
	fileStream
		.transform(new Utf8Decoder())
		.transform(JSON.decoder)
		.single
		.then((Map data) {
			if (null == data['env']) {
				data['env'] = new Map();
			}
			data['env']['name'] = envName;
			completer.complete(data);
		});

	return completer.future;
}

Future<Map> copyFiles(Map config) {

	String sshUser = config['deploy']['ssh']['user'];
	String sshHost = config['deploy']['ssh']['host'];
	String sshKeyFile = config['deploy']['ssh']['key_file'];
	String remoteDir = config['deploy']['remote_dir'];
	bool verbose = config['deploy']['verbose'];

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";
	List<String> cfgFilesToCopy = config['deploy']['files_to_copy'];

	List<String> scpArgs = [ '-o', 'StrictHostKeyChecking=no', '-i', sshKeyFile, '-r' ];
	for (String file in cfgFilesToCopy) {
		scpArgs.add("$targetDir/$file");
	}
	scpArgs.addAll([ "$sshUser@$sshHost:$remoteDir/" ]);

	Completer<Map> completer = new Completer<Map>();

	print("scp $scpArgs");

	// scp -i $AWSDIR/keypairs/webserver.pem -r ../build/!(release*) ubuntu@beerrungame.net:/home/ubuntu/releases/latest/
	Process.start('scp', scpArgs)
		.then((Process p) {
			stderr.addStream(p.stderr)/*
				.transform(new Utf8Decoder())
				.listen((String data) {
					print("ERROR: $data");
				})*/;
			stdout.addStream(p.stdout)/*
				.transform(new Utf8Decoder())
				.listen((String data) {
					print(data);
				})*/;
			p.exitCode.then((int exitCode) {
				if (exitCode != 0) {
					throw new Exception("Copy failed");
				}
				completer.complete(config);
			});
		});

	return completer.future;
}