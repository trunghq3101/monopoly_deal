import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToPreviewing with Publisher, Subscriber {
  SelectToPreviewing({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(Object event, [Object? payload]) {
    switch (event) {
      case CardStateMachineEvent.tapWhileInHand:
        final previewingCard = _cardTracker.cardInPreviewingState();
        assert(payload is CardIdPayload);
        notify(CardEvent.preview, payload);
        if (previewingCard != null) {
          notify(CardEvent.previewSwap, CardIdPayload(previewingCard.cardId));
        }
        break;
      case CardStateMachineEvent.tapWhileInPreviewing:
        assert(payload is CardIdPayload);
        notify(CardEvent.previewRevert, payload);
        break;
      default:
    }
  }
}
