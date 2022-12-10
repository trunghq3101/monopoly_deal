import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum CardState {
  inDeck,
  inDealRegion,
  inHand,
  previewing,
}

class CardStateMachine extends PublisherComponent<CardStateMachineEvent>
    with Subscriber<CardEvent>, ParentIsA<Card> {
  CardState _state = CardState.inDeck;

  CardState get state => _state;

  @override
  void onNewEvent(CardEvent event, [Object? payload]) {
    switch (_state) {
      case CardState.inDeck:
        if (event == CardEvent.deal) {
          payload as CardEventDealPayload;
          if (payload.cardId != parent.cardId) return;
          _state = CardState.inDealRegion;
          notify(CardStateMachineEvent.toPlayer, payload);
        }
        break;
      case CardState.inHand:
        if (event == CardEvent.tapped) {
          _state = CardState.previewing;
          notify(CardStateMachineEvent.toPreviewing);
        }
        break;
      case CardState.previewing:
        if (event == CardEvent.tapped) {
          _state = CardState.inHand;
          notify(CardStateMachineEvent.toHand);
        }
        break;
      default:
    }
  }
}

enum CardStateMachineEvent {
  toPlayer,
  toPreviewing,
  toHand,
}
