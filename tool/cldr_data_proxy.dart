// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:async';
import 'dart:utf';
import 'dart:json' as json;
import 'package:http/http.dart' as http;
import 'package_paths.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:logging/logging.dart';
import 'log_util.dart';

// This web service uses the official CLDR JSON bindings,
// as specified by http://cldr.unicode.org/index/cldr-spec/json.
final cldrBaseUri = "http://i18ndata.appspot.com/cldr/tags/$cldrTag/";
final cldrTag = "unconfirmed";

final mainCldrLocales = 
  json.parse(new File(mainLocaleListFilePath).readAsStringSync());

class CldrDataProxy {

  static var logger = getLogger("intlx.tool.cldr_data_proxy");

  final String _path;
  final String outputPath;
  var availableCldrLocales = mainCldrLocales;

  // TODO: is it really necessary to artificially constrain the locales to those supported by DateFormat?
  Iterable<String> constrainLocales() {
    var locales = availableLocalesForDateFormatting.map((locale) => 
      Intl.verifiedLocale(locale, availableCldrLocales.contains)).toSet();
    logger.info("Locales to fetch data for: ${locales.join(', ')}");
    return locales;
  }
  
  CldrDataProxy(this._path, this.outputPath);

  Future proxy() {
    logger.info('=== Build $outputPath data ===');
    
    wrapStep(String description, f) => (data) => 
      new LogStep(logger, description).execute(() => f(data));

    return new LogStep(logger, "fetch locale data from CLDR").execute(fetch)
      .then(wrapStep("transform locale data", transform))
      .then(wrapStep("store locale data", store));
  }

  Future fetch() {
    String getCldrDataUri(String locale) => 
      "${cldrBaseUri}main/$locale/${_path}?depth=-1";
    var locales = constrainLocales().toList();
    var dataRequests = 
      locales.map((locale) {
        var uri = getCldrDataUri(locale);
        logger.fine("fetching data for locale '$locale' from '$uri'");
        return http.read(uri)..then((body) {
          logger.fine("data for locale '$locale': '$body'");
        });
      });
  
    return Future.wait(dataRequests).then((List<String> unitsBodies) =>
      unitsBodies.asMap().keys.fold(
        new Map<String, dynamic>(), 
        (localeDataMap, i) {
          localeDataMap[locales[i]] = json.parse(unitsBodies[i]);
          return localeDataMap;
        }));
  }
  
  transform(Map<String, dynamic> localeJsonMap) {
    var transformedData = localeJsonMap.keys.fold(<String, String> {}, (map, locale) {
      var transformedJson = transformJson(locale, localeJsonMap[locale]);
      logger.fine("""transformed locale data for '$locale' was:
$transformedJson""");
      map[locale] = 
        json.stringify(transformedJson);
      return map;
    });
    return transformedData;
  }

  transformJson(String locale, var jsonObject) => jsonObject;

  void store(Map<String, String> localeJsonMap) {
    localeJsonMap.forEach((locale, json){
      var filePath = getLocaleDataFilePath(outputPath, locale);
      logger.fine("storing data for locale '$locale' in '$filePath'");
      var dataFile = 
        new File(filePath);
      dataFile.writeAsStringSync(json);
    });
  }

}
