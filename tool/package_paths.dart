// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?
// create a PubPackage class to model this ?

import 'dart:io';
import 'package:pathos/path.dart';

// current directory must be <root of this package>
String packageName = basename(Directory.current.path);

// current directory must be <root of this package>
Path libPath = new Path(Directory.current.path).append("lib");

// path of private (symbol) locale libraries for given type
Path getLocaleSrcPath(String type) => libPath.append("src/$type/data/");

// path of locale specific libraries
Path localeLibPath = libPath.append("locale/");

// path to data
Path dataPath = libPath.append("src/data/");

// path to locale data for given type
Path getLocaleDataPath(String type) => dataPath.append(type);

// path to locale data file for given type and locale
Path getLocaleDataFilePath(String type, String locale) => 
  getLocaleDataPath(type).append("$locale.json");

// path to locale data file for given type and locale
Path mainLocaleListFilePath = dataPath.append("main_locale_list.json");
