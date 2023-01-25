import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToggleSelectingForDiscardBehavior extends Component
    with
        Publisher,
        Subscriber,
        ParentIsA<PositionComponent>,
        HasGameReference<FlameGame>,
        HasGamePage {
  PositionComponent? _inHandPlaceholder;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toSelectingForDiscard:
        _inHandPlaceholder = PositionComponent(
            angle: parent.angle,
            position: parent.position,
            scale: parent.scale,
            priority: parent.priority);
        add(TimerComponent(
          period: 0.01,
          removeOnFinish: true,
          onTick: () {
            parent.priority = 10007 +
                world.children
                    .query<Card>()
                    .where((e) => e.state == CardState.inSelectingForDiscard)
                    .length;
          },
        ));
        parent.addAll([
          MoveEffect.to(Vector2(0, 0), LinearEffectController(0.1)),
          RotateEffect.to(
            0,
            LinearEffectController(0.1),
            onComplete: () {
              notify(
                  Event(event.reverseEvent!)..payload = event.reversePayload);
            },
          ),
        ]);
        break;
      case CardStateMachineEvent.toHandFromDiscard:
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
            _inHandPlaceholder!.angle,
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
