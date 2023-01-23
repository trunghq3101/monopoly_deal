import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class RepositionInHandBehavior extends Component
    with ParentIsA<Card>, Subscriber {
  @override
  void onNewEvent(Event event) {
    final payload = event.payload;
    switch (event.eventIdentifier) {
      case CardEvent.reposition:
        assert(payload is CardRepositionPayload);
        payload as CardRepositionPayload;
        if (payload.cardIndex != parent.cardIndex) return;
        parent.addAll([
          MoveEffect.to(
            payload.inHandPosition.position,
            LinearEffectController(0.1),
          ),
          RotateEffect.to(
            payload.inHandPosition.angle,
            LinearEffectController(0.1),
          )
        ]);
        break;
      default:
    }
  }
}
