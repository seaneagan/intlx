
import 'package:parsers/parsers.dart';

// CLDR template parser
// e.g. "{0}, {1}" -> [0, ", ", 1]
// TODO: is there a spec. for this to link to ?
final Parser cldrTemplateParser = () {
  var nat = new LanguageParsers().natural;
  var bracedDigit = nat.between(char('{'), char('}'));
  var separator = noneOf("{").many1.record;
  return (bracedDigit | separator).many1;
}();

// render a template object produced by the parser
String renderCldrTemplate(
  List template, 
  Iterable elements, 
  staticSegmentTransform(segment)) => 
  template.map((e) => 
    e is int ? 
      elements.elementAt(e) : 
      staticSegmentTransform(e)).join();

// TODO: add proper unit tests for this parser
main() {
  print(cldrTemplateParser.parse("{0} hours"));
  print(cldrTemplateParser.parse("In {0} days"));
  print(cldrTemplateParser.parse("In {500} days"));
}
