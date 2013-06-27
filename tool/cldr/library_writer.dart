// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.


library intlx.tool.cldr.library_writer;

import 'dart:io';
import 'dart:json' as json;
import 'dart:async';
import 'package:pathos/path.dart' as pathos;
import 'package:logging/logging.dart';
import 'package:intlx/src/util.dart';
import 'package:intlx/src/codegen.dart';
import 'package:intlx/src/package_paths.dart';
import 'util.dart';

/// Generates dart source files which can be used 
/// to load locale data of a given type.
abstract class LibraryWriter {

  static var logger = getLogger("${package.name}.tool.library_writer");
  
  /// intermediate storage of the locale data
  Map<String, Map> localeDataMap;
  
  /// the list of locales for which data exists
  List<String> localeList;
  
  /// A name for the type of data for which libraries are being written
  String get type;
  
  /// The name of the dart class which represents this data type
  String get symbolsClass;
  
  /// The name of the library in which [symbolsClass] will exist.
  String get symbolsClassLibrary => '${type}_symbols';

  /// The main entry point, 
  /// calls [getBuiltLocaleData] and [writeLibrariesSync].
  Future writeLibraries() {
    logger.info("--- Build $type code ---");
    var loadDataStep = new LogStep(logger, "Loading locale data")..start();
    return getBuiltLocaleData().then((localeDataMap) {
      loadDataStep.end();
      this.localeDataMap = localeDataMap;
      localeList = new List.from(localeDataMap.keys)..sort();
      writeLibrariesSync();
    });
  }

  /// Asynchronously retrieves the input locale data, 
  /// from which to generate the locale data libraries. 
  Future getBuiltLocaleData() {
    var dataDirectory = new Directory(getLocaleDataPath(type));
    logger.info("locale data directory: ${dataDirectory.path}");
    return dataDirectory.list().fold({}, (localeDataMap, fse) {
      String locale = pathos.basenameWithoutExtension(fse.path);
  
      var filePath = getLocaleDataFilePath(type, locale);
      var file = new File(filePath);
      String fileJson = file.readAsStringSync();
      localeDataMap[locale] = json.parse(fileJson);
      return localeDataMap;
    });
  }

  /// Generates and writes to disk all locale data libraries synchronously.
  void writeLibrariesSync() =>
    {
      "Writing locale list library": writeLocaleListLibrary,
      "Writing symbols libraries": writeSymbolsLibraries,
      "Writing top-level locale data library": writeLocaleDataLibrary
    }.forEach((description, step) => 
      new LogStep(logger, description).execute(step));

  /// Write a library containing a list of supported locales for this data type.
  void writeLocaleListLibrary() {
    var localeListString = json.stringify(localeList);

    var code = '''
const ${getLocaleListId()} = const <String> $localeListString;
''';

    new LibraryBuilder(
      pathos.join("lib", "src", "$type/${getLocaleListLibraryName()}.dart"), 
      code, 
      [], 
      comment: getLibraryComment(false))
    .generate();

  }
    
  /// Calls [writeSymbolsLibrary] for each locale.
  void writeSymbolsLibraries() {

    // delete existing data files
    var localeSrcDirectory = new Directory(pathos.join(package.path, getLocaleSrcPath(type)));
    truncateDirectorySync(localeSrcDirectory);

    for(String locale in localeList) {
      writeSymbolsLibrary(locale, localeDataMap[locale]);
    }
  }

  /// Writes a library containing raw locale data for an individual locale.
  void writeSymbolsLibrary(String locale, Map data) {
    var dir = getLocaleSrcPath(type);
    new LibraryBuilder(
      pathos.join(dir, "$locale.dart"), 
      getSymbolLibraryCode(locale, data), 
      symbolsLibraryImports, 
      comment: getLibraryComment(true),
      libraryId: package.getLibraryIdFromPath(pathos.join(dir, "${getLocaleId(locale)}/")))
    .generate();
  }
  
  Iterable<Import> get symbolsLibraryImports => 
    [new Import(package.getPackageUri('src/$type/$symbolsClassLibrary.dart'))];

  String getSymbolLibraryCode(String locale, Map data) => '''
final symbols = new $symbolsClass(${getSymbolsConstructorArgs(locale, data)});
''';

  String getSymbolsConstructorArgs(String locale, Map data);

  String getSymbolsLibraryId(String locale) => 
    "${package.name}.${type}.data.$locale";

  Import generateLocaleImport(String locale) {
    var symbolsLibraryId = getSymbolsImportId(locale);
    var localeId = getLocaleId(locale);
    var uri = package.getPackageUri('src/$type/data/$localeId.dart');
    return new Import(uri, as: symbolsLibraryId);
  }
    
