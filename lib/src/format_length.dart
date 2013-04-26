
part of intlx;

/// Enum to represent format lengths.
class FormatLength {
  static const SHORT = const FormatLength._("SHORT", 0);
  static const LONG = const FormatLength._("LONG", 1);

  const FormatLength._(this._name, this._index);

  final String _name;
  final int _index;
}
