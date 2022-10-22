import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game_components/effects/card_fly_out_effect.dart';

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
    final h = (children.length / 2).ceil();
    for (var i = h; i < children.length; i++) {
      children.elementAt(i).add(
            CardFlyOutEffect(
              by1: Vector2((i - h - h / 2) * 1600, 0),
              by2: Vector2((i - h - h / 2) * -1600, 4000),
            ),
          );
    }
    add(
      TimerComponent(
        period: 0.8,
        onTick: () {
          for (var c in children.take(h)) {
            c.add(ShowUpEffect(EffectController(duration: 0.5)));
          }
        },
      ),
    );
    add(
      TimerComponent(
        period: 1.3,
        onTick: () {
          for (var c in children.take(h)) {
            if (parent != null) c.changeParent(parent!);
          }
        },
      ),
    );
    add(
      TimerComponent(
        period: 1.4,
        onTick: () {
          removeFromParent();
        },
      ),
    );
  }
}
