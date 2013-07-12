// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.cldr.iterable.code_build;

import 'dart:io';
import 'dart:json' as json;
import 'package:pathos/path.dart';
import 'package:intlx/src/package_paths.dart';
import 'package:intlx/src/codegen.dart';
import '../library_writer.dart';

main() => new IterableLibraryWriter().writeLibraries();

class IterableLibraryWriter extends LibraryWriter {
  final type = "iterable";
  final symbolsClass = "IterableSymbols";

  getSymbolsConstructorArgs(String locale, Map data) {

    String getConstructorArg(String type) {
      var separators = data[type];
      var innerArgs = separators.keys.map((String key) => "$key: '${separators[key]}'").join(", ");
      return '$type: new SeparatorTemplate($innerArgs)';
    }

    return ["start", "middle", "end", "two"].where(data.containsKey).map(getConstructorArg).join(""", 
""");
  }

  /// Get the Imports used by the symbols libraries.
  List<Import> get symbolsLibraryImports => super.symbolsLibraryImports
  ..add(new Import(package.getPackageUri(join("src", "cldr_template.dart"))));

}
