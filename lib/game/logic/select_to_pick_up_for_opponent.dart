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
        final playerIndex = _roomGateway.playerIndexOf(payload.playerId);
        final relativePlayerIndex =
            _roomGateway.relativePlayerIndex(playerIndex);
        final cardsWillBeInHand =
            _cardTracker.cardsByIndexFromTop(payload.cards);
        final cardsInHand =
            _cardTracker.cardsInOpponentHandFromTop(relativePlayerIndex);
        final cardsToPickUp =
            cardsWillBeInHand.where((e) => !cardsInHand.contains(e)).toList();
        final totalCards = cardsInHand.length + cardsToPickUp.length;
        int repositionOrderIndex = cardsToPickUp.length;
        for (var c in cardsInHand) {
          final newInHandPosition = _cardTracker.getInHandPositionForOpponent(
            relativePlayerIndex: relativePlayerIndex,
            playerAmount: _roomGateway.playerAmount!,
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
          final inHandPosition = _cardTracker.getInHandPositionForOpponent(
            relativePlayerIndex: relativePlayerIndex,
            playerAmount: _roomGateway.playerAmount!,
            index: totalCards - 1 - orderIndex,
            amount: totalCards,
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
