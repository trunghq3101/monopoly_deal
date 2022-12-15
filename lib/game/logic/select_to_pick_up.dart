import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPickUp with Publisher, Subscriber {
  SelectToPickUp({final CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.tapOnMyDealRegion:
        final cardsToPickUp = _cardTracker.cardsInMyDealRegionFromTop();
        int orderIndex = 0;
        for (var c in cardsToPickUp) {
          final inHandPosition = _cardTracker.getInHandPosition(
            index: cardsToPickUp.length - 1 - orderIndex,
            amount: cardsToPickUp.length,
          );
          notify(
            CardEvent.pickUp,
            CardEventPickUpPayload(
              c.cardId,
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
