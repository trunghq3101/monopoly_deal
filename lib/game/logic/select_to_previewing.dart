import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPreviewing with Publisher, Subscriber {
  SelectToPreviewing({CardTracker? cardTracker, RoomGateway? roomGateway})
      : _cardTracker = cardTracker ?? CardTracker(),
        _roomGateway = roomGateway ?? RoomGateway();

  final CardTracker _cardTracker;
  final RoomGateway _roomGateway;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.tapWhileInHand:
        final payload = event.payload as CardIndexPayload;
        final previewingCard = _cardTracker.cardInPreviewingState();
        notify(Event(CardEvent.preview)..payload = payload);
        _roomGateway.sendCardEvent(PacketType.previewCard, payload.cardIndex);
        if (previewingCard != null) {
          notify(Event(CardEvent.previewSwap)
            ..payload = CardIndexPayload(previewingCard.cardIndex));
        }
        break;
      case CardStateMachineEvent.tapWhileInPreviewing:
        final payload = event.payload as CardIndexPayload;
        notify(Event(CardEvent.previewRevert)..payload = payload);
        _roomGateway.sendCardEvent(PacketType.unpreviewCard, payload.cardIndex);
        break;
      default:
    }
  }
}
