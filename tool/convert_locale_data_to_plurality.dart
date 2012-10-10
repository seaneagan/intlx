
import 'dart:io';
import 'dart:json';

main() {
  getLocaleData().then(convertLocaleDataToPlurality);
}

void convertLocaleDataToPlurality(_) {
  for(String locale in localeList) {
    writePluralityJson(locale, localeDataMap[locale]);
  }
}

void writePluralityJson(String locale, Map data) {
  
  var units = data["units"];
  units.forEach((k, v){
    units[k] = {};
    if(k == 'SECOND') {
      units[k]['other'] = v[0];
    } else {
      units[k]['one'] = v[0];
      units[k]['other'] = v[1];
    }
  });

  var json = JSON.stringify(data);
  print("json: $json");
  writeFile(localeDataPath.append("new/$locale.json"), json);
}

String readFile(filePath) {
  var file = new File.fromPath(filePath);
  return file.readAsTextSync(Encoding.UTF_8);
}

void writeFile(Path path, String content) {
  var targetFile = new File.fromPath(path);
  targetFile.createSync();
  
  var raf = targetFile.openSync(FileMode.WRITE);
  raf.truncateSync(0);
  raf.writeStringSync(content, Encoding.UTF_8);
  raf.closeSync();
}

Path _localeLibPath;
Path get localeLibPath {
  if(_localeLibPath === null) {
    _localeLibPath = libPath.append("locale/");
  }
  return _localeLibPath;
}

Path _localeSrcPath;
Path get localeSrcPath {
  if(_localeSrcPath === null) {
    _localeSrcPath = libPath.append("src/locale/");
  }
  return _localeSrcPath;
}

Path _localeDataPath;
Path get localeDataPath {
  if(_localeDataPath === null) {
    _localeDataPath = libPath.append("src/data/relative_time/");
  }
  return _localeDataPath;
}

Path _libPath;
Path get libPath {
  if(_libPath === null) {
    var packageRoot = new Path(new Directory.current().path);
    _libPath = packageRoot.append("lib");
  }
  return _libPath;
}

var localeDataMap = new Map<String, Map>();
List<String> localeList;
Future getLocaleData() {
    var completer = new Completer<List<String>>();
    
    var lister = new Directory.fromPath(localeDataPath).list(false);
    
    lister.onFile = (String file) {
      String locale = new Path.fromNative(file).filenameWithoutExtension;
            
      var filePath = localeDataPath.append("$locale.json");
      String json = readFile(filePath);
      localeDataMap[locale] = JSON.parse(json);
    };
    
    lister.onDone = (completed) {
      if(completed) {
        localeList = new List.from(localeDataMap.getKeys());
        // TODO: remove once default sort argument is allowed
        localeList.sort((a, b) => a.compareTo(b));
        completer.complete(null);
      }
    };
    
    return completer.future;
}
