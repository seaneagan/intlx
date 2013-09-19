part of effects;

class FadeEffect extends Css3TransitionEffect {
  FadeEffect() : super('opacity');
  
  String computePropertyValue(num fractionComplete, Element element) =>
      '$fractionComplete';

  // Infer the fraction complete from the opacity.
  num computeFractionComplete(Element element) =>
      double.parse(element.getComputedStyle().opacity);
}

// TODO: orientation
class ShrinkEffect extends Css3TransitionEffect {
  ShrinkEffect() : super('max-height', {'overflow': 'hidden'});

  @protected
  @override
  String computePropertyValue(num fractionComplete, Element element) =>
      fractionComplete <= 0 ?
          '0' : '${element.scrollHeight * fractionComplete}px';
  
  num computeFractionComplete(Element element) {
    num scrollHeight = element.scrollHeight;
    if (scrollHeight > 0) {
      return math.min(1, element.clientHeight / element.scrollHeight);
    }
  }
}

class ScaleEffect extends Css3TransitionEffect {
  Orientation orientation;
  
  static Map<String, String> _computeValues(HorizontalAlignment xOffset,
      VerticalAlignment yOffset) {
    if(xOffset == null) {
      xOffset = HorizontalAlignment.CENTER;
    }
    final xoValue = xOffset.name;

    if(yOffset == null) {
      yOffset = VerticalAlignment.MIDDLE;
    }
    final yoValue = (yOffset == VerticalAlignment.MIDDLE) ? 'center' : yOffset.name;

    return {'-webkit-transform-origin' : '$xoValue $yoValue'};
  }

  ScaleEffect({this.orientation, HorizontalAlignment xOffset,
      VerticalAlignment yOffset})
      : super('-webkit-transform', _computeValues(xOffset, yOffset));

  String computePropertyValue(num fractionComplete, Element element) {
    switch(orientation) {
      case Orientation.VERTICAL:
        return 'scale(1, $fractionComplete)';
      case Orientation.HORIZONTAL:
        return 'scale($fractionComplete, 1)';
      default:
        return 'scale($fractionComplete, $fractionComplete)';
    }
  }

  num computeFractionComplete(Element element) => null;
}

class SpinEffect extends Css3TransitionEffect {
  SpinEffect() : super('-webkit-transform');
  
  String computePropertyValue(num fractionComplete, Element element) =>
      'perspective(600px) rotateX(${(1-fractionComplete) * 90}deg)';
}

class DoorEffect extends Css3TransitionEffect {
  DoorEffect() : super('-webkit-transform', {'-webkit-transform-origin': '0% 50%'});
  
  String computePropertyValue(num fractionComplete, Element element) =>
      'perspective(600px) rotateX(${(1-fractionComplete) * 90}deg)';
}

class SlideEffect extends Css3TransitionEffect {
  final HorizontalAlignment xStart;
  final VerticalAlignment yStart;

  SlideEffect({this.xStart, this.yStart}) : super('-webkit-transform'); 

  String computePropertyValue(num fractionComplete, Element _) {
    if (fractionComplete >= 1) {
      return 'translate3d(0,0,0)';
    }
    var offset = '${(1 - fractionComplete) * 100}';
    String xComponent;
    switch(xStart) {
      case HorizontalAlignment.LEFT:
        xComponent = '-$offset%';
        break;
      case HorizontalAlignment.RIGHT:
        xComponent = '$offset%';
        break;
      case HorizontalAlignment.CENTER:
      default:
        xComponent = '0';
        break;
    }

    String yComponent;
    switch(yStart) {
      case VerticalAlignment.TOP:
        yComponent = '-$offset%';
        break;
      case VerticalAlignment.BOTTOM:
        yComponent = '$offset%';
        break;
      case VerticalAlignment.MIDDLE:
      default:
        yComponent = '0';
        break;
    }
    return 'translate3d($xComponent, $yComponent, 0)';
  }
}
