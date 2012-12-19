//condition     = and_condition ('or' and_condition)*
//and_condition = relation ('and' relation)*
//relation      = is_relation | in_relation | within_relation
//is_relation   = expr 'is' ('not')? value
//in_relation   = expr ('not')? 'in' range_list
//within_relation = expr ('not')? 'within' range_list
//expr          = 'n' ('mod' value)?
//range_list    = (range | value) (',' range_list)*
//value         = digit+
//digit         = 0|1|2|3|4|5|6|7|8|9
//range         = value'..'value

import 'package:parsers/parsers.dart';


Parser get pluralParser {
  if(_pluralParser == null) {
    final lp = new LanguageParsers();
    Parser upperOrLower(String symb) => lp.symbol(symb.toUpperCase()) | lp.symbol(symb.toLowerCase());
    var natural = lp.natural;
    var range = (natural + (lp.symbol('..') > natural)) ^ (int min, int max) => new Range(min, max);
    var rangeList = (range | natural).sepBy1(lp.comma);
    var expr = lp.symbol('n') > (lp.symbol('mod') > natural).maybe ^ (option) => option.isDefined ? option.value : null;
    var maybeNot = lp.symbol('not').maybe ^ (option) => option.isDefined;
    var isRelation = (expr + (lp.symbol('is') > maybeNot) + natural) ^ (int mod, bool not, int test) => new IsRelation(mod, not, test);
    var inRelation = (expr + (maybeNot < lp.symbol('in')) + rangeList) ^ (int mod, bool not, List test) => new InRelation(mod, not, test);
    var withinRelation = (expr + (maybeNot < lp.symbol('within')) + rangeList) ^ (int mod, bool not, List test) => new WithInRelation(mod, not, test);
    var relation = isRelation | inRelation | withinRelation;
    var andCondition = relation.sepBy1(upperOrLower('and')) ^ (List relations) => new AndCondition(relations);
    _pluralParser = andCondition.sepBy1(upperOrLower('or')) < eof ^ (List andConditions) => new Condition(andConditions);
  }
  return _pluralParser;
}
Parser _pluralParser;


abstract class Dartable {
  String toDart();
}

String getDart(Dartable dartable) => dartable.toDart();

class Range {
  Range(this.min, this.max);
  final int min, max;
}

class Condition extends Dartable {
  Condition(this.andConditions);
  final List<AndCondition> andConditions;
  String toDart() => Strings.join(andConditions.map(getDart), ' || ');
}

class AndCondition extends Dartable {
  AndCondition(this.relations);
  final List relations;
  String toDart() => Strings.join(relations.map(getDart), ' && ');
}

abstract class InOrWithinRelation extends Dartable {
  InOrWithinRelation(this.mod, this.not, this.test);
  final int mod;
  final bool not;
  final List test;
  String toDart() {
    var input = formatMod(mod);
    var negation = not ? '!' : '';
    var dart = Strings.join(test.map((arg) => arg is int ? '$input == $arg' : '${rangeDart(arg, input)}'), ' || ');
    dart = '($dart)';
    if(not) dart = '!$dart';
    return dart;
  }
  String rangeDart(Range range, String input);
}

class InRelation extends InOrWithinRelation {
  InRelation(int mod, bool not, List test) : super(mod, not, test);
  String rangeDart(Range range, String input) {
    var i = range.min;
    var list = <int> [];
    for(var i = range.min; i <= range.max; i++) {
      list.add(i);
    }
    return '$list.contains($input)';
  }
}

class WithInRelation extends InOrWithinRelation {
  WithInRelation(int mod, bool not, List test) : super(mod, not, test);
  String rangeDart(Range range, String input) {
    return '(n >= ${range.min} && n <= ${range.max})';
  }
}

class IsRelation extends Dartable {
  IsRelation(this.mod, this.not, this.test);
  final int mod;
  final bool not;
  final int test;
  String toDart() {
    var input = formatMod(mod);
    var op = not ? '!=' : '==';
    return '$input $op $test';
  }
}

String formatMod(int mod) => mod == null ? 'n' : 'n % $mod';

main() {
  var test = "n within 0..2 and n is not 0 and n is not 2";
  //var test = "n is 0 OR n is not 1 AND n mod 100 in 1..19";
  //var test = "n mod 10 in 3..4,9 and n mod 100 not in 10..19,70..79,90..99";
  var condition = pluralParser.parse(test);
  print(condition.toDart());
}
