import 'dart:async';
import 'dart:html';
import 'package:bot/bot.dart';
import 'package:widget/effects.dart';
import 'package:widget/widget.dart';

void main() {
  window.onHashChange.listen(_onNavigate);

  //
  // ShowHide Demo
  //
  final effects =
    {
     'Default' : null,
     'Door': new DoorEffect(),
     'Fade': new FadeEffect(),
     'Scale': new ScaleEffect(),
     'Scale [roll up]': new ScaleEffect(orientation: Orientation.VERTICAL, yOffset: VerticalAlignment.TOP),
     'Scale [corner]': new ScaleEffect(yOffset: VerticalAlignment.TOP, xOffset: HorizontalAlignment.LEFT),
     'Shrink': new ShrinkEffect(),
     'Spin': new SpinEffect()
  };

  final effectsDiv = query('.demo.showhide .effects');
  effects.forEach((name, effect) {
    final button = new ButtonElement()
      ..appendText(name)
      ..classes.add('btn')
      ..onClick.listen((_) => _showHideDemo_toggle(effect));
    effectsDiv.append(button);
  });
}

void _showHideDemo_toggle(ShowHideEffect effect) {
  queryAll('.demo.showhide .logo_wrapper > img').forEach((Element e) {
    ShowHide.toggle(e, effect: effect);
  });
}

void _onNavigate(HashChangeEvent e) {
  final matches = _hashBitRegEx.firstMatch(e.newUrl);
  if(matches != null) {
    final elementId = matches[1];

    final element = query('#$elementId');
    if(element != null) {
      _flashElement(element);
    }
  }
}

void _flashElement(Element element) {
  element.classes.add(_highlightedClass);
  new Timer(const Duration(seconds: 1), () => element.classes.remove(_highlightedClass));
}

const _highlightedClass = 'highlighted';

// these are the rules applied by build.dart
final _hashBitRegEx = new RegExp(r'.*#([a-z_]+)');
