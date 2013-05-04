
// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?

import 'dart:io';

// current directory must be <root of this package>
Path libPath = new Path(Directory.current.path).append("lib");

// path of private (symbol) locale libraries for given type
Path getLocaleSrcPath(String type) => libPath.append("src/$type/locale/");

// path of locale specific libraries
Path localeLibPath = libPath.append("locale/");

// path to data
Path dataPath = libPath.append("src/data/");

// path to locale data for given type
Path getLocaleDataPath(String type) => dataPath.append(type);

// path to locale data file for given type and locale
Path getLocaleDataFilePath(String type, String locale) => getLocaleDataPath(type).append("$locale.json");

// path to locale data file for given type and locale
Path mainLocaleListFilePath = dataPath.append("main_locale_list.json");
