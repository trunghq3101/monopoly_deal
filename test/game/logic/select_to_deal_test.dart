import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

class _MockSubscriber implements Subscriber {
  int received = 0;
  final List<CardDealPayload> receivedPayloads = [];

  @override
  void onNewEvent(event, [Object? payload]) {
    received++;
    receivedPayloads.add(payload as CardDealPayload);
  }
}

class _MockHasCardId implements HasCardId {
  _MockHasCardId({required int cardId}) : _cardId = cardId;

  final int _cardId;

  @override
  int get cardId => _cardId;
}

class _MockCardTracker extends CardTracker {
  final List<HasCardId> cards =
      List.generate(20, (index) => _MockHasCardId(cardId: index));

  @override
  List<HasCardId> cardsInDeckFromTop() {
    return cards;
  }
}

void main() {
  group('$SelectToDeal', () {
    late SelectToDeal behavior;
    late _MockCardTracker cardTracker;

    setUp(() async {
      cardTracker = _MockCardTracker();
      behavior = SelectToDeal(cardTracker: cardTracker);
    });

    test('is a $Subscriber', () {
      expect(behavior, isA<Subscriber>());
    });

    group('give ${CardDeckEvent.dealStartGame}, 20 cards, 2 players', () {
      test(
        "notify 10 times",
        () {
          MainGame2.gameMap = GameMap(playerPositions: [
            Vector2.all(0),
            Vector2.all(1),
          ]);
          final subscriber = _MockSubscriber();
          behavior.addSubscriber(subscriber);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);

          expect(subscriber.received, 10);
        },
      );

      test(
        "notify different payloads",
        () {
          final playerPositions = [
            Vector2.all(0),
            Vector2.all(1),
          ];
          MainGame2.gameMap = GameMap(playerPositions: playerPositions);
          final subscriber = _MockSubscriber();
          behavior.addSubscriber(subscriber);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);

          expect(subscriber.receivedPayloads, [
            CardDealPayload(0, playerPositions[0], orderIndex: 0),
            CardDealPayload(1, playerPositions[1], orderIndex: 1),
            CardDealPayload(2, playerPositions[0], orderIndex: 2),
            CardDealPayload(3, playerPositions[1], orderIndex: 3),
            CardDealPayload(4, playerPositions[0], orderIndex: 4),
            CardDealPayload(5, playerPositions[1], orderIndex: 5),
            CardDealPayload(6, playerPositions[0], orderIndex: 6),
            CardDealPayload(7, playerPositions[1], orderIndex: 7),
            CardDealPayload(8, playerPositions[0], orderIndex: 8),
            CardDealPayload(9, playerPositions[1], orderIndex: 9),
          ]);
        },
      );
    });
  });
}
