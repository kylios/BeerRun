import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart';


class AsyncCounter<T> {

	Completer<T> _completer;
	int _value;

	Future<T> get future => this._completer.future;

	AsyncCounter([this._value = 0]) :
		this._completer = new Completer<T>();

	int up() => ++this._value;

	int down([T value = null]) {

		if (this._value <= 0) {
			throw new Error("value is negative!");
		}

		--this._value;
		if (this._value == 0) {
			this._completer.complete(value);
		}
	}
}



Map loadEnv(String envName) {

	String fileName = "config/${envName}.json";
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
	final parser = new ArgParser();

	if (arguments.length < 1) {
		throw new Exception("Not enough arguments supplied!");
	}

	String envName = arguments[0];
	loadEnv(envName)
		.then(prepBuildTarget)
		.then(copyWebFiles)
		.then(copyServerFiles)
		//.then(build)
		.catchError((Exception e) {
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
		.then((int code) => Process.run('mkdir', [ '-p', targetDir ]))
		.then((int code) => Process.run('mkdir', [ '-p', "$targetDir/web" ]))
		.then((int code) => Process.run('mkdir', [ '-p', "$targetDir/server" ]))
		.then((int code) => completer.complete(config))
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
		.then((ProcessResult result) => copyPackage('browser', '../web/packages', "$targetDir/web/packages"))

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

// Copies a dart package to the target directory.  No symbolic links will be created.
Future copyPackage(String packageName, String packagesDir, String targetDir) {

	AsyncCounter counter = new AsyncCounter();
	Directory src = new Directory("$packagesDir/$packageName");
	Directory dest = new Directory("$targetDir/$packageName");
	dest.create(recursive: true).then((var _) => src.list()
		.listen((FileSystemEntity obj) {
			FileSystemEntity.type(obj.path)
				.then((FileSystemEntityType type) {
					if (type == FileSystemEntityType.FILE) {
						counter.up();
						String fileName = basename(obj.path);
						obj.copy("$targetDir/$packageName/$fileName")
							.then((var _) {
								counter.down();
							});
					}
				});
		}));

	return counter.future;
}
/*
	new Directory("$targetDir/$packageName")
		.create(recursive: true)
		.then((Directory dir) => 
			Process.run('cp', [ '-R', "$packagesDir/$packageName/", "$targetDir/$packageName" ]));
*/

// Copies the server build into the target directory
Future copyServerFiles(Map config) {
	print("Copying server files...");

	String buildDir = config['compile']['build_dir'];
	String envName = config['env']['name'];
	String targetDir = "$buildDir/$envName";

	return Process.run('rsync', [ '-arv', '../server', targetDir ])
		.then((var _) => new Future.value(config));
}