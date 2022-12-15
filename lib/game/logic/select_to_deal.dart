import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToDeal with Publisher, Subscriber {
  SelectToDeal({CardTracker? cardTracker})
      : _cardTracker = cardTracker ?? CardTracker();

  final CardTracker _cardTracker;

  @override
  void onNewEvent(event, [Object? payload]) {
    switch (event) {
      case CardDeckEvent.dealStartGame:
        final playerPositions = MainGame2.gameMap.playerPositions;
        final numCardsToDeal = 5 * playerPositions.length;
        final cardsInDeck = _cardTracker.cardsInDeckFromTop();
        assert(cardsInDeck.length >= numCardsToDeal,
            "Amount of cards in deck must be at least $numCardsToDeal");
        final cardsToDeal = cardsInDeck.sublist(0, numCardsToDeal);
        int pIndex = 0;
        int orderIndex = 0;
        for (var c in cardsToDeal) {
          final payload = CardDealPayload(
            c.cardId,
            playerPositions[pIndex],
            orderIndex: orderIndex++,
          );
          notify(CardEvent.deal, payload);
          pIndex = (pIndex + 1) % playerPositions.length;
        }
        break;
      default:
    }
  }
}
