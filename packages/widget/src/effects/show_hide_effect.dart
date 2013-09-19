part of effects;

abstract class ShowHideEffect {
  const ShowHideEffect();

  @protected
  int startShow(Element element, num desiredDuration, EffectTiming timing, [num fractionComplete=0]) {
    return 0;
  }

  @protected
  int startHide(Element element, num desiredDuration, EffectTiming timing, [num fractionComplete=1]) {
    return 0;
  }

  @protected
  /**
   * Return the fraction that the animation is complete.
   * 0 indicates the animation has not started, 1 indicates the animation is
   * complete.  Returns null if it cannot be determined what fraction the
   * animation is complete.
   */
  num computeFractionComplete(Element element) => null;
  
  @protected
  void clearAnimation(Element element) {
    // no op here
  }

  static ShowHideEffect _orDefault(ShowHideEffect effect) =>
      effect == null ? const _NoOpShowHideEffect() : effect;
}

class _NoOpShowHideEffect extends ShowHideEffect {
  const _NoOpShowHideEffect();
}


