#!/usr/bin/env dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart';

// arguments
const SKIP_COMPILE = 'skip-compile';
const HELP = 'help';

/**
 * Exception class that automatically prints out the default help message after
 * printing a custom message.
 * */
class HelpException implements Exception {

    static final String _HELP_TEXT =
            """
build.dart <environment>

Parameters:
  - environment: specify the build and runtime environment for the build 
    artifact.

See README.md for more information.
  """;

    String _cause;
    HelpException([this._cause = ""]);

    String toString() => this._cause + "\n" + _HELP_TEXT;
}

/**
 * This class counts asynchronous operations and completes a future when all
 * the operations have completed.
 *
 * Ex.
 *
 * AsyncCounter<int> counter = new AsyncCounter<int>();
 * counter.future.then(print);
 *
 * // start expensive task
 * counter.up();
 * expensiveTask1().then(counter.down);
 *
 * // expensive task
 * counter.up();
 * expensiveTask2().then(counter.down);
 *
 * // When both expensiveTask1 and expensiveTask2 have completed, the result
 * // of expensiveTask2 will be printed because of the callback on the counter's
 * // future.
 * */
class AsyncCounter<T> {

    Completer<T> _completer;
    int _value;

    Future<T> get future => this._completer.future;

    AsyncCounter([this._value = 0]) : this._completer = new Completer<T>();

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

void log(String message) {
    print("  * $message");
}

/**
 * A class to store all the allowed options for the build script.
 * */
class BuildOptions {

    final bool skipCompile;
    final String appEnv;

    BuildOptions(this.appEnv, this.skipCompile);

    /**
     * Configure a parser to look for the right options.
     * */
    static void configureParser(ArgParser parser) {
        parser
            ..addFlag(SKIP_COMPILE, negatable: false, abbr: 's')
            ..addFlag(HELP, abbr: "h");
    }
}

class BuildContext {

    final BuildOptions options;
    final Map config;

