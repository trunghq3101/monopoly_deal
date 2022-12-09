import 'package:flame/components.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import 'publisher_card.dart';

enum CardState {
  initial,
  inHand,
  previewing,
}

class CardStateMachine extends Component
    with Publisher<CardStateMachineEvent>, Subscriber<CardEvent> {
  CardState _state = CardState.inHand;
  @override
  void onNewEvent(CardEvent event) {
    switch (_state) {
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
  toPreviewing,
  toHand,
}
