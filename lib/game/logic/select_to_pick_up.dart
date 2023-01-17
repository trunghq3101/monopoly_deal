import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPickUp with Publisher, Subscriber {
  SelectToPickUp({CardTracker? cardTracker, RoomGateway? roomGateway})
      : _cardTracker = cardTracker ?? CardTracker(),
        _roomGateway = roomGateway ?? RoomGateway();

  final CardTracker _cardTracker;
  final RoomGateway _roomGateway;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.tapOnMyDealRegion:
        if (_cardTracker.hasCardInAnimationState()) return;
        _roomGateway.pickUp();
        notify(Event(CardEvent.zoomCardsOut));
        final cardsToPickUp = _cardTracker.cardsInMyDealRegionFromTop();
        int orderIndex = 0;
        for (var c in cardsToPickUp) {
          final inHandPosition = _cardTracker.getInHandPosition(
            index: cardsToPickUp.length - 1 - orderIndex,
            amount: cardsToPickUp.length,
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
        break;
      default:
    }
  }
}
