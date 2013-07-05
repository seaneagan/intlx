// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: Remove intl/test/data_directory.dart, since that functionality 
// now exists here.
library intlx.package_paths;

import 'dart:io';
import 'package:pathos/path.dart';
import 'package:intlx/src/codegen.dart';

/// Find the intl package, compensating for scripts being run 
/// from different locations. The important locations are:
/// - somewhere within the package, e.g. the package root, test, or tool dirs.
/// - the top-level dart directory, where the build tests run
PubPackage get package {
  try {
    // within the package
    return new PubPackage.containing();
  } catch (_) {
    String fromDartDir = join('pkg','intl');

    // top-level dart dir
    var packagePath = 
    [join(current, fromDartDir), join(current, '..', fromDartDir)]
    .firstWhere((path) => new Directory(path).existsSync(), orElse: () => 
      throw new UnsupportedError(
        'Cannot find $fromDartDir directory.')
    );
    
    return new PubPackage(packagePath);
  }
}

// path to data
final String _dataPath = join(PubPackage.SRC, "data");

/// path to locale data for given type
String getLocaleDataPath(String type) => join(package.path, _dataPath, type);

/// path to locale data file for given type and locale
String getLocaleDataFilePath(String type, String locale) => 
  join(getLocaleDataPath(type), "$locale.json");

/// path to main cldr locale list data file
final String mainCldrLocaleListFilePath = 
  join(package.path, _dataPath, "main_locale_list.json");
