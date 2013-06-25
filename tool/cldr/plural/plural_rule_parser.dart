// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Provides a parser for the [CLDR plural rule syntax][1]
/// [1]: http://unicode.org/reports/tr35/#Language_Plural_Rules
library intlx.tool.cldr.plural.plural_rule_parser;

import 'package:parsers/parsers.dart';

final pluralParser = () {
  final lp = new LanguageParsers();
  Parser upperOrLower(String symb) => 
    lp.symbol(symb.toUpperCase()) | lp.symbol(symb.toLowerCase());
  var natural = lp.natural;
  var range = (natural + (lp.symbol('..') > natural)) ^ 
    (int min, int max) => new Range(min, max);
  var rangeList = (range | natural).sepBy1(lp.comma);
  var expr = lp.symbol('n') > (lp.symbol('mod') > natural).maybe ^ 
    (option) => option.isDefined ? option.value : null;
  var maybeNot = lp.symbol('not').maybe ^ (option) => option.isDefined;
  var isRelation = (expr + (lp.symbol('is') > maybeNot) + natural) ^ 
    (int mod, bool not, int test) => new IsRelation(mod, not, test);
  var inRelation = (expr + (maybeNot < lp.symbol('in')) + rangeList) ^ 
    (int mod, bool not, List test) => new InRelation(mod, not, test);
  var withinRelation = (expr + (maybeNot < lp.symbol('within')) + rangeList) ^ 
    (int mod, bool not, List test) => new WithInRelation(mod, not, test);
  var relation = isRelation | inRelation | withinRelation;
  var andCondition = relation.sepBy1(upperOrLower('and')) ^ 
    (List relations) => new AndCondition(relations);
  var parser = andCondition.sepBy1(upperOrLower('or')) < eof ^ 
    (List andConditions) => new Condition(andConditions);
  return parser;
}();

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
  String toDart() => andConditions.map(getDart).toList().join(' || ');
}

class AndCondition extends Dartable {
  AndCondition(this.relations);
  final List relations;
  String toDart() => relations.map(getDart).toList().join(' && ');
}

abstract class InOrWithinRelation extends Dartable {
  InOrWithinRelation(this.mod, this.not, this.test);
  final int mod;
  final bool not;
  final List test;
  String toDart() {
    var input = formatMod(mod);
    var negation = not ? '!' : '';
    var dart = test.map((arg) => arg is int ? 
      '$input == $arg' : 
      '${rangeDart(arg, input)}').toList().join(' || ');
    dart = '($dart)';
    if(not) dart = '!$dart';
    return dart;
  }
  String rangeDart(Range range, String input);
}

class InRelation extends InOrWithinRelation {
  InRelation(int mod, bool not, List test) : super(mod, not, test);
  String rangeDart(Range range, String input) =>
    'range(${(range.max + 1) - range.min}, ${range.min}).contains($input)';
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

// TODO: write some proper unit tests for the plural parser
main() {
  var test = "n in 0..99 and n is not 0 and n is not 2";
  //var test = "n is 0 OR n is not 1 AND n mod 100 in 1..19";
  //var test = "n mod 10 in 3..4,9 and n mod 100 not in 10..19,70..79,90..99";
  var condition = pluralParser.parse(test);
  print(condition.toDart());
}
