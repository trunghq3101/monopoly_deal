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

    test('User can pick up cards', () {
      deck = Deck(playersAmount: 3)..onStart();
      expect(deck.pickUp(0), [0, 3, 6, 9, 12]);
      expect(deck.pickUp(1), [1, 4, 7, 10, 13]);
      expect(deck.pickUp(2), [2, 5, 8, 11, 14]);
    });

    test('User can reveal cards when game has started', () {
      deck = Deck(playersAmount: 3)..onStart();
      expect(deck.reveal(0, at: 0), 0);
      expect(deck.reveal(0, at: 3), 3);
      expect(deck.reveal(1, at: 1), 1);
      expect(deck.reveal(1, at: 4), 4);
      expect(deck.reveal(2, at: 2), 2);
      expect(deck.reveal(2, at: 5), 5);
      expect(() => deck.reveal(0, at: 15), throwsStateError);
      expect(() => deck.reveal(1, at: 15), throwsStateError);
      expect(() => deck.reveal(2, at: 15), throwsStateError);

      deck.onDraw(0);
      expect(deck.reveal(0, at: 15), 15);
      expect(deck.reveal(0, at: 16), 16);
      expect(() => deck.reveal(1, at: 15), throwsStateError);
      expect(() => deck.reveal(1, at: 17), throwsStateError);

      deck.onDraw(1);
      expect(deck.reveal(1, at: 17), 17);
      expect(deck.reveal(1, at: 18), 18);
      expect(() => deck.reveal(0, at: 17), throwsStateError);
      expect(() => deck.reveal(0, at: 19), throwsStateError);
    });
  });
}
