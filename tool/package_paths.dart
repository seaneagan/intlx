
// TODO: merge this library with intl/test/data_directory.dart.
// move under lib/src since used by both tool and test dirs?

import 'dart:io';

// current directory must be <root of this package>
Path libPath = new Path(new Directory.current().path).append("lib");

// path of locale specific libraries
Path localeLibPath = libPath.append("locale/");

// path to locale data storage
Path localeDataPath = libPath.append("src/data/");
