#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart';

const SKIP_COMPILE = 'skip-compile';

class AsyncCounter<T> {

	Completer<T> _completer;
	int _value;

	Future<T> get future => this._completer.future;

	AsyncCounter([this._value = 0]) :
		this._completer = new Completer<T>();

	int up() => ++this._value;

	int down([T value = null]) {

		if (this._value <= 0) {
			throw new Exception("value is negative!");
		}

		--this._value;
		if (this._value == 0) {
			this._completer.complete(value);
		}
		
		return this._value;
	}
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

void main(List<String> arguments) {
	final parser = new ArgParser()
      ..addFlag(SKIP_COMPILE, negatable: false, abbr: 's');

	if (arguments.length < 1) {
		throw new Exception("Not enough arguments supplied!");
	}

	ArgResults results = parser.parse(arguments);

	bool skipCompile = results[SKIP_COMPILE];

	String envName = arguments[arguments.length - 1];
	Future f = loadEnv(envName)
		.then(prepBuildTarget)
		.then(copyWebFiles)
		.then(copyServerFiles)
		.then(copyConfigFiles);
	if ( ! skipCompile) {
		f = f.then(build);
	}
	f = f.catchError((Exception e) {
			print(e);
		})
		;


}

Future<Map> prepBuildTarget(Map config) {

	//print(config);

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";

	Completer<Map> completer = new Completer<Map>();

	Directory buildDirObj = new Directory(buildDir);
	buildDirObj.exists()
		.then((bool exists) {
			if (! exists) {
				return buildDirObj.create();
			}
			return new Future.value();
		})
		.then((var _) => Process.run("rm", [ '-rf', targetDir ]))
		.then((ProcessResult result) => Process.run('mkdir', [ '-p', targetDir ]))
		.then((ProcessResult result) => Process.run('mkdir', [ '-p', "$targetDir/web" ]))
		.then((ProcessResult result) => Process.run('mkdir', [ '-p', "$targetDir/server" ]))
		.then((ProcessResult result) => completer.complete(config))
		;

	return completer.future;
}

Future<Map> build(Map config) {

	List processArgs = new List();

	print("Building app...");

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";
	String outFile = config['compile']['out_file'];
	String inFile = config['compile']['in_file'];
	processArgs.add("--out=$targetDir/$outFile");

	if (config['compile']['checked']) {
		processArgs.add('--checked');
	}
	if (config['compile']['warnings']) {
		processArgs.add('--show-package-warnings');
	}
	if (config['compile']['minify']) {
		processArgs.add('--minify');
	}

	processArgs.add(inFile);

	return Process.start('dart2js', processArgs)
		.then((Process p) {
			p.stderr
				.transform(new Utf8Decoder())
				.listen((String data) {
					print("ERROR: $data");
				});
			p.stdout
				.transform(new Utf8Decoder())
				.listen((String data) {
					print(data);
				});
			p.exitCode.then((int exitCode) {
				if (exitCode != 0) {
					throw new Exception('Compilation failed');
				}
				return new Future.value(config);
			});
		});
}

// Copies all web files into the target directory.
Future copyWebFiles(Map config) {
	print("Copying web files...");

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";

	return

		// Copy the files
		Process.run('rsync', [ '-arv', '../web', targetDir ])

		// find and kill symlinks
		.then((ProcessResult result) => killSymlinks("$targetDir/web"))

		// Copy packages over as real directories
		.then((var _) => copyPackage('browser', '../web/packages', "$targetDir/web/packages"))
		.then((var _) => copyPackage('beer_run', '../web/packages', "$targetDir/web/packages"))
		.then((var _) => copyPackage('intl', '../web/packages', "$targetDir/web/packages"))

		// Return the config
		.then((var _) => new Future.value(config));
}

// Find and delete all symbolic links in the target directory
Future killSymlinks(String dir) =>
	Process.start('find', [ '-P', dir, '-type', 'l', '-print0' ])
		.then((Process find) => Process.start('xargs', [ '-0', 'rm' ])
			.then((Process xargs) {
				find.stdout.pipe(xargs.stdin);
				return xargs.exitCode.then((var _) => new Future.value());
			}));

Future<StreamSubscription<FileSystemEntity>> _copyDir(Directory src, Directory dest, AsyncCounter counter) {
	counter.up();

	Completer<StreamSubscription<FileSystemEntity>> c = new Completer<StreamSubscription<FileSystemEntity>>();

	src.list()
        .listen((FileSystemEntity obj) {
            counter.up();
            FileSystemEntity.type(obj.path)
                .then((FileSystemEntityType type) {
                    String fileName = basename(obj.path);
                    if (type == FileSystemEntityType.FILE) {
                        counter.up();
                        obj.copy("${dest.path}/${fileName}")
                            .then((var _) {
                                counter.down();
                            });
                    } else if (type == FileSystemEntityType.DIRECTORY) {
                        Directory d = new Directory("${dest.path}/${fileName}");
                        counter.up();
                        d.create(recursive: true).then((Directory d) {
                            _copyDir(obj, d, counter);
                            counter.down();
                        });
                    }
                    counter.down();
                });
        },
        onDone: counter.down
    );


	return c.future;


}


// Copies a dart package to the target directory.  No symbolic links will be created.
Future copyPackage(String packageName, String packagesDir, String targetDir) {

	AsyncCounter counter = new AsyncCounter();
	Directory src = new Directory("$packagesDir/$packageName");
	Directory dest = new Directory("$targetDir/$packageName");
	dest.create(recursive: true).then((var _) => _copyDir(src, dest, counter));

	return counter.future;
}

// Copies the server build into the target directory
Future copyServerFiles(Map config) {
	print("Copying server files...");

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";

	return Process.run('rsync', [ '-arv', '../server', targetDir ])
		.then((var _) => new Future.value(config));
}

// Copies the config files into the target directory
Future copyConfigFiles(Map config) {
	print("Copying config files...");

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";

	return Process.run('rsync', [ '-arv', '../config', targetDir ])
		.then((var _) => new Future.value(config));
}