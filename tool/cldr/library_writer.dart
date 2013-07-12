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

/// Uses json data to generate dart libraries which can be used 
/// to load locale data of a given type.
abstract class LibraryWriter {

  static var logger = getLogger("${package.name}.tool.cldr.library_writer");
  
  /// intermediate storage of the locale data
  Map<String, Map> localeDataMap;
  
  /// the list of locales for which data exists
  List<String> localeList;
  
  /// A name for the type of data for which libraries are being written
  String get type;
  
  /// The name of the dart class which represents this data type
  String get symbolsClass;
  
  /// The name of the library in which [symbolsClass] will exist.
  String get symbolsClassLibraryName => '${type}_symbols';

  /// The main entry point. Gets the locale data using [getBuiltLocaleData]
  /// from which it then generates libraries using [writeLibrariesSync].
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

  /// Generates all locale data libraries synchronously.
  void writeLibrariesSync() =>
    {
      "Writing locale list library": writeLocaleListLibrary,
      "Writing symbols libraries": writeSymbolsLibraries,
      "Writing top-level locale data library": writeLocaleDataLibrary
    }.forEach((description, step) => 
      new LogStep(logger, description).execute(step));

  /// Write the library containing the list of supported locales for this 
  /// data type.
  void writeLocaleListLibrary() {
    var localeListString = json.stringify(localeList);

    var code = '''
const ${getLocaleListConstant()} = const <String> $localeListString;
''';

    new Library(
      pathos.join(package.path, "lib", "src", type, "${getLocaleListLibraryName()}.dart"), 
      code, 
      [], 
      comment: getLibraryComment(false))
    .generate();

  }
    
  /// Writes the libraries containing raw locale data for each locale.
  void writeSymbolsLibraries() {

    // delete existing data files
    var localeSrcDirectory = 
      new Directory(pathos.join(package.path, localeSrcPath));
    truncateDirectorySync(localeSrcDirectory);

    for(String locale in localeList) {
      writeSymbolsLibrary(locale, localeDataMap[locale]);
    }
  }

  /// Writes a library containing raw locale data for an individual locale.
  void writeSymbolsLibrary(String locale, Map data) {
    new Library(
      pathos.join(package.path, localeSrcPath, "${getLocaleId(locale)}.dart"), 
      getSymbolLibraryCode(locale, data), 
      symbolsLibraryImports, 
      comment: getLibraryComment(true))
    .generate();
  }
  
  /// Get the Imports used by the symbols libraries.
  List<Import> get symbolsLibraryImports => 
    [new Import(package.getPackageUri(getSymbolsClassLibraryPath()))];

  /// Get the code used by the symsols libraries.
  String getSymbolLibraryCode(String locale, Map data) { 
    var constructorArgs = getSymbolsConstructorArgs(locale, data);
    return '''
final $symbolsConstantName = new $symbolsClass($constructorArgs);
''';
  }

  /// Get the
  final String symbolsConstantName = "symbols";

  /// Get the constructor arguments to pass to [symbolsClass].
  String getSymbolsConstructorArgs(String locale, Map data);

  /// Get an Import of a symbols library for a locale.
  Import getLocaleSymbolsImport(String locale) {
    var symbolsLibraryId = getSymbolsImportPrefix(locale);
    var localeId = getLocaleId(locale);
    var uri = package.getPackageUri('src/$type/data/$localeId.dart');
    return new Import(uri, as: symbolsLibraryId);
  }
  
  /// Get the path of the library containing [symbolsClass].
  String getSymbolsClassLibraryPath() => 
    "src/$type/$symbolsClassLibraryName.dart";

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

  /// Markdown representing the public classes used to consume
  /// this locale data.
  String get publicClassMarkdown => 
    "[${underscoresToCamelCase(type, true)}Format]";
  
  /// Get imports of symbols libraries for each locale.
  List<Import> getSymbolsImports() => 
    localeList.map(getLocaleSymbolsImport).toList();
  
