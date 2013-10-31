// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library cldr.zip_installer;

import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:cli/cli.dart';
import 'package:mockable_filesystem/filesystem.dart';
import 'package:cldr/src/util.dart';

/// Installs zip files from the network to the local file system.
class ZipInstaller {

  static final _logger = getLogger('ZipInstaller');

  /// The Uri of the zip file to install.
  final String zipUri;

  /// The directory path at which to install the zip.
  final String installDir;

  /// Used for all http requests.
  ///
  /// This is provided for mocking and testing purposes.
  http.Client get httpClient {
    if(_httpClient == null) _httpClient = new http.Client();
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

  /// The [basename] of the zip file.
  String get _zipBasename {
    if(__zipBasename == null) __zipBasename = basename(zipUri);
    return __zipBasename;
  }
  String __zipBasename;

  String get _zipPath => join(installDir, _zipBasename);

  ZipInstaller(
      this.zipUri,
      this.installDir,
      {http.Client httpClient,
       Runner runner})
      : _httpClient = httpClient,
        _runner = runner;

  /// Installs [zipUri] to [installDir].
  ///
  /// Downloads, writes, extracts, and deletes the zip.
  Future install() =>
      _download()
      .then(_write)
      .then((_) => _extract())
      .then((_) => _delete());

  Future<List<int>> _download() {
    _logger.info("Downloading '$_zipBasename'");
    return httpClient.readBytes(zipUri);
  }

  _write(List<int> bytes) {
    _logger.info("Writing '$_zipBasename' to '$installDir'");
    var zipFile = fileSystem.getFile(_zipPath);
    zipFile.directory.createSync(recursive: true);
    zipFile.writeAsBytesSync(bytes);
  }

  _extract() {
    _logger.info("Extracting '$_zipBasename' to '$installDir'");

    // The `jar xf` answer had the most upvotes here:
    //     http://stackoverflow.com/a/1021592/896989
    var command = new Command('jar', ['xf', _zipBasename]);
    runner.runSync(command, workingDirectory: installDir);
  }

  _delete() {
    _logger.info("Deleting '$_zipBasename' from '$installDir'");
    fileSystem.getFile(_zipPath).deleteSync();
  }
}
