// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:convert';
import 'package:cldr/cldr.dart';
import 'package:cldr/data_sets.dart';
import 'package:path/path.dart';

main() {

  var extractor = new JsonExtractor(r'C:\cldr_json');

  var data = extractor.extract(languages);

  var enLanguages = data['en'];

  var json = JSON.encode(enLanguages);

  var path = join(dirname(new Options().script), '..', 'web', 'languages.json');

  new File(path).writeAsStringSync(json);
}
