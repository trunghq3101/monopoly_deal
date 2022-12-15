import 'package:flame/experimental.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../../../utils.dart';

class _MockCard extends Card {
  _MockCard(this._cardId, this._state);

  final int _cardId;
  final CardState _state;

  @override
  int get cardId => _cardId;

  @override
  CardState get state => _state;
}

void main() {
  group('$CardTracker', () {
    late CardTracker tracker;
    late List<Card> cards;

    setUp(() async {
      await loadTestAssets();
      tracker = CardTracker();
      cards = [
        _MockCard(0, CardState.inDeck)..priority = 0,
        _MockCard(1, CardState.inDeck)..priority = 1,
        _MockCard(2, CardState.inMyDealRegion)..priority = 0,
        _MockCard(3, CardState.inMyDealRegion)..priority = 1,
        _MockCard(4, CardState.inHand)..priority = 2,
      ];
    });

    test('is $HasWorldRef', () {
      expect(tracker, isA<HasWorldRef>());
    });

    testWithFlameGame('cardsInDeckFromTop', (game) async {
      final w = World();
      w.addAll(cards);
      await game.ensureAdd(w);
      await game.ensureAdd(tracker);

      expect(tracker.cardsInDeckFromTop(), [cards[1], cards[0]]);
    });

    testWithFlameGame('cardsInMyDealRegionFromTop', (game) async {
      final w = World();
      w.addAll(cards);
      await game.ensureAdd(w);
      await game.ensureAdd(tracker);

      expect(tracker.cardsInMyDealRegionFromTop(), [cards[3], cards[2]]);
    });
  });
}
