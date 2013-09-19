part of effects;

abstract class Css3TransitionEffect extends ShowHideEffect {
  static const List<String> _reservedProperties = const ['transitionProperty', 'transitionDuration'];
  final String _property;
  final Map<String, String> _animatingOverrides;

  Css3TransitionEffect(this._property, [Map<String, String> animatingOverrides])
      : _animatingOverrides = animatingOverrides == null ?
          new Map<String, String>() : new Map<String, String>.from(animatingOverrides) {
    assert(!_animatingOverrides.containsKey(_property));
    assert(!_reservedProperties.contains(_property));
    assert(_reservedProperties.every((p) => !_animatingOverrides.containsKey(p)));
  }

  @protected
  @override
  int startShow(Element element, int desiredDuration, EffectTiming timing,
                [num fractionComplete=0]) =>
      _startAnimation(true, element, desiredDuration, timing, fractionComplete);

  @protected
  @override
  int startHide(Element element, int desiredDuration, EffectTiming timing,
                [num fractionComplete=1]) =>
      _startAnimation(false, element, desiredDuration, timing, fractionComplete);

  @protected
  /**
   * Compute the value of the CSS property value given the current fraction
   * the effect is complete.
   */
  String computePropertyValue(num fractionComplete, Element element);

  @override
  void clearAnimation(Element element) {
    final restoreValues = _css3TransitionEffectValues.cleanup(element);

    var style = element.style;
    style..transitionTimingFunction = ''
         ..transitionProperty = ''
         ..transitionDuration = '';

    restoreValues.forEach(style.setProperty);
  }

  int _startAnimation(bool doingShow, Element element, int desiredDuration,
                      EffectTiming timing, num fractionComplete) {
    assert(desiredDuration > 0);
    assert(timing != null);

    final localPropsToKeep = [_property];
    localPropsToKeep.addAll(_animatingOverrides.keys);

    final localValues = _recordProperties(element, localPropsToKeep);

    _animatingOverrides.forEach(element.style.setProperty);

    String startValue = computePropertyValue(fractionComplete, element);
    String endValue = computePropertyValue(doingShow ? 1 : 0, element);

    num animationFractionLeft = doingShow ? (1 - fractionComplete) : fractionComplete;
    int actualDuration = (desiredDuration * animationFractionLeft).round();
    element.style.setProperty(_property, startValue);
    _css3TransitionEffectValues.delayStart(element, localValues,
        () => _setShowValue(element, endValue, actualDuration, timing));
    return actualDuration;
  }

  void _setShowValue(Element element, String value, num desiredDuration, EffectTiming timing) {
    final cssTimingValue = CssEffectTiming._getCssValue(timing);

    element.style
      ..transitionTimingFunction = cssTimingValue
      ..transitionProperty = _property
      ..transitionDuration = '${desiredDuration}ms'
      ..setProperty(_property, value);
  }

  static Map<String, String> _recordProperties(Element element, Iterable<String> properties) {
    final map = new Map<String, String>();

    for(final p in properties) {
      assert(!map.containsKey(p));
      map[p] = element.style.getPropertyValue(p);
    }

    return map;
  }
}

class _css3TransitionEffectValues {
  static final Expando<_css3TransitionEffectValues> _values =
      new Expando<_css3TransitionEffectValues>("_css3TransitionEffectValues");

  final Element element;
  final Map<String, String> originalValues;
  Timer timer;

  _css3TransitionEffectValues(this.element, this.originalValues);

  Map<String, String> _cleanup() {
    if(timer != null) {
      timer.cancel();
      timer = null;
    }

    return originalValues;
  }

  static void delayStart(Element element, Map<String, String> originalValues, Action0 action) {
    assert(_values[element] == null);

    final value = _values[element] = new _css3TransitionEffectValues(element, originalValues);
    // TODO(jacobr): we should be able to use runAsync for this but it does the
    // wrong thing.

    value.timer = new Timer(const Duration(milliseconds: 1), () {
      assert(value.timer != null);
      value.timer = null;
      action();
    });
  }

  static Map<String, String> cleanup(Element element) {
    final value = _values[element];
    assert(value != null);
    _values[element] = null;
    return value._cleanup();
  }
}
