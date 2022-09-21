import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/moves/draw_move.dart';
import 'package:monopoly_deal/models/player.dart';

void main() {
  group('DrawMove test', () {
    test('draw', () {
      final cards = List.generate(4, (index) => Card('$index'));
      final deck = CardDeck(initial: cards.sublist(2));
      final oldHand = cards.sublist(0, 2);
      final player = Player(hand: oldHand);
      final move = DrawMove(player: player, deck: deck, amount: 2);
      move.move();
      expect(
        player.hand,
        [...oldHand, cards[3], cards[2]],
      );
    });

    test('error if not enough cards', () {
      final cards = List.generate(4, (index) => Card('$index'));
      final deck = CardDeck(initial: [cards[0], cards[1]]);
      final oldHand = [cards[2], cards[3]];
      final player = Player(hand: oldHand);
      final move = DrawMove(player: player, deck: deck, amount: 3);
      expect(() => move.move(), throwsAssertionError);
    });
  });
}
