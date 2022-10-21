import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game_components/card.dart';

typedef FlyOutEffect = MoveEffect;

class ShowUpEffect extends Effect {
  ShowUpEffect(super.controller);

  @override
  void apply(double progress) {}
}

class PickUpRegion extends PositionComponent with TapCallbacks {
  PickUpRegion({super.position})
      : super(
          size: Card.kCardSize * 1.5,
          anchor: Anchor.center,
        );

  bool _tapped = false;

  @override
  void onTapDown(TapDownEvent event) {
    if (_tapped) {
      return;
    }
    _tapped = true;
    for (var c in children.take(2)) {
      c.add(FlyOutEffect.by(Vector2(0, 4000), EffectController(duration: 0.5)));
    }
    add(
      TimerComponent(
        period: 0.8,
        onTick: () {
          for (var c in children.skip(2)) {
            c.add(ShowUpEffect(EffectController(duration: 0.5)));
          }
        },
      ),
    );
    add(
      TimerComponent(
        period: 1.3,
        onTick: () {
          removeAll(children.take(2));
          for (var c in children.skip(2)) {
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
