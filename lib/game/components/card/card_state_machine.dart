import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

enum CardState {
  inAnimation,
  inDeck,
  inDealRegion,
  inMyDealRegion,
  inHand,
  inHandCollapsed,
  inPreviewing,
  onTable,
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
  void onNewEvent(Event event) {
    final payload = event.payload;
    switch (state) {
      case CardState.inAnimation:
        if (event.eventIdentifier == CardStateMachineEvent.animationCompleted) {
          assert(payload is CardState);
          changeState(payload as CardState);
        }
        break;
      case CardState.inDeck:
        if (event.eventIdentifier == CardEvent.deal) {
          assert(payload is CardDealPayload);
          if ((payload as CardDealPayload).cardId != parent.cardId) {
            return;
          }
          final newState =
              MainGame2.gameMap.isMyPosition(payload.playerPosition)
                  ? CardState.inMyDealRegion
                  : CardState.inDealRegion;
          changeState(CardState.inAnimation);
          notify(Event(CardStateMachineEvent.toDealRegion)
            ..payload = payload
            ..reverseEvent = CardStateMachineEvent.animationCompleted
            ..reversePayload = newState);
        }
        break;
      case CardState.inMyDealRegion:
        if (event.eventIdentifier == CardEvent.pickUp) {
          assert(payload is CardPickUpPayload);
          if ((payload as CardPickUpPayload).cardId != parent.cardId) {
            return;
          }
          changeState(CardState.inAnimation);
          notify(Event(CardStateMachineEvent.pickUpToHand)
            ..payload = payload
            ..reverseEvent = CardStateMachineEvent.animationCompleted
            ..reversePayload = CardState.inHand);
        }
        break;
      case CardState.inHand:
        switch (event.eventIdentifier) {
          case HandToggleButtonEvent.tapHide:
          case PlaceCardButtonEvent.tap:
            changeState(CardState.inHandCollapsed);
            notify(Event(CardStateMachineEvent.pullDown));
            break;
          case CardEvent.preview:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inPreviewing);
            notify(Event(CardStateMachineEvent.toPreviewing));
            break;
          default:
        }
        break;
      case CardState.inHandCollapsed:
        if (event.eventIdentifier == HandToggleButtonEvent.tapShow) {
          changeState(CardState.inHand);
          notify(Event(CardStateMachineEvent.pullUp));
        }
        break;
      case CardState.inPreviewing:
        switch (event.eventIdentifier) {
          case CardEvent.previewRevert:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inHand);
            notify(Event(CardStateMachineEvent.toHand));
            break;
          case CardEvent.previewSwap:
            assert(payload is CardIdPayload);
            payload as CardIdPayload;
            if (parent.cardId != payload.cardId) break;
            changeState(CardState.inHand);
            notify(Event(CardStateMachineEvent.swapBackToHand));
            break;
          case PlaceCardButtonEvent.tap:
            changeState(CardState.onTable);
            notify(Event(CardStateMachineEvent.toTable));
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
        notify(Event(CardStateMachineEvent.tapOnMyDealRegion));
        break;
      case CardState.inHand:
        notify(
          Event(CardStateMachineEvent.tapWhileInHand)
            ..payload = CardIdPayload(parent.cardId),
        );
        break;
      case CardState.inPreviewing:
        notify(
          Event(CardStateMachineEvent.tapWhileInPreviewing)
            ..payload = CardIdPayload(parent.cardId),
        );
        break;
      default:
    }
  }

  void changeState(CardState state) {
    _state = state;
    switch (state) {
      case CardState.inDeck:
      case CardState.inHandCollapsed:
      case CardState.inDealRegion:
      case CardState.onTable:
        handCursor = false;
        break;
      case CardState.inMyDealRegion:
      case CardState.inHand:
        handCursor = true;
        break;
      default:
    }
  }
}