    BuildContext(this.options, this.config);
}

void handleHelpException(HelpException ex) {
    print(ex);
}

void handleFileSystemException(FileSystemException ex) {
    print("""
        File not found: ${ex.path}");
""");
}

dynamic handleGeneralException(e) {

    print("""

    Exception:
      Class: ${e.runtimeType}
      Message: 
""");
    throw e;
}

void main(List<String> arguments) {

    print("\nBuilding dart application...\n");

    // arguments is all we have, start the pipeline with that
    parseOptions(arguments)         // returns a BuildOptions
        .then(loadEnv)              // returns a BuildContext
        .then(prepBuildTarget)      // returns a BuildContext
        .then(copyWebFiles)
        .then(copyServerFiles)
        .then(copyConfigFiles)
        .then(build)
        .catchError(handleHelpException, test: (e) => e is HelpException)
        .catchError(handleGeneralException)
        .catchError(handleFileSystemException, test: (e) => e is FileSystemException)
        .catchError(() {})
        .whenComplete(() => print(""));
}

/**
 * Parses the command line options using an ArgParser that's configured by the
 * caller.
 * */
Future<BuildOptions> parseOptions(List<String> arguments) {

    return new Future<BuildOptions>.sync(() {
        if (arguments.length < 1) {
            throw new HelpException("Not enough arguments supplied!");
        }

        ArgParser parser = new ArgParser();
        BuildOptions.configureParser(parser);
        ArgResults results = parser.parse(arguments);

        if (results[HELP] != null && results[HELP]) {
            throw new HelpException();
        }

        bool skipCompile = results[SKIP_COMPILE];
        String appEnv = arguments.last;

        return new BuildOptions(appEnv, skipCompile);
    });
}



Future<BuildContext> loadEnv(BuildOptions options) {

    BuildContext _createBuildContext(Map config) {
        BuildContext context = new BuildContext(options, config);
        return context;
    }

    return new Future<BuildContext>.sync(() {
        String appEnv = options.appEnv;
        String fileName = "../config/${appEnv}.json";
        log("Loading config '$appEnv' at '$fileName'");

        Stream<List<int>> fileStream = new File(fileName).openRead();
        String configString = "";
        Map config;

        // Parses the json config
        return fileStream
                .transform(new Utf8Decoder())
                .transform(JSON.decoder)
                .single
                .then(_createBuildContext);
    });
}

Future<BuildContext> prepBuildTarget(BuildContext context) {

    //print(config);
    return new Future<BuildContext>.sync(() {

        String buildDir = context.config['compile']['build_dir'];
        String envName = context.options.appEnv;
        String targetDir = "../$buildDir/$envName";

        Completer<Map> completer = new Completer<Map>();

        log("preparing build target");
        Directory buildDirObj = new Directory(buildDir);
        buildDirObj
            .exists()
            .then((bool exists) {
                if (!exists) {
                    return buildDirObj.create();
                }
                return new Future.value();
            })
            .then((var _) => Process.run("rm", ['-rf', targetDir]))
            .then((ProcessResult result) => Process.run('mkdir', ['-p', targetDir]))
            .then((ProcessResult result) => Process.run('mkdir', ['-p', "$targetDir/web"]))
            .then((ProcessResult result) => Process.run('mkdir', ['-p', "$targetDir/server"]))
            .then((ProcessResult result) => completer.complete(context));

        return completer.future;
    });
}

// Copies all web files into the target directory.
Future<BuildContext> copyWebFiles(BuildContext context) {

    return new Future<BuildContext>.sync(() {
        log("Copying web files...");

        String buildDir = context.config['compile']['build_dir'];
        String envName = context.options.appEnv;
        String targetDir = "../$buildDir/$envName";

        return // Copy the files
        Process.run('rsync', ['-arv', '../web', targetDir])// find and kill symlinks
                .then((ProcessResult result) => killSymlinks("$targetDir/web"))// Copy packages over as real directories
                .then((var _) => copyPackage('browser', '../web/packages', "$targetDir/web/packages"))
                .then((var _) => copyPackage('beer_run', '../web/packages', "$targetDir/web/packages"))
                .then((var _) => copyPackage('intl', '../web/packages', "$targetDir/web/packages"))
                .then((var _) => new Future.value(context));
    });
}

// Copies the server build into the target directory
Future<BuildContext> copyServerFiles(BuildContext context) {

    return new Future<BuildContext>.sync(() {
        log("Copying server files...");

        String buildDir = context.config['compile']['build_dir'];
        String envName = context.options.appEnv;
        String targetDir = "../$buildDir/$envName";

        return Process
                .run('rsync', ['-arv', '../server', targetDir])
                .then((var _) => new Future.value(context));
    });
}

// Copies the config files into the target directory
Future<BuildContext> copyConfigFiles(BuildContext context) {
    return new Future<BuildContext>.sync(() {
        log("Copying config files...");

        String buildDir = context.config['compile']['build_dir'];
        String envName = context.options.appEnv;
        String targetDir = "../$buildDir/$envName";

        return Process
                .run('rsync', ['-arv', '../config', targetDir])
                .then((var _) => new Future.value(context));
    });
}

/**
 * Build the dart source code into javascript.
 * */
Future<BuildContext> build(BuildContext context) {

    return new Future<BuildContext>.sync(() {

        if (context.options.skipCompile) {
            return new Future<BuildContext>.value(context);
        }

        List processArgs = new List();

        log("Building app...");

        String buildDir = context.config['compile']['build_dir'];
        String envName = context.options.appEnv;
        String targetDir = "../$buildDir/$envName";
        String outFile = context.config['compile']['out_file'];
        String inFile = context.config['compile']['in_file'];
        processArgs.add("--out=$targetDir/$outFile");

        if (context.config['compile']['checked']) {
            processArgs.add('--checked');
        }
        if (context.config['compile']['warnings']) {
            processArgs.add('--show-package-warnings');
        }
        if (context.config['compile']['minify']) {
            processArgs.add('--minify');
        }

        processArgs.add(inFile);

        return Process
                .start('dart2js', processArgs)
                .then((Process p) {
                    p.stderr.transform(new Utf8Decoder()).listen((String data) {
                        print("ERROR: $data");
                    });
                    p.stdout.transform(new Utf8Decoder()).listen((String data) {
                        print(data);
                    });
                    p.exitCode.then((int exitCode) {
                        if (exitCode != 0) {
                            throw new Exception('Compilation failed');
                        }
                        return new Future.value(context);
                    });
                });
    });
}

// Find and delete all symbolic links in the target directory
Future killSymlinks(String dir) =>
        Process
            .start('find', ['-P', dir, '-type', 'l', '-print0'])
            .then((Process find) =>
                    Process
                        .start('xargs', ['-0', 'rm'])
                        .then((Process xargs) {
                            find.stdout.pipe(xargs.stdin);
                            return xargs.exitCode
                                    .then((var _) => new Future.value());
                        })
                  );

Future<StreamSubscription<FileSystemEntity>> _copyDir(Directory src, Directory
        dest, AsyncCounter counter) {
    counter.up();

    Completer<StreamSubscription<FileSystemEntity>> c =
            new Completer<StreamSubscription<FileSystemEntity>>();

    src.list().listen((FileSystemEntity obj) {
        counter.up();
        FileSystemEntity.type(obj.path).then((FileSystemEntityType type) {
            String fileName = basename(obj.path);
            if (type == FileSystemEntityType.FILE) {
                counter.up();
                obj.copy("${dest.path}/${fileName}").then((var _) {
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
    }, onDone: counter.down);


    return c.future;


}


// Copies a dart package to the target directory.  No symbolic links will be created.
Future copyPackage(String packageName, String packagesDir, String targetDir) {

    AsyncCounter counter = new AsyncCounter();
    Directory src = new Directory("$packagesDir/$packageName");
    Directory dest = new Directory("$targetDir/$packageName");
    dest
        .create(recursive: true)
        .then((var _) => _copyDir(src, dest, counter));

    return counter.future;
}
