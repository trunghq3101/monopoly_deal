import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../utils.dart';

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
    late MockSequenceEventSubscriber subscriber;

    setUp(() async {
      cardTracker = _MockCardTracker();
      behavior = SelectToDeal(cardTracker: cardTracker);
      subscriber = MockSequenceEventSubscriber();
      behavior.addSubscriber(subscriber);
    });

    test('is a $Subscriber', () {
      expect(behavior, isA<Subscriber>());
    });

    group('give ${CardDeckEvent.dealStartGame}, 20 cards, 2 players', () {
      test(
        "notify 10 times",
        () {
          MainGame.gameMap = GameMap(playerPositions: [
            Vector2.all(0),
            Vector2.all(1),
          ]);
          behavior.onNewEvent(Event(CardDeckEvent.dealStartGame));

          expect(subscriber.receivedEvents.length, 10);
        },
      );

      test(
        "notify different payloads",
        () {
          final playerPositions = [
            Vector2.all(0),
            Vector2.all(1),
          ];
          MainGame.gameMap = GameMap(playerPositions: playerPositions);

          behavior.onNewEvent(Event(CardDeckEvent.dealStartGame));

          expect(subscriber.receivedEvents.map((e) => e?.payload), [
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
