
import 'dart:io';

Path _libPath;
Path get libPath {
  if(_libPath == null) {
    var packageRoot = new Path(new Directory.current().path);
    _libPath = packageRoot.append("lib");
  }
  return _libPath;
}

Path _localeLibPath;
Path get localeLibPath {
  if(_localeLibPath == null) {
    _localeLibPath = libPath.append("locale/");
  }
  return _localeLibPath;
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath == null) {
    _localeDataPath = libPath.append("src/data/");
  }
  return _localeDataPath;
}
