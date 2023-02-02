import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class ToDiscardBehavior extends Component
    with ParentIsA<Card>, Subscriber, HasGameReference<FlameGame>, HasGamePage {
  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.toDiscard:
        gameMaster.discard(parent.cardIndex);
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            parent.priority = 0;
          },
          removeOnFinish: true,
        ));
        parent.addAll([
          ScaleEffect.to(Vector2.all(1), LinearEffectController(0.2)),
          MoveEffect.to((MainGame.gameMap.deckCenter + Vector2(500, 0)),
              LinearEffectController(0.2))
        ]);
        break;
      default:
    }
  }
}
