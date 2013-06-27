// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?
// create a PubPackage class to model this ?

library intlx.tool.package_paths;

import 'dart:io';
import 'package:pathos/path.dart';
import 'package:intlx/src/codegen.dart';

final PubPackage package = new PubPackage();

// library path of this pub package
String libPath = "lib";

// src path of this pub package
String srcPath = join(libPath, "src");

// path of private (symbol) locale libraries for given type
String getLocaleSrcPath(String type) => join(srcPath, "$type/data");

// path to data
String dataPath = join(srcPath, "data");

// path to locale data for given type
String getLocaleDataPath(String type) => join(dataPath, type);

// path to locale data file for given type and locale
String getLocaleDataFilePath(String type, String locale) => 
    join(getLocaleDataPath(type), "$locale.json");

// absolute path to main locale list data file
String mainLocaleListFilePath = join(package.path, dataPath, "main_locale_list.json");
