
library plural;

abstract class PluralLocale {
  factory PluralLocale([String locale]) {
    if(_rulelessLocales.indexOf(locale) != -1) return const _RulelessPluralLocale();
    return const _BasicPluralLocale();
  }

  Plurality getPlurality(int n);
}

class _RulelessPluralLocale implements PluralLocale {
  const _RulelessPluralLocale();

  Plurality getPlurality(int n) => Plurality.OTHER;
}

class _BasicPluralLocale extends _RulelessPluralLocale {
  const _BasicPluralLocale();

  Plurality getPlurality(int n) => (n == 1) ? Plurality.ONE : super.getPlurality(n);
}

class Plurality {

  static const ZERO = const Plurality._("zero");
  static const ONE = const Plurality._("one");
  static const TWO = const Plurality._("two");
  static const FEW = const Plurality._("few");
  static const MANY = const Plurality._("many");
  static const OTHER = const Plurality._("other");
  
  const Plurality._(this._name);

  final String _name;

  String toString() => _name;

  static const values = const <Plurality> [ZERO, ONE, TWO, FEW, MANY, OTHER];
}

const _basicLocales = const <String> [
  "gu",
  //"rof",
  "gl",
  "lg",
  "lb",
  //"xog",
  //"brx",
  "ts",
  "tn",
  "tk",
  //"ksb",
  "te",
  //"haw",
  //"kcg",
  //"ssy",
  "de",
  "da",
  "dv",
  "el",
  "eo",
  "en",
  "teo",
  "ee",
  "eu",
  "et",
  "es",
  //"seh",
  "kl",
  "fy",
  "rm",
  "bn",
  "bg",
  "ps",
  //"asa",
  //"cgg",
  "om",
  //"vun",
  "or",
  "xh",
  "ca",
  "pt",
  //"wae",
  //"chr",
  "pa",
  //"jmc",
  "ha",
  "he",
  //"fur",
  //"bem",
  "ml",
  "mn",
  "ur",
  //"bez",
  "mr",
  "ta",
  "ve",
  "af",
  "is",
  "it",
  "zu",
  //"saq",
  //"pap",
  "nl",
  "nn",
  "no",
  //"nah",
  "nd",
  "ne",
  "ny",
  //"nyn",
  "nr",
  //"tig",
  //"mas",
  //"rwk",
  //"kaj",
  //"syr",
  "kk",
  "fi",
  "fo",
  //"gsw",
  //"ckb",
  "ss",
  "sq",
  "sw",
  "sv",
  "st",
  "so",
  "sn",
  "ku",
  "nb"];

const _rulelessLocales = const <String> [
  "lo",
  "tr",
  "to",
  "th",
  "yo",
  "ko",
  "dz",
  //"ses",
  //"kde",
  "ms",
  "wo",
  "bm",
  "jv",
  "bo",
  //"kea",
  "ja",
  "fa",
  "zh",
  "hu",
  "my",
  //"sah",
  "kn",
  "ii",
  "az",
  "id",
  "ig",
  "ka",
  "sg"];