  /// Write the library representing the public interface for loading this 
  /// locale data.
  writeLocaleDataLibrary() {
    var publicClasses = publicClassMarkdown;
    var dataPrefix = "${type}_data";
    var libraryDoc = '''

/// Exposes [LocaleData] constants for use with $publicClassMarkdown.
/// For example:
///     ${new Import(package.getPackageUri(localeDataLibraryName), as: dataPrefix)}
///     main() {
///       $dataPrefix.EN.load();
///       $dataPrefix.DE.load();
///       // do something with $publicClassMarkdown.
///     }''';

    var imports = [
      '${package.name}.dart',
      'src/locale_data_impl.dart',
      'src/symbols_map.dart',
      'src/$type/${getLocaleListLibraryName()}.dart',
      getSymbolsClassLibraryPath()
    ]
    .map((path) => new Import(package.getPackageUri(path)))
    .toList()
    ..addAll(getSymbolsImports());

    var library = new Library(
      pathos.join(package.path, "lib", localeDataLibraryName), 
      '', 
      imports, 
      comment: getLibraryComment(false) + libraryDoc);
    // part which contains the ALL locale data constant
    library.addPart(
      allLocaleDataPartPath, 
      allLocaleDataPartCode, 
      comment: getLibraryComment(false));
    // part which contains each individual locale data constant
    library.addPart(
      localeDataConstantsPartPath, 
      localeDataConstantsPartCode, 
      comment: getLibraryComment(false));
    library.generate();

  }

  /// The name of the library representing the public interface 
  /// for loading this locale data.
  String get localeDataLibraryName => "${type}_locale_data.dart";

  
  /// The path of the part containing the ALL locale data constant.
  String get allLocaleDataPartPath => 
    "src/$type/${type}_all_data_constant.dart";
  /// The code of the part containing the ALL locale data constant.
  String get allLocaleDataPartCode => '''
/// Loads data for **all** supported locales
final LocaleData ALL = new AllLocaleDataImpl(() {
${getSymbolsMapSetterLogic()}
});''';

  /// The path of the part containing the individual locale data constants.
  String get localeDataConstantsPartPath => 
    "src/$type/${type}_locale_data_constants.dart";
  /// The code of the part containing the individual locale data constants.
  String get localeDataConstantsPartCode {
    var localeDataConstants = localeList.map(getLocaleDataConstant).join("\n");
    return '''$localeDataConstants
''';
  }
  
  /// Get constructor args for a LocaleData constant.
  String getLocaleDataConstructorArgs(String locale) => 
    '"$locale", () => ${getSymbolsVariable(locale)}';
  
  /// Get the qualified name of the variable containing symbols data for 
  /// [locale].
  String getSymbolsVariable(String locale) => 
    '${getSymbolsImportPrefix(locale)}.$symbolsConstantName';
  
  /// Get the prefix used to import the symbols for [locale].
  String getSymbolsImportPrefix(String locale) => 
    "symbols_${locale.toUpperCase()}";

  /// Get the logic used to set the SymbolsMap for this data type.
  String getSymbolsMapSetterLogic() {
    var symbolsMapContents = localeList.map((String locale) => 
      '  "$locale": ${getSymbolsVariable(locale)}').join(", \n");
    return '''
  $symbolsClass.map = new SymbolsMap<$symbolsClass>(
  ${getLocaleListConstant()}, 
  {$symbolsMapContents});''';
  }

  /// Get the LocaleData constant for [locale].
  String getLocaleDataConstant(String locale) {
    var constructorArgs = getLocaleDataConstructorArgs(locale);
    var constructor = "${underscoresToCamelCase(type, true)}LocaleDataImpl";
    return '''final LocaleData ${locale.toUpperCase()} = 
  new $constructor($constructorArgs);''';
  }

  /// Get the name of the constant representing the list of supported locales.
  String getLocaleListConstant() => 
    '${underscoresToCamelCase(type, false)}Locales';

  /// Path of symbol libraries for given type.
  String get localeSrcPath => pathos.join(PubPackage.SRC, type, "data");
  
  /// must use uppercase locales since "in" and "is" are keywords
  String getLocaleId(String locale) => locale.toUpperCase();
}
