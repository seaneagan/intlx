// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?
// create a PubPackage class to model this ?

library intlx.tool.package_paths;

import 'dart:io';
import 'package:pathos/path.dart';

// current directory must be <root of this package>
String packageName = basename(Directory.current.path);

// current directory must be <root of this package>
String libPath = join(Directory.current.path, "lib");

// path of private (symbol) locale libraries for given type
String getLocaleSrcPath(String type) => join(libPath, "src/$type/data/");

// path of locale specific libraries
String localeLibPath = join(libPath, "locale/");

// path to data
String dataPath = join(libPath, "src/data/");

// path to locale data for given type
String getLocaleDataPath(String type) => join(dataPath, type);

// path to locale data file for given type and locale
String getLocaleDataFilePath(String type, String locale) => 
    join(getLocaleDataPath(type), "$locale.json");

// path to locale data file for given type and locale
String mainLocaleListFilePath = join(dataPath, "main_locale_list.json");
