
library plural_locale_data;
import 'package:intlx/src/plural/internal.dart';

String getPluralStrategy(String locale) {
  String name;
  if(basicLocales.contains(locale)) { name = "Basic";
  } else if(rulelessLocales.contains(locale)) { name = "Ruleless";
  } else if(zeroOrOneLocales.contains(locale)) { name = "ZeroOrOne";
  } else if(ruLocales.contains(locale)) { name = "Ru";
  } else if(csSkLocales.contains(locale)) { name = "CsSk";
  } else if(locale == "fr") { name = "Fr";
  } else if(locale == "ar") { name = "Ar";
  } else if(locale == "pl") { name = "Pl";
  } else if(locale == "lt") { name = "Lt";
  } else if(locale == "lv") { name = "Lv";
  } else if(locale == "mt") { name = "Mt";
  } else if(locale == "ro") { name = "Ro";
  } else if(locale == "sl") { name = "Sl";
  } else { throw new ArgumentError('PluralLocale does not support the locale: "$locale"');
  }
  return "${name}PluralStrategy";
}

var pluralLocaleList = <String> []
  ..addAll(basicLocales)
  ..addAll(rulelessLocales)
  ..addAll(zeroOrOneLocales)
  ..addAll(ruLocales)
  ..addAll(csSkLocales)
  ..addAll(["fr", "ar", "pl", "lt", "lv", "mt", "ro", "sl"]);

var localeDataMap = getLocaleDataMap();

Map<String, PluralStrategy> getLocaleDataMap() {

}

const basicLocales = const <String> [
  "gu",
  "rof",
  "gl",
  "lg",
  "lb",
  "xog",
  "brx",
  "ts",
  "tn",
  "tk",
  "ksb",
  "te",
  "haw",
  "kcg",
  "ssy",
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
  "seh",
  "kl",
  "fy",
  "rm",
  "bn",
  "bg",
  "ps",
  "asa",
  "cgg",
  "om",
  "vun",
  "or",
  "xh",
  "ca",
  "pt",
  "wae",
  "chr",
  "pa",
  "jmc",
  "ha",
  "he",
  "iw",
  "fur",
  "bem",
  "ml",
  "mn",
  "ur",
  "bez",
  "mr",
  "ta",
  "ve",
  "af",
  "is",
  "it",
  "zu",
  "saq",
  "pap",
  "nl",
  "nn",
  "nah",
  "nd",
  "ne",
  "ny",
  "nyn",
  "nr",
  "tig",
  "mas",
  "rwk",
  "kaj",
  "syr",
  "kk",
  "fi",
  "fo",
  "gsw",
  "ckb",
  "ss",
  "sq",
  "sw",
  "sv",
  "st",
  "so",
  "sn",
  "ku",
  "no",
  "nb"];

const rulelessLocales = const <String> [
  "lo",
  "tr",
  "to",
  "th",
  "yo",
  "ko",
  "dz",
  "ses",
  "kde",
  "ms",
  "wo",
  "bm",
  "jv",
  "bo",
  "kea",
  "ja",
  "fa",
  "zh",
  "hu",
  "my",
  "sah",
  "kn",
  "ii",
  "az",
  "id",
  "ig",
  "ka",
  "sg",
  "vi"];

const zeroOrOneLocales = const <String> [
  "in",
  "ln",
  "fil",
  "guw",
  "wa",
  "bh",
  "nso",
  "tl",
  "ak",
  "am",
  "ti",
  "hi",
  "mg"];

const ruLocales = const <String> [
  "ru",
  "be",
  "bs",
  "hr",
  "uk",
  "sr",
  "sh"];

const csSkLocales = const <String> [
  "cs",
  "sk"];

