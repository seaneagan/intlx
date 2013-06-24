// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'cldr_data_proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:json' as json;
import 'dart:io';
import 'dart:async';
import 'package_paths.dart';

// generates a file containing the list of available CLDR locales
main() {
  http.read("${cldrBaseUri}main").then((String emptyLocaleMap) {
    var localeList = json.parse(emptyLocaleMap).keys.toList();
    var file = new File(mainLocaleListFilePath);
    file.writeAsStringSync(json.stringify(localeList));
  });
}
