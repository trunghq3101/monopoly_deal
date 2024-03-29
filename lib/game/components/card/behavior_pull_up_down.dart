import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class PullUpDownBehavior extends Component
    with ParentIsA<PositionComponent>, Subscriber {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.pullDown:
        parent.add(MoveEffect.by(
            Vector2(0, MainGame.gameMap.cardSizeInHand.y * 0.8),
            LinearEffectController(0.2)));
        break;
      case CardStateMachineEvent.pullUp:
        parent.add(MoveEffect.by(
            Vector2(0, -MainGame.gameMap.cardSizeInHand.y * 0.8),
            LinearEffectController(0.2)));
        break;
      default:
    }
  }
}
