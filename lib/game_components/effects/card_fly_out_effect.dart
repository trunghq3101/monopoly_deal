import 'package:flame/components.dart';
import 'package:flame/effects.dart';

class CardFlyOutEffect extends Component {
  CardFlyOutEffect({
    required this.by1,
    required this.by2,
  });

  final Vector2 by1;
  final Vector2 by2;

  @override
  Future<void>? onLoad() async {
    parent?.addAll([
      RotateEffect.to(0, EffectController(duration: 0.5)),
      MoveEffect.by(by1, EffectController(duration: 0.5)),
      MoveEffect.by(
        by2,
        EffectController(startDelay: 0.5, duration: 0.5),
      ),
    ]);
    TimerComponent(period: 1, removeOnFinish: true, onTick: removeFromParent);
  }
}
