import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPreviewing with Publisher, Subscriber {
  SelectToPreviewing({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(Event event) {
    final payload = event.payload;
    switch (event.eventIdentifier) {
      case CardStateMachineEvent.tapWhileInHand:
        final previewingCard = _cardTracker.cardInPreviewingState();
        assert(payload is CardIdPayload);
        notify(Event(CardEvent.preview)..payload = payload);
        if (previewingCard != null) {
          notify(Event(CardEvent.previewSwap)
            ..payload = CardIdPayload(previewingCard.cardId));
        }
        break;
      case CardStateMachineEvent.tapWhileInPreviewing:
        assert(payload is CardIdPayload);
        notify(Event(CardEvent.previewRevert)..payload = payload);
        break;
      default:
    }
  }
}
