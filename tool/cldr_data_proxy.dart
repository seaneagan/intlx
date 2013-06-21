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
import 'package:intlx/src/util.dart';
import 'package:unittest/matcher.dart';
import 'log_util.dart';
import 'io_util.dart';

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
    var transformedData = localeJsonMap.keys.fold(<String, dynamic> {}, (map, locale) {
      var transformedJson = transformJson(locale, localeJsonMap[locale]);
      logger.fine("""transformed locale data for '$locale' was:
$transformedJson""");
      map[locale] = transformedJson;
      return map;
    });
    
    // remove any subtags which have identical data as their base tag
    transformedData = transformedData.keys.fold(<String, dynamic> {}, (map, String locale) {
      var localeData = transformedData[locale];
      var baseTag = baseLocale(locale);
      var keepData = true;
      if(baseTag != locale) {
        var baseTagData = transformedData[baseTag];
        var matcher = equals(baseTagData);
        var matchState = {};
        if(matcher.matches(localeData, matchState)) {
          logger.info("Removing data for '$locale' since it's identical to that of it's base tag '$baseTag'");
          keepData = false;
        } else {
          var description = matcher.describeMismatch(localeData, new StringDescription(), matchState, true);
          logger.info("""Retaining data for '$locale' since it has the following difference from that of it's base tag '$baseTag':
$description""");
        }
      }
      if(keepData) {
        map[locale] = localeData;
      }
      return map;
    });
    
    // stringify remaining data
    transformedData.forEach((locale, data) {
      transformedData[locale] = json.stringify(data);
    });

    return transformedData;
  }

  transformJson(String locale, var jsonObject) => jsonObject;

  void store(Map<String, String> localeJsonMap) {
    
    // delete existing files
    var localeDataDirectory = new Directory(getLocaleDataPath(outputPath));
    truncateDirectorySync(localeDataDirectory);
    
    // store new files
    localeJsonMap.forEach((locale, json){
      var filePath = getLocaleDataFilePath(outputPath, locale);
      logger.fine("storing data for locale '$locale' in '$filePath'");
      var dataFile = 
        new File(filePath);
      dataFile.writeAsStringSync(json);
    });
  }

}
