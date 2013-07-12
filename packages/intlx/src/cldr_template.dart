
library intlx.cldr_template;

import 'package:parsers/parsers.dart';

// Cldr template parser
// e.g. "foo {0} bar {1} baz" -> ["foo ", 0, " bar ", 1, " baz"]
final Parser cldrTemplateParser = () {
  var nat = new LanguageParsers().natural;
  var bracedDigit = nat.between(char('{'), char('}'));
  var separator = noneOf("{").many1.record;
  return (bracedDigit | separator).many1;
}();

// A Cldr list item separator template.
class SeparatorTemplate {

  // Parse a String representation into a Map.
  // TODO: link to cldr spec for this
  // Examples:
  //     "{0}, {1}" -> {"separator" : ", "}
  //     "foo {0} bar {1} baz" -> {"head" : "foo ", "separator" : " bar ", tail : " baz"}
  static Map parse(String text) {
    List result = cldrTemplateParser.parse(text);
    // "{0}" is now 0, so first item after that is separator
    var data = {
      "separator": result[result.indexOf(0) + 1]
    };
    // "head" and "tail" are very uncommon, only add if necessary
    if(result.first is String) data["head"] = result.first;
    if(result.last is String) data["tail"] = result.last;
    return data;
  }
  
  final String head, separator, tail;

  SeparatorTemplate({this.head, this.separator, this.tail});
  
}
