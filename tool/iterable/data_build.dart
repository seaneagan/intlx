
import 'package:parsers/parsers.dart';
import '../cldr_data_proxy.dart';

main() {
  print(listPatternParser.parse("{0} and {1}").map((i) => i.runtimeType).join("::"));
  // new IterableDataProxy().proxy();
}

class IterableDataProxy extends CldrDataProxy {
  IterableDataProxy() : super("listPatterns/listPattern", "iterable");

  transformJson(String locale, Map unitsData) => mapValues(unitsData, listPatternParser.parse);

}

// parses list pattern into a List of content and substition indexes
// e.g. "{0}, {1}" -> [0, ", ", 1]
Parser get listPatternParser {
  if(_listPatternParser == null) {
    var bracedDigit = (digit ^ int.parse).between(char('{'), char('}'));
    var separator = anyChar.manyUntil(bracedDigit.lookAhead).record;
    _listPatternParser = (bracedDigit | separator).many; // ^ (list) => list.where((item) => item != '').toList();
  }
  return _listPatternParser;
}
Parser _listPatternParser;

// TODO: replace with resolution of http://dartbug.com/9590 
Map mapValues(Map map, valueMapper(key)) => map.keys.fold({}, (result, key) {
  result[key] = valueMapper(map[key]);
  return result;
});
