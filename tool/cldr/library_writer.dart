// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library library_writer;

import 'dart:io';
import 'dart:json' as json;
import 'dart:async';
import 'package:pathos/path.dart' as pathos;
import 'package:logging/logging.dart';
import 'package:intlx/src/util.dart';
import 'util.dart';
import 'package_paths.dart';

/// Generates dart source files which can be used 
/// to load locale data of a given type.
abstract class LibraryWriter {

  static var logger = getLogger("intlx.tool.library_writer");
  
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
      "Writing locale data constants": writeLocaleDataConstantsPart,
      "Writing symbols libraries": writeSymbolsLibraries,
      "Writing ALL locale data part": writeAllLocaleDataPart,
      "Writing top-level locale data library": writeLocaleDataLibrary
    }.forEach((description, step) => 
      new LogStep(logger, description).execute(step));

  /// Calls [writeSymbolsLibrary] for each locale.
  void writeSymbolsLibraries() {

    // delete existing data files
    var localeSrcDirectory = new Directory(getLocaleSrcPath(type));
    truncateDirectorySync(localeSrcDirectory);

    for(String locale in localeList) {
      writeSymbolsLibrary(locale, localeDataMap[locale]);
    }
  }

  /// Writes a library containing raw locale data for an individual locale.
  void writeSymbolsLibrary(String locale, Map data) {
    writeLibrary(
      getLocaleSrcPath(type), 
      locale.toUpperCase(), 
      getLibraryComment(true), 
      getSymbolLibraryCode(locale, data), 
      getSymbolsLibraryId(locale));
  }

  String getSymbolLibraryCode(String locale, Map data) => '''
${getSymbolsClassLibraryImport()}

final symbols = new $symbolsClass(${getSymbolsConstructorArgs(locale, data)});
''';

  String getSymbolsConstructorArgs(String locale, Map data);

  String getSymbolsLibraryId(String locale) => 
    "${type}_symbols_$locale";

  String generateLocaleImport(String locale) {
    var symbolsLibraryId = getSymbolsImportId(locale);
    return "import 'package:$packageName/src/$type/data/$locale.dart' as $symbolsLibraryId;";
  }

  String getSymbolsClassLibraryImport() => 
    "import 'package:$packageName/src/$type/$symbolsClassLibrary.dart';";

  /// Write a library containing a list of supported locales for this data type.
  void writeLocaleListLibrary() {
    String localeListString = json.stringify(localeList);

    var code = '''
const ${underscoresToCamelCase(type, false)}Locales = const <String> $localeListString;
  ''';

    writeLibrary(
      pathos.join(libPath, "src/$type/"), 
      getLocaleListLibraryName(), 
      getLibraryComment(false), 
      code);
  }
  
  String getLocaleListLibraryName() => "${type}_locale_list";

  /// Generate and synchronously write to disk a dart library.
  writeLibrary(
    String path, 
    String name, 
    String comment, 
    String code, 
    [String id,
     bool isPart = false]) {

    if(id == null) id = name;
    String fullCode = '''
$comment
${isPart ? "part of" : "library"} $id;

$code''';
    var targetFile = new File(pathos.join(path, "$name.dart"));
    logger.fine('''Writing library: '$id' to file: '$targetFile' with code:
$fullCode''');
    targetFile.writeAsStringSync(fullCode);
  }

  // Include dart project copyright text in generated dart files.
  String getLibraryComment(bool containsSymbols) {
    var comment = '''
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// DO NOT EDIT. This file is autogenerated by script, see
// "$packageName/tool/$type/code_build.dart"
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
  
  String getSymbolsImports() => 
    localeList.map(generateLocaleImport).toList().join("\n");
  
  // Write the library representing the public interface for loading this locale data.
  writeLocaleDataLibrary() {
    var publicClasses = getPublicClasses();
    var symbolsImports = 
      localeList.map(generateLocaleImport).toList().join("\n");
    var libraryDoc = '''

/// Exposes [LocaleData] constants for use with $publicClasses.
/// For example:
///     import 'package:$packageName/${type}_locale_data.dart' as ${type}_data;
///     main() {
///       ${type}_data.EN.load();
///       ${type}_data.DE.load();
///       // do something with $publicClasses.
///     }''';

    var code = '''
import 'package:$packageName/$packageName.dart';
import 'package:$packageName/src/locale_data_impl.dart';
import 'package:$packageName/src/symbols_map.dart';
import 'package:$packageName/src/$type/${getLocaleListLibraryName()}.dart';
${getSymbolsClassLibraryImport()}
${getSymbolsImports()}

part 'package:intlx/src/$type/${type}_all_data_constant.dart';
part 'package:intlx/src/$type/${type}_locale_data_constants.dart';
''';
    writeLibrary(
      libPath, 
      "${type}_locale_data", 
      getLibraryComment(false) + libraryDoc, 
      code);

  }
  
  // Write the "part of" the public interface which contains 
  // the individual locale data constants.
  void writeLocaleDataConstantsPart() {
    var localeDataConstants = localeList.map(getLocaleDataConstant).join("\n");
    
    var code = '''$localeDataConstants
''';

    writeLibrary(
      pathos.join(libPath, "src/$type/"), 
      "${type}_locale_data_constants", 
      getLibraryComment(false), 
      code, 
      "${type}_locale_data",
      true);
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
  
  
  // Write the "part of" the public interface which contains 
  // the ALL locale data constant.
  void writeAllLocaleDataPart() {
    var code = '''
/// Loads data for **all** supported locales
final LocaleData ALL = new AllLocaleDataImpl(() {
${getSymbolsMapSetterLogic()}
});''';

    writeLibrary(
      pathos.join(libPath, "src/$type/"), 
      "${type}_all_data_constant", 
      getLibraryComment(false), 
      code, 
      "${type}_locale_data",
      true);
  }
  
  String getSymbolsMapSetterLogic() {
    var symbolsMapContents = localeList.map((String locale) => 
      '  "$locale": ${getSymbolsConstant(locale)}').join(", \n");
    return '''
  $symbolsClass.map = new SymbolsMap<$symbolsClass>(
  ${getLocaleListId()}, 
  {$symbolsMapContents});''';
  }

  String getLocaleDataConstant(String locale) => 
    '''final LocaleData ${locale.toUpperCase()} = 
  new ${underscoresToCamelCase(type, true)}LocaleDataImpl(${getLocaleDataConstructorArgs(locale)});''';
  
  String getLocaleListId() => '${underscoresToCamelCase(type, false)}Locales';
    
}
