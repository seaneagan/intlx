// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of cldr;

/// A wrapper around Cldr's [Ldml2JsonConverter][converter] tool.
///
/// ## Dependencies:
///
/// * An installation of the [Cldr core and tools][cldr_downloads],
///   use <this_package>/bin/install_cldr.dart to get this.
/// * [java]
///
/// [converter]: http://unicode.org/cldr/trac/browser/tags/latest/tools/java/org/unicode/cldr/json/Ldml2JsonConverter.java
/// [cldr_downloads]: http://unicode.org/Public/cldr/latest
/// [java]: http://java.com
class Ldml2Json {

  var _logger = getLogger('cldr.Ldml2json');

  /// The Cldr core and tools installation to use.
  CldrInstallation installation;

  /// The output directory path.
  final String out;

  /// The Ldml2JsonConverter config file path.
  final String config;

  /// Used for all command runs.
  ///
  /// This is provided for mocking and testing purposes.
  Runner get runner {
    if(_runner == null) _runner = new Runner();
    return _runner;
  }
  Runner _runner;

  /// The [cldrInstallation] can either be a [CldrInstallation] or a path to
  /// one.
  Ldml2Json(
      cldrInstallation,
      this.out,
      {this.config,
       Runner runner})
      : installation = cldrInstallation is String ?
            new CldrInstallation(cldrInstallation) :
            cldrInstallation,
        _runner = runner;

  /// Converts Ldml data to Json.
  ///
  /// Returns the output Directory.
  Directory convert() {

    _checkDependencies();

    var outDir = fileSystem.getDirectory(out);

    // Remove any existing output.
    cleanDirectorySync(outDir);

    // Run the java class for all relevant Cldr subdirectories.
    _cldrSubdirectories.forEach(_runJavaClass);

    return outDir;
  }

  /// Runs the java class.
  _runJavaClass(String cldrSubdirectory) {

    var command = new Ldml2JsonConverterCommand(
        installation,
        cldrSubdirectory,
        config,
        out);

    _logger.info('''Running ${command.javaClass}:
$command''');

    var result = runner.runSync(command);

    if(result.exitCode == 0) {
      _logger.info(result.stdout);
    } else {
      _logger.err(result.stderr);
    }
  }

  /// Check dependencies.
  _checkDependencies() {
    if(!_dependenciesChecked) {
      installation.assertInstalled();
      assertCommandExists('java', runner: runner);
      _dependenciesChecked = true;
    }
  }
  /// Whether dependencies have been checked yet.
  bool _dependenciesChecked = false;

  /// The Cldr subdirectories from which to run the java class.
  Iterable<String> get _cldrSubdirectories {
    // The default config contains all data.
    var subdirs = Ldml2JsonConverterCommand.CLDR_SUBDIRECTORIES;

    if(config != null) {
      // Scan custom configs for subdirectory references.
      var configContent = fileSystem.getFile(config).readAsStringSync();
      subdirs = subdirs.where((subdir) =>
          configContent.contains('//cldr/$subdir'));
    }
    return subdirs;
  }
}
