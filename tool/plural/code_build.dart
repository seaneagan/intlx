// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'dart:json' as json;
import '../library_writer.dart';
import '../cldr_data_proxy.dart';
import '../package_paths.dart';
import 'plural_rule_parser.dart';
import 'package:intlx/src/plural/plural.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

main() {
  new PluralLibraryWriter().writeLibraries();
}

class PluralLibraryWriter extends LibraryWriter {
  final String type = "plural";
  final String symbolsClass = "PluralLocaleImpl";
  final String symbolsClassLibrary = "plural";
  
  void writeLibrariesSync(){
    super.writeLibrariesSync();
    writeLoadLocaleLibrary();
  }

  void writeLoadLocaleLibrary() {
    var loadLocaleLibraryPath = libPath.append("src/$type/");
    
    var imports = localeList.map((locale) => '''@library_$locale
import 'package:$packageName/src/plural/locale/$locale.dart' as plural_locale_$locale;
''').join();

    var deferredLibraries = localeList.map((locale) => 
      '''const library_$locale = const DeferredLibrary('plural_symbols_$locale');
''').join();
    
    var libraryMapEntries = localeList.map((locale) => 
      '''  '$locale': library_$locale''').join(',\n');
    
    var switchCases = localeList.map((locale) => 
      '''      case '$locale': init(plural_locale_$locale.symbols); break;
''').join();

    var code = '''
import 'dart:async';
import 'package:intlx/src/plural/plural.dart';
$imports

$deferredLibraries

  const libraryMap = const <String, DeferredLibrary> {
$libraryMapEntries
  };

Future<bool> loadLocale([String locale]) {
  if(PluralLocaleImpl.map.containsKey(locale)) 
    return new Future.immediate(false);
  return libraryMap[locale].load().then((_) {
    init(PluralLocale pluralLocale) => 
      PluralLocaleImpl.map[locale] = pluralLocale;
    switch(locale) {
$switchCases
    }
    return true;
  });
}''';
    
    writeLibrary(
      loadLocaleLibraryPath, 
      "load_locale", 
      getLibraryComment(false), 
      code);
  }

  String getSymbolsConstructorArgs(String locale, Map data) => 
    """'$locale', (int n) {
${getPluralRulesCode(data)}
  }""";
}

String getPluralRulesCode(Map<String, String> pluralRules) => 
  PluralCategory.values.reversed.skip(1).fold(
    "return PluralCategory.OTHER;", 
    (String code, category) {
      var categoryString = category.toString();
      if(pluralRules.containsKey(categoryString)) {
        String categoryTest = 
          pluralParser.parse(pluralRules[categoryString]).toDart();
        code = '''if($categoryTest) return PluralCategory.${categoryString};
else $code''';
      }
      return code;
  });
