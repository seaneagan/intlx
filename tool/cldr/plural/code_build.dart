// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library intlx.tool.cldr.plural.code_build;

import 'dart:async';
import 'dart:io';
import 'dart:json' as json;
import 'package:http/http.dart' as http;
import 'package:pathos/path.dart' as pathos;
import 'package:logging/logging.dart';
import 'package:intlx/src/plural/plural.dart';
import 'plural_rule_parser.dart';
import 'package:intlx/src/codegen.dart';
import 'package:intlx/src/package_paths.dart';
import '../util.dart';
import '../library_writer.dart';
import '../cldr_data_proxy.dart';

main() => new PluralLibraryWriter().writeLibraries();

class PluralLibraryWriter extends LibraryWriter {
  
  static var logger = LibraryWriter.logger;

  final String type = "plural";
  final String symbolsClass = "PluralLocaleImpl";
  final String symbolsClassLibraryName = "plural";
  
  void writeLibrariesSync(){
    super.writeLibrariesSync();
    new LogStep(logger, "Writing loadLocale() library")
      .execute(writeLoadLocaleLibrary);
  }

  void writeLoadLocaleLibrary() {
    var loadLocaleLibraryPath = pathos.join(PubPackage.SRC, type);
    
    var deferredLibraries = localeList.map((locale) => 
      '''const library_$locale = const DeferredLibrary('plural_symbols_$locale');
''').join();
    
    var libraryMapEntries = localeList.map((locale) => 
      '''  '$locale': library_$locale''').join(',\n');
    
    var switchCases = localeList.map((locale) => 
      '''      case '$locale': init(${getSymbolsVariable(locale)}); break;
''').join();

    var code = '''
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
    
    var imports = [
      'dart:async',
      'package:${package.name}/src/util.dart',
      'package:${package.name}/src/plural/plural.dart'
    ]
    .map((uri) => new Import(uri))
    .toList()
    ..addAll(localeList.map((locale) {
      var symbolsImportId = getSymbolsImportPrefix(locale);
      return new Import(
        package.getPackageUri('src/plural/data/$locale.dart'), 
        as: symbolsImportId, 
        metadata: '@library_$locale');
    }));

    new Library(
      pathos.join(package.path, loadLocaleLibraryPath, "${type}_load_locale.dart"), 
      code, 
      imports, 
      comment: getLibraryComment(false))..generate();
  }

  String getSymbolsConstructorArgs(String locale, Map data) => 
    """'$locale', (int n) {
${getPluralRulesCode(data)}
}""";

List<Import> get symbolsLibraryImports => 
  [
    super.symbolsLibraryImports, 
    [new Import(package.getPackageUri('src/util.dart'))]
  ].expand((i) => i);
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
