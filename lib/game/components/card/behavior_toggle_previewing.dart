import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class TogglePreviewingBehavior extends Component
    with Subscriber, ParentIsA<PositionComponent> {
  PositionComponent? _inHandPlaceholder;
  @override
  void onNewEvent(Object event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.toPreviewing:
        _inHandPlaceholder = PositionComponent(
            angle: parent.angle,
            position: parent.position,
            scale: parent.scale,
            priority: parent.priority);
        parent.add(TimerComponent(
          period: 0.01,
          removeOnFinish: true,
          onTick: () {
            parent.priority = 10000;
          },
        ));
        parent.addAll([
          MoveEffect.to(Vector2(0, -500), LinearEffectController(0.1)),
          RotateEffect.to(0, LinearEffectController(0.1)),
          ScaleEffect.by(Vector2.all(1.6), LinearEffectController(0.1)),
        ]);
        break;
      case CardStateMachineEvent.toHand:
      case CardStateMachineEvent.swapBackToHand:
        if (_inHandPlaceholder == null) return;
        parent.add(TimerComponent(
          period: 0.01,
          removeOnFinish: true,
          onTick: () {
            parent.priority = _inHandPlaceholder!.priority;
          },
        ));
        parent.addAll([
          MoveEffect.to(
              _inHandPlaceholder!.position, LinearEffectController(0.1)),
          RotateEffect.to(
              _inHandPlaceholder!.angle, LinearEffectController(0.1)),
          ScaleEffect.to(
              _inHandPlaceholder!.scale, LinearEffectController(0.1)),
        ]);
        break;
      default:
    }
  }
}
