import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';

class ShowUpEffect extends Effect {
  ShowUpEffect(super.controller);

  @override
  void apply(double progress) {}
}

class PickUpRegion extends PositionComponent with TapCallbacks {
  PickUpRegion({
    super.size,
    super.position,
    super.anchor,
  });

  bool _tapped = false;

  @override
  void onTapDown(TapDownEvent event) {
    if (_tapped) {
      return;
    }
    _tapped = true;
    for (var i = 0; i < children.length; i++) {
      children.elementAt(i).addAll([
        RotateEffect.to(0, LinearEffectController(0.3)),
        SequenceEffect([
          MoveEffect.by(
            Vector2((i + 0.5 - children.length / 2) * 1600, 0),
            LinearEffectController(0.5),
          ),
          MoveEffect.by(
            Vector2((i + 0.5 - children.length / 2) * -1600, 4000),
            LinearEffectController(0.5),
          ),
        ]),
      ]);
    }
  }
}
