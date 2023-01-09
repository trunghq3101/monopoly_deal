import 'package:lucky_deal_server/models/models.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    late Deck deck;

    test('Can be shuffled', () {
      deck = Deck();
      expect(deck.at(1), 1);
      deck.shuffle();
      expect(deck.at(1), isNot(1));
    });

    test('To-be-dealed cards for player', () {
      deck = Deck();
      expect(deck.toBeDealed(0, 3), [0, 3, 6, 9, 12]);
      expect(deck.toBeDealed(1, 3), [1, 4, 7, 10, 13]);
      expect(deck.toBeDealed(2, 3), [2, 5, 8, 11, 14]);
    });
  });
}
