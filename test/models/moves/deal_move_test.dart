import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/moves/deal_move.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  group('DealMove test', () {
    test('deal', () {
      final dealer = Player();
      final cards = List.generate(10, (index) => Card('$index'));
      final deck = CardDeck(initial: cards);
      final players = [
        Player(),
        Player(),
      ];
      final move = DealMove(
        player: dealer,
        deck: deck,
        players: players,
      );
      move.move();
      expect(
        players[0].hand,
        [cards[9], cards[7], cards[5], cards[3], cards[1]],
      );
      expect(
        players[1].hand,
        [cards[8], cards[6], cards[4], cards[2], cards[0]],
      );
      expect(deck.remaining, []);
    });

    test('error if not enough cards', () {
      final dealer = Player();
      final cards = List.generate(10, (index) => Card('$index'));
      final deck = CardDeck(initial: cards);
      final players = [
        Player(),
        Player(),
        Player(),
      ];
      final move = DealMove(
        player: dealer,
        deck: deck,
        players: players,
      );
      expect(() => move.move(), throwsAssertionError);
    });
  });
}
