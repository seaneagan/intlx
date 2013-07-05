
// This library contains things which aren't really specific to this package,
// but don't currently exist in any common libraries
library intlx.util;

// TODO: replace with resolution of http://dartbug.com/9590 
Map mapValues(Map map, valueMapper(value)) => map.keys.fold({}, (result, key) {
  result[key] = valueMapper(map[key]);
  return result;
});

// TODO: create common typedef library ?
typedef R Unary<T, R>(T);
typedef void Action();

// TODO: create common callback library ?
noop(x) => x;

// TODO: replace this with the resolution of http://dartbug.com/1236
// TODO: change fallback to a callback for lazy evaluation
ifNull(value, fallback) => value == null ? fallback : value;

// works for Strings, Iterables, and Maps
// TODO: change fallback to a callback for lazy evaluation
ifEmpty(value, fallback) => value.isEmpty ? fallback : value;

// TODO: is there a bug to add this to a core library?
// TODO: named parameters instead ?
Iterable<int> range(int length, [int start = 0, int step = 1]) => 
  new Iterable.generate(length, (int index) => start + index * step);

// uppercase or lowercase the first charater of a String
String withCapitalization(String s, bool capitalized) {
  var firstLetter = s[0];
  firstLetter = capitalized ? 
    firstLetter.toUpperCase() : 
    firstLetter.toLowerCase();
  return firstLetter + s.substring(1);
}

// convert an underscore separated String to camel case.
// e.g. "foo_bar" -> "fooBar" or "FooBar" (capitalized == true)
String underscoresToCamelCase(String underscores, bool capitalized) { 
  var camel = underscores.splitMapJoin(
    "_", 
    onMatch: (_) => "", 
    onNonMatch: (String segment) => withCapitalization(segment, true));
  return withCapitalization(camel, capitalized);
}

// TODO: make Intl._shortLocale public instead of duplicating it here
String baseLocale(String aLocale) {
  if (aLocale.length < 2) return aLocale;
  final noUnderscores = new RegExp(r'[^_]*');
  return noUnderscores.stringMatch(aLocale.toLowerCase());
}
