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
  inDiscardToEndTurn,
  inSelectingForDiscard,
  inWaitingForDiscard,
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
          changeState(payload as CardState);
        }
        break;
      case CardState.inDeck:
        if (event.eventIdentifier == CardEvent.deal) {
          if ((payload as CardDealPayload).cardIndex != parent.cardIndex) {
            return;
          }
          final newState = MainGame.gameMap.isMyPosition(payload.playerPosition)
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
          if ((payload as CardPickUpPayload).cardIndex != parent.cardIndex) {
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
            payload as CardIndexPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            changeState(CardState.inAnimation);
            notify(Event(CardStateMachineEvent.toPreviewing)
              ..reverseEvent = CardStateMachineEvent.animationCompleted
              ..reversePayload = CardState.inPreviewing);
            break;
          case CardEvent.reposition:
            payload as CardRepositionPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            notify(event);
            break;
          case CardEvent.discarding:
            payload as CardIndexPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            changeState(CardState.inDiscardToEndTurn);
            break;
          default:
        }
        break;
      case CardState.inHandCollapsed:
        switch (event.eventIdentifier) {
          case HandToggleButtonEvent.tapShow:
            changeState(CardState.inHand);
            notify(Event(CardStateMachineEvent.pullUp));
            break;
          case CardDeckEvent.pickUp:
            changeState(CardState.inHand);
            break;
          case CardEvent.reposition:
            payload as CardRepositionPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            notify(event);
            break;
          default:
        }
        break;
      case CardState.inPreviewing:
        switch (event.eventIdentifier) {
          case CardEvent.previewRevert:
            payload as CardIndexPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            changeState(CardState.inAnimation);
            notify(Event(CardStateMachineEvent.toHand)
              ..reverseEvent = CardStateMachineEvent.animationCompleted
              ..reversePayload = CardState.inHand);
            break;
          case CardEvent.previewSwap:
            payload as CardIndexPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            changeState(CardState.inAnimation);
            notify(Event(CardStateMachineEvent.swapBackToHand)
              ..reverseEvent = CardStateMachineEvent.animationCompleted
              ..reversePayload = CardState.inHand);
            break;
          case PlaceCardButtonEvent.tap:
            changeState(CardState.onTable);
            notify(Event(CardStateMachineEvent.toTable));
            break;
          default:
        }
        break;
      case CardState.inDiscardToEndTurn:
        switch (event.eventIdentifier) {
          case CardEvent.toWaitingForDiscard:
            payload as CardIndexPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            changeState(CardState.inWaitingForDiscard);
            break;
          case DiscardAreaEvent.cancel:
            changeState(CardState.inHand);
            break;
        }
        break;
      case CardState.inSelectingForDiscard:
        switch (event.eventIdentifier) {
          case DiscardAreaEvent.cancel:
            changeState(CardState.inAnimation);
            notify(Event(CardStateMachineEvent.toHandFromDiscard)
              ..reverseEvent = CardStateMachineEvent.animationCompleted
              ..reversePayload = CardState.inHand);
            break;
          case DiscardAreaEvent.discard:
            changeState(CardState.onTable);
            notify(Event(CardStateMachineEvent.toDiscard));
            break;
        }
        break;
      case CardState.inWaitingForDiscard:
        switch (event.eventIdentifier) {
          case DiscardAreaEvent.cancel:
            changeState(CardState.inHand);
            break;
          case CardEvent.reposition:
            payload as CardRepositionPayload;
            if (parent.cardIndex != payload.cardIndex) break;
            notify(event);
            changeState(CardState.inHand);
            break;
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
            ..payload = CardIndexPayload(parent.cardIndex),
        );
        break;
      case CardState.inPreviewing:
        notify(
          Event(CardStateMachineEvent.tapWhileInPreviewing)
            ..payload = CardIndexPayload(parent.cardIndex),
        );
        break;
      case CardState.inDiscardToEndTurn:
        changeState(CardState.inAnimation);
        notify(Event(CardStateMachineEvent.toSelectingForDiscard)
          ..reverseEvent = CardStateMachineEvent.animationCompleted
          ..reversePayload = CardState.inSelectingForDiscard);
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
      case CardState.inSelectingForDiscard:
        handCursor = false;
        break;
      case CardState.inMyDealRegion:
      case CardState.inHand:
      case CardState.inDiscardToEndTurn:
        handCursor = true;
        break;
      default:
    }
  }
}
