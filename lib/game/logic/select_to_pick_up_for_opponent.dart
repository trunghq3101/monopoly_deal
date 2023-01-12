import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPickUpForOpponent with Publisher, Subscriber {
  SelectToPickUpForOpponent(
      {CardTracker? cardTracker, RoomGateway? roomGateway})
      : _cardTracker = cardTracker ?? CardTracker(),
        _roomGateway = roomGateway ?? RoomGateway();

  final CardTracker _cardTracker;
  final RoomGateway _roomGateway;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case PacketType.pickedUp:
        final payload = event.payload as PickedUp;
        if (payload.playerId == _roomGateway.sid) {
          return;
        }
        final cardsToPickUp = _cardTracker.cardsByIndexFromTop(payload.cards);
        int orderIndex = 0;
        for (var c in cardsToPickUp) {
          final inHandPosition = _cardTracker.getInHandPositionForOpponent(
            playerIndex: _roomGateway.playerIndexOf(payload.playerId),
            index: cardsToPickUp.length - 1 - orderIndex,
            amount: cardsToPickUp.length,
          );
          notify(
            Event(CardEvent.pickUpForOpponent)
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
