// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library cldr.cldr_installation;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:cli/cli.dart';
import 'package:mockable_filesystem/filesystem.dart';
import 'package:cldr/src/zip_installer.dart';
import 'package:cldr/src/java.dart';
import 'package:cldr/src/util.dart';

/// Represents an installation of the [Cldr core and tools][cldr_downloads].
/// [cldr_downloads]: http://unicode.org/Public/cldr/latest
class CldrInstallation {

  static final _logger = getLogger('CldrInstallation');

  /// The path of this Cldr installation.
  final String path;

  /// Used for all http requests.
  ///
  /// This is provided for mocking and testing purposes.
  http.Client get httpClient {
    // Workaround http://dartbug.com/12570 by always returning a new Client.
    // TODO: Cache Client once fixed.
    if(_httpClient == null) return new http.Client();
    return _httpClient;
  }
  http.Client _httpClient;

  /// Used for all command runs.
  ///
  /// This is provided for mocking and testing purposes.
  Runner get runner {
    if(_runner == null) _runner = new Runner();
    return _runner;
  }
  Runner _runner;

  /// The path of the java source files.
  String get javaPath => join(path, "tools", "java");

  /// The path of the compiled java classes.
  String get javaClassesPath => join(javaPath, "classes");

  /// The class path to when running java tools.
  String get classPath => getClassPath([
    javaPath,
    javaClassesPath,
    join(javaPath, 'libs', '*')
  ]);

  CldrInstallation(
      this.path,
      {http.Client httpClient,
       Runner runner,
       FileSystem fileSystem})
      : _httpClient = httpClient,
        _runner = runner;

  /// Installs the specified [version] of Cldr.
  ///
  /// This requires having [ant][ant] and [jar][jar] on the PATH.
  /// [ant]: http://ant.apache.org
  /// [jar]: http://docs.oracle.com/javase/7/docs/technotes/tools/windows/jar.html
  install([String version = latestVersion]) {

    assertCommandExists('ant', runner: runner);

    /// Remove any existing installation.
    cleanDirectorySync(new Directory(path));

    return Future.forEach(requiredZips, (zip) =>
        new ZipInstaller(
            _getCldrZipUri(version, zip), path,
            httpClient: httpClient,
            runner: runner).install())
    .then((_) => _runAntBuild());
  }

  /// Assert that this installation is complete.
  assertInstalled() {
    if(!isInstalled) {
      throw new MissingDependencyError(missingDependencies.first);
    }
  }

  /// Whether this installation is complete.
  bool get isInstalled => missingDependencies.isEmpty;

  /// Returns all missing dependencies of this installation.
  Iterable<String> get missingDependencies {

    var missing = [];

    _requiredZipsExtractionMap.forEach((zip, extractedDir) {
      if (!new Directory(join(path, extractedDir)).existsSync()) {
        missing.add(
            'extracted $zip.zip in installation path: $path');
      }
    });

    if(!fileSystem.getDirectory(javaClassesPath).existsSync()) {
      missing.add('Cldr tools ant build output');
    }

    return missing;
  }

  /// Runs the Cldr tools ant build.
  _runAntBuild() {
    _logger.info("Running the Cldr tools ant build in: '$javaPath'");
    var command = new Command('ant', ['clean', 'all']);
    runner.runSync(command, workingDirectory: javaPath);
  }

  /// The Cldr zips which must be installed.
  static final requiredZips = _requiredZipsExtractionMap.keys;

  /// Maps zips to contained directories used to test extracted zip presence.
  static final _requiredZipsExtractionMap = {
    'core': 'common',
    'tools': 'tools'
  };

  /// The [latest] Cldr version.
  /// [latest]: http://cldr.unicode.org/index/downloads/latest
  static const latestVersion = 'latest';

  /// Returns the download Uri of a Cldr [zip] with [version].
  static String _getCldrZipUri(String version, String zip) =>
      '$_cldrDownloadRoot/$version/$zip.zip';

  /// The Cldr download root.
  static final _cldrDownloadRoot = 'http://www.unicode.org/Public/cldr';
}
