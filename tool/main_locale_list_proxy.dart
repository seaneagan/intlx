

import 'cldr_data_proxy.dart';
import 'package:http/http.dart' as http;
import 'dart:json' as json;
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package_paths.dart';
main() {
  http.read(cldrBaseUri + "main").then((String dummyLocaleMap) {
    var localeList = json.parse(dummyLocaleMap).keys.toList();
    var file = new File.fromPath(mainLocaleListFilePath);
    file.writeAsStringSync(json.stringify(localeList));
  });
}
