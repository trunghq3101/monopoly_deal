import 'package:flame/components.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToReArrange extends Component with Publisher, Subscriber {
  SelectToReArrange({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(Event event, [Object? payload]) {
    switch (event.eventIdentifier) {
      case PlaceCardButtonEvent.tap:
        add(TimerComponent(
          period: 0.2,
          onTick: () {
            final cardsInHand = _cardTracker.cardsInHandCollapsedFromTop();
            int orderIndex = 0;
            for (var c in cardsInHand) {
              final newInHandPosition = _cardTracker.getInHandCollapsedPosition(
                index: cardsInHand.length - 1 - orderIndex,
                amount: cardsInHand.length,
              );
              orderIndex++;
              notify(
                Event(CardEvent.reposition)
                  ..payload = CardRepositionPayload(
                    c.cardIndex,
                    inHandPosition: newInHandPosition,
                  ),
              );
            }
          },
          removeOnFinish: true,
        ));

        break;
      default:
    }
  }
}
