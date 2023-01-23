import 'package:flame/components.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPickUp extends Component with Publisher, Subscriber {
  SelectToPickUp({CardTracker? cardTracker, RoomGateway? roomGateway})
      : _cardTracker = cardTracker ?? CardTracker(),
        _roomGateway = roomGateway ?? RoomGateway();

  final CardTracker _cardTracker;
  final RoomGateway _roomGateway;
  bool _pending = false;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.tapOnMyDealRegion:
      case PacketType.turnPassed:
        if (_cardTracker.hasCardInAnimationState()) return;
        notify(Event(CardEvent.zoomCardsOut));
        notify(Event(CardDeckEvent.pickUp));
        if (_cardTracker.cardInPreviewingState() != null) {
          final cardIndex = _cardTracker.cardInPreviewingState()!.cardIndex;
          notify(Event(CardEvent.previewRevert)
            ..payload = CardIndexPayload(cardIndex));
          _roomGateway.sendCardEvent(PacketType.unpreviewCard, cardIndex);
        }
        if (_cardTracker.hasCardInAnimationState()) {
          _pending = true;
        } else {
          _pickUp();
        }
        break;
      default:
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_pending) {
      if (!_cardTracker.hasCardInAnimationState()) {
        _pending = false;
        _pickUp();
      }
    }
  }

  void _pickUp() {
    _roomGateway.pickUp();
    final cardsToPickUp = _cardTracker.cardsInMyDealRegionFromTop();
    final cardsInHand = _cardTracker.cardsInHandFromTop();
    final totalCards = cardsInHand.length + cardsToPickUp.length;
    int repositionOrderIndex = cardsToPickUp.length;
    for (var c in cardsInHand) {
      final newInHandPosition = _cardTracker.getInHandPosition(
        index: totalCards - 1 - repositionOrderIndex,
        amount: totalCards,
      );
      repositionOrderIndex++;
      notify(
        Event(CardEvent.reposition)
          ..payload = CardRepositionPayload(
            c.cardIndex,
            inHandPosition: newInHandPosition,
          ),
      );
    }
    int orderIndex = 0;
    for (var c in cardsToPickUp) {
      final inHandPosition = _cardTracker.getInHandPosition(
        index: totalCards - 1 - orderIndex,
        amount: totalCards,
      );
      notify(
        Event(CardEvent.pickUp)
          ..payload = CardPickUpPayload(
            c.cardIndex,
            orderIndex: orderIndex++,
            inHandPosition: inHandPosition,
          ),
      );
    }
  }
}
