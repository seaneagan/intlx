// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?
// create a PubPackage class to model this ?

library intlx.tool.cldr.package_paths;

import 'dart:io';
import 'package:pathos/path.dart';

// TODO: this assumes the scripts are run from the root of the pub package.
// Consider instead dynamically calculating the root of the pub package, 
// containing the currently executing script, 
// so scripts may be run from anywhere.
String packagePath = current;

// name of this pub package
String packageName = basename(packagePath);

// library path of this pub package
String libPath = join(packagePath, "lib");

// path of private (symbol) locale libraries for given type
String getLocaleSrcPath(String type) => join(libPath, "src/$type/data");

// path of locale specific libraries
String localeLibPath = join(libPath, "locale");

// path to data
String dataPath = join(libPath, "src/data");

// path to locale data for given type
String getLocaleDataPath(String type) => join(dataPath, type);

// path to locale data file for given type and locale
String getLocaleDataFilePath(String type, String locale) => 
    join(getLocaleDataPath(type), "$locale.json");

// path to locale data file for given type and locale
String mainLocaleListFilePath = join(dataPath, "main_locale_list.json");

String getLibraryIdFromPath(String path) {
  
  var dir = dirname(path);
  
  var contextPath = ['lib/src', 'lib', ''].firstWhere(
    (i) => contains(dir, join(packagePath, i)));
  
  var suffixPath = relative(dir, from: contextPath);
  
  var segments = split(suffixPath).where((i) => i != '.').toList()
    ..insert(0, packageName)
    ..add(basenameWithoutExtension(path));
  
  return segments.join('.');
}

// TODO: Add something like this to package:pathos ?
bool contains(String path, String container) => 
    !relative(path, from: container).startsWith('..');
