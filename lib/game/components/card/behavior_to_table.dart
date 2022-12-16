import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToTableBehavior extends Component
    with ParentIsA<PositionComponent>, Subscriber {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toTable:
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
          },
          removeOnFinish: true,
        ));
        parent.addAll([
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to(Vector2(0, 700), LinearEffectController(0.2))
        ]);
        break;
      default:
    }
  }
}
