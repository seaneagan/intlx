// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.cldr.cldr_data_proxy;

import 'dart:io';
import 'dart:async';
import 'dart:utf';
import 'dart:json' as json;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:logging/logging.dart';
import 'package:unittest/matcher.dart';
import 'package:intlx/src/util.dart';
import 'util.dart';
import '../../lib/src/package_paths.dart';

// This web service is the reference implementation 
// of the official CLDR JSON bindings,
// as specified by http://cldr.unicode.org/index/cldr-spec/json.
final cldrBaseUri = "http://i18ndata.appspot.com/cldr/tags/${_cldrTag}/";

// This matches the default tag if none is provided.
// For more information, see
// http://cldr.unicode.org/index/process#resolution_procedure
final _cldrTag = "unconfirmed";

final _mainCldrLocales = 
  json.parse(new File(mainCldrLocaleListFilePath).readAsStringSync());

/// Mechanism to fetch data of a given type from [CLDR][1], 
/// transform it as necessary, and store it locally.
/// [1]: http://cldr.unicode.org/
class CldrDataProxy {

  static var logger = getLogger("intlx.tool.cldr.cldr_data_proxy");

  // path relative to the main locale data path for a given locale, 
  // in which to fetch the data.
  final String _path;
  
  /// path relative to the root data output directory, 
  /// in which to output the proxied data.
  final String outputPath;
  
  /// cldr locales from which data is available
  var availableCldrLocales = _mainCldrLocales;

  // TODO: is it necessary to artificially constrain the locales 
  // to those supported by DateFormat?
  // Why doesn't DateFormat support all locales that CLDR does?
  Iterable<String> constrainLocales() {
    var locales = availableLocalesForDateFormatting.map((locale) => 
      Intl.verifiedLocale(locale, availableCldrLocales.contains)).toSet();
    logger.info("Locales to fetch data for: ${locales.join(', ')}");
    return locales;
  }
  
  CldrDataProxy(this._path, this.outputPath);

  /// [fetch]es, [transform]s, and [store]s locale data.
  Future proxy() {
    logger.info('=== Build $outputPath data ===');
    
    wrapStep(String description, f) => (data) => 
      new LogStep(logger, description).execute(() => f(data));

    return new LogStep(logger, "fetch locale data from CLDR").execute(fetch)
      .then(wrapStep("transform locale data", transform))
      .then(wrapStep("store locale data", store));
  }

  /// Fetches data for each supported locale from the CLDR JSON web service,
  /// and returns a Future which completes with a Map 
  /// from locales to parsed JSON structures
  Future<Map<String, dynamic>> fetch() {
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
  
  /// Performs [transformJson] for each supported locale, and returns a new 
  /// Map of transformed locale data.
  transform(Map<String, dynamic> localeJsonMap) {
    var transformedData = localeJsonMap.keys.fold({}, (map, locale) {
      var transformedJson = transformJson(locale, localeJsonMap[locale]);
      logger.fine("""transformed locale data for '$locale' was:
$transformedJson""");
      map[locale] = transformedJson;
      return map;
    });
    
    // Remove any subtags which have identical data as their base tag.
    // This minimizes the amount of data that needs to be loaded
    // when supporting multiple (or all) locales.
    // The XML (LDML) data uses a fallback scheme to explicitly
    // define locale data which is identical to that of a parent locale,
    // but the JSON bindings are pre-resolved, so comparisons must be done.
    // See http://cldr.unicode.org/index/cldr-spec/json.
    transformedData = transformedData.keys.fold({}, (map, String locale) {
      var localeData = transformedData[locale];
      var baseTag = baseLocale(locale);
      var keepData = true;
      if(baseTag != locale) {
        var baseTagData = transformedData[baseTag];
        var matcher = equals(baseTagData);
        var matchState = {};
        if(matcher.matches(localeData, matchState)) {
          logger.info("Removing data for '$locale' as it's identical to "
          "that of it's base tag '$baseTag'");
          keepData = false;
        } else {
          var description = matcher.describeMismatch(
            localeData, new StringDescription(), matchState, true);
          logger.info("Retaining data for '$locale' as it's different than "
          """that of it's base tag '$baseTag' as follows:
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

  /// Override this to transform the fetched data for a given locale,
  /// into a format optimized for whatever usage patterns 
  /// are going to be supported by this data.
  transformJson(String locale, var jsonObject) => jsonObject;

  /// Store the transformed data into the local file system for later usage.
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
