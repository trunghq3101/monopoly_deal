import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class TogglePreviewingBehavior extends Component
    with Publisher, Subscriber, ParentIsA<PositionComponent> {
  PositionComponent? _inHandPlaceholder;
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toPreviewing:
        _inHandPlaceholder = PositionComponent(
            angle: parent.angle,
            position: parent.position,
            scale: parent.scale,
            priority: parent.priority);
        add(TimerComponent(
          period: 0.01,
          removeOnFinish: true,
          onTick: () {
            parent.priority = 10000;
          },
        ));
        parent.addAll([
          MoveEffect.to(Vector2(0, 0), LinearEffectController(0.1)),
          RotateEffect.to(0, LinearEffectController(0.1)),
          ScaleEffect.by(
            Vector2.all(1.5),
            LinearEffectController(0.1),
            onComplete: () {
              notify(
                  Event(event.reverseEvent!)..payload = event.reversePayload);
            },
          ),
        ]);
        break;
      case CardStateMachineEvent.toHand:
      case CardStateMachineEvent.swapBackToHand:
        if (_inHandPlaceholder == null) return;
        add(TimerComponent(
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
            _inHandPlaceholder!.scale,
            LinearEffectController(0.1),
            onComplete: () {
              notify(
                  Event(event.reverseEvent!)..payload = event.reversePayload);
            },
          ),
        ]);
        break;
      default:
    }
  }
}
