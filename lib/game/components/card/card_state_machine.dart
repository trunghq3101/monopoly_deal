import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum CardState {
  inDeck,
  inDealRegion,
  inMyDealRegion,
  inHand,
  previewing,
}

class CardStateMachine extends PositionComponent
    with
        Publisher<CardStateMachineEvent>,
        Subscriber<CardEvent>,
        ParentIsA<Card>,
        HoverCallbacks,
        TapCallbacks {
  CardState _state = CardState.inDeck;

  CardState get state => _state;

  @override
  Future<void>? onLoad() async {
    size = parent.size;
    handCursor = false;
  }

  @override
  void onNewEvent(CardEvent event, [Object? payload]) {
    switch (state) {
      case CardState.inDeck:
        if (event == CardEvent.deal) {
          assert(payload is CardEventDealPayload);
          if ((payload as CardEventDealPayload).cardId != parent.cardId) return;
          final newState =
              MainGame2.gameMap.isMyPosition(payload.playerPosition)
                  ? CardState.inMyDealRegion
                  : CardState.inDealRegion;
          changeState(newState);
          notify(CardStateMachineEvent.toDealRegion, payload);
        }
        break;
      case CardState.inHand:
        if (event == CardEvent.tapped) {
          changeState(CardState.previewing);
          notify(CardStateMachineEvent.toPreviewing);
        }
        break;
      case CardState.previewing:
        if (event == CardEvent.tapped) {
          changeState(CardState.inHand);
          notify(CardStateMachineEvent.toHand);
        }
        break;
      default:
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (state) {
      case CardState.inMyDealRegion:
        changeState(CardState.inHand);
        notify(CardStateMachineEvent.toHand);
        break;
      default:
    }
  }

  void changeState(CardState state) {
    _state = state;
    switch (state) {
      case CardState.inDeck:
        handCursor = false;
        break;
      case CardState.inDealRegion:
        handCursor = false;
        break;
      case CardState.inMyDealRegion:
        handCursor = true;
        break;
      case CardState.inHand:
        handCursor = true;
        break;
      default:
    }
  }
}

enum CardStateMachineEvent {
  toDealRegion,
  toPreviewing,
  toHand,
}