  String getSymbolsClassLibraryUri() => 
    "src/$type/$symbolsClassLibrary.dart";

  String getLocaleListLibraryName() => 
    "${type}_locale_list";

  // Include dart project copyright text in generated dart files.
  String getLibraryComment(bool containsSymbols) {
    var comment = '''
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// DO NOT EDIT. This file is autogenerated by script, see
// "${package.name}/tool/$type/code_build.dart"
''';
    
    // Include an extra message about potential manual editing
    // when errors are found, in files which contain raw data.
    if(containsSymbols) {
      comment += '''
// 
// Before checkin, this file could have been manually edited. This is
// to incorporate changes before we could correct CLDR. All manual
// modification must be documented in this section, and should be
// removed after those changes land to CLDR.''';
    }
    return comment;
  }

  String getPublicClasses() => "[${underscoresToCamelCase(type, true)}Format]";
  
  List<Import> getSymbolsImports() => 
    localeList.map(generateLocaleImport).toList();
  
  // Write the library representing the public interface for loading this locale data.
  writeLocaleDataLibrary() {
    var publicClasses = getPublicClasses();
    var libraryDoc = '''

/// Exposes [LocaleData] constants for use with $publicClasses.
/// For example:
///     ${new Import(package.getPackageUri("${type}_locale_data.dart"), as: "${type}_data")}
///     main() {
///       ${type}_data.EN.load();
///       ${type}_data.DE.load();
///       // do something with $publicClasses.
///     }''';

    var imports = [
      '${package.name}.dart',
      'src/locale_data_impl.dart',
      'src/symbols_map.dart',
      'src/$type/${getLocaleListLibraryName()}.dart',
      getSymbolsClassLibraryUri()
    ]
    .map((path) => new Import(package.getPackageUri(path)))
    .toList()
    ..addAll(getSymbolsImports());

    var libraryBuilder = new LibraryBuilder(
      pathos.join("lib", "${type}_locale_data.dart"), 
      '', 
      imports, 
      comment: getLibraryComment(false) + libraryDoc);
    // part which contains the ALL locale data constant
    libraryBuilder.addPart(
      allLocaleDataPartPath, 
      allLocaleDataPartCode, 
      getLibraryComment(false));
    // part which contains each individual locale data constant
    libraryBuilder.addPart(
      localeDataConstantsPartPath, 
      localeDataConstantsPartCode, 
      getLibraryComment(false));
    libraryBuilder.generate();

  }

  String get allLocaleDataPartPath => 
    "src/$type/${type}_all_data_constant.dart";
  String get allLocaleDataPartCode => '''
/// Loads data for **all** supported locales
final LocaleData ALL = new AllLocaleDataImpl(() {
${getSymbolsMapSetterLogic()}
});''';

  String get localeDataConstantsPartPath => 
    "src/$type/${type}_locale_data_constants.dart";
  String get localeDataConstantsPartCode {
    var localeDataConstants = localeList.map(getLocaleDataConstant).join("\n");
    return '''$localeDataConstants
''';
  }
  
  String getLocaleDataConstructorArgs(String locale) => 
    '"$locale", () => ${getSymbolsConstant(locale)}';
    
  String getSymbolsConstant(String locale) => 
    '${getSymbolsImportId(locale)}.symbols';
  
  String getSymbolsImportId(String locale) => 
    "symbols_${locale.toUpperCase()}";

  String getSymbolPartCode(String locale, Map data) {
    var constructorArgs = getSymbolsConstructorArgs(locale, data);
    return '''
  }
final ${getSymbolsConstant(locale)} = new $symbolsClass($constructorArgs);
''';
  }
  
  String getSymbolsMapSetterLogic() {
    var symbolsMapContents = localeList.map((String locale) => 
      '  "$locale": ${getSymbolsConstant(locale)}').join(", \n");
    return '''
  $symbolsClass.map = new SymbolsMap<$symbolsClass>(
  ${getLocaleListId()}, 
  {$symbolsMapContents});''';
  }

  String getLocaleDataConstant(String locale) {
    var constructorArgs = getLocaleDataConstructorArgs(locale);
    var constructor = "${underscoresToCamelCase(type, true)}LocaleDataImpl";
    return '''final LocaleData ${locale.toUpperCase()} = 
  new $constructor($constructorArgs);''';
  }

  String getLocaleListId() => '${underscoresToCamelCase(type, false)}Locales';

  // must use uppercase locales since "in" and "is" are keywords
  String getLocaleId(String locale) => locale.toUpperCase();
}
