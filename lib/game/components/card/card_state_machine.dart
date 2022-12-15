import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum CardState {
  inDeck,
  inDealRegion,
  inMyDealRegion,
  inHand,
  inHandCollapsed,
  inPreviewing,
}

class CardStateMachine extends PositionComponent
    with Publisher, Subscriber, ParentIsA<Card>, HoverCallbacks, TapCallbacks {
  CardState _state = CardState.inDeck;

  CardState get state => _state;

  @override
  Future<void>? onLoad() async {
    size = parent.size;
    handCursor = false;
  }

  @override
  void onNewEvent(Object event, [Object? payload]) {
    switch (state) {
      case CardState.inDeck:
        if (event == CardEvent.deal) {
          assert(payload is CardDealPayload);
          if ((payload as CardDealPayload).cardId != parent.cardId) return;
          final newState =
              MainGame2.gameMap.isMyPosition(payload.playerPosition)
                  ? CardState.inMyDealRegion
                  : CardState.inDealRegion;
          changeState(newState);
          notify(CardStateMachineEvent.toDealRegion, payload);
        }
        break;
      case CardState.inMyDealRegion:
        if (event == CardEvent.pickUp) {
          assert(payload is CardPickUpPayload);
          if ((payload as CardPickUpPayload).cardId != parent.cardId) {
            return;
          }
          changeState(CardState.inHand);
          notify(CardStateMachineEvent.pickUpToHand, payload);
        }
        break;
      case CardState.inHand:
        switch (event) {
          case HandToggleButtonEvent.tapHide:
            changeState(CardState.inHandCollapsed);
            notify(CardStateMachineEvent.pullDown);
            break;
          case CardEvent.preview:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inPreviewing);
            notify(CardStateMachineEvent.toPreviewing);
            break;
          default:
        }
        break;
      case CardState.inHandCollapsed:
        if (event == HandToggleButtonEvent.tapShow) {
          changeState(CardState.inHand);
          notify(CardStateMachineEvent.pullUp);
        }
        break;
      case CardState.inPreviewing:
        switch (event) {
          case CardEvent.previewRevert:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inHand);
            notify(CardStateMachineEvent.toHand);
            break;
          case CardEvent.previewSwap:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inHand);
            notify(CardStateMachineEvent.swapBackToHand);
            break;
          default:
        }
        break;
      default:
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    switch (state) {
      case CardState.inMyDealRegion:
        notify(CardStateMachineEvent.tapOnMyDealRegion);
        break;
      case CardState.inHand:
        notify(
          CardStateMachineEvent.tapWhileInHand,
          CardIdPayload(parent.cardId),
        );
        break;
      case CardState.inPreviewing:
        notify(
          CardStateMachineEvent.tapWhileInPreviewing,
          CardIdPayload(parent.cardId),
        );
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
