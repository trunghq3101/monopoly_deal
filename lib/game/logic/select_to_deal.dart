import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class SelectToDeal with Publisher, Subscriber {
  SelectToDeal({CardTracker? cardTracker, RoomGateway? roomGateway})
      : _cardTracker = cardTracker ?? CardTracker(),
        _roomGateway = roomGateway ?? RoomGateway();

  final CardTracker _cardTracker;
  final RoomGateway _roomGateway;

  @override
  void onNewEvent(Event event) {
    switch (event.eventIdentifier) {
      case CardDeckEvent.dealStartGame:
        final numPlayers = MainGame.gameMap.playerPositions.length;
        _deal(
          numCardsToDeal: 5 * numPlayers,
          initialPlayerIndex: 0,
          numPlayers: numPlayers,
          isDealStartTime: true,
        );
        break;
      case PacketType.turnPassed:
        _deal(
          numCardsToDeal: 2,
          initialPlayerIndex:
              _roomGateway.playerIndexOf((event.payload as PlayerId).sid),
          numPlayers: 1,
        );
        break;
      default:
    }
  }

  void _deal({
    required int numCardsToDeal,
    required int initialPlayerIndex,
    required int numPlayers,
    bool isDealStartTime = false,
  }) {
    final cardsInDeck = _cardTracker.cardsInDeckFromTop();
    final shouldDealToTurnOwner =
        isDealStartTime && _roomGateway.turnId != null;
    final numCardsToTurnOwner = shouldDealToTurnOwner ? 2 : 0;
    final totalNumCardsToDeal = numCardsToDeal + numCardsToTurnOwner;
    assert(cardsInDeck.length >= totalNumCardsToDeal,
        "Amount of cards in deck must be at least $totalNumCardsToDeal");
    final cardsToDeal = cardsInDeck.sublist(0, totalNumCardsToDeal);
    List<int> playersToDeal =
        List.generate(numPlayers, (index) => initialPlayerIndex + index);
    int pIndex = 0;
    int orderIndex = 0;
    notify(
      Event(CardDeckEvent.dealing)
        ..payload = CardDeckDealingPayload(
          amount: totalNumCardsToDeal,
          isDealStartGame: isDealStartTime,
        ),
    );
    for (var i = 0; i < numCardsToDeal; i++) {
      final c = cardsToDeal[i];
      final payload = CardDealPayload(
        c.cardIndex,
        MainGame.gameMap.positionForPlayerIndex(playersToDeal[pIndex]),
        orderIndex: orderIndex++,
      );
      notify(Event(CardEvent.deal)..payload = payload);
      pIndex = (pIndex + 1) % numPlayers;
    }
    if (shouldDealToTurnOwner) {
      final turnOwnerIndex = _roomGateway.playerIndexOf(_roomGateway.turnId!);
      for (var i = 0; i < numCardsToTurnOwner; i++) {
        final c = cardsToDeal[numCardsToDeal + i];
        final payload = CardDealPayload(
          c.cardIndex,
          MainGame.gameMap.positionForPlayerIndex(turnOwnerIndex),
          orderIndex: orderIndex++,
        );
        notify(Event(CardEvent.deal)..payload = payload);
      }
    }
  }
}
