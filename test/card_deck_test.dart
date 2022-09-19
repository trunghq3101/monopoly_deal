import 'package:flutter_test/flutter_test.dart';

class Card {}

class CardDeck {
  CardDeck({int fullLength = 110}) : currentLength = fullLength;

  late int currentLength;

  List<Card> draw() {
    if (currentLength == 0) return [];
    currentLength -= 2;
    return [Card(), Card()];
  }
}

void main() {
  group('CardDeck test', () {
    test('Deck must have 110 cards at first', () {
      final deck = CardDeck();
      expect(deck.currentLength, 110);
    });

    test('Draw 2 cards each turn until no card left', () {
      final deck = CardDeck(fullLength: 4);
      var cards = deck.draw();
      expect(cards.length, 2);
      expect(deck.currentLength, 2);
      cards = deck.draw();
      expect(cards.length, 2);
      expect(deck.currentLength, 0);
      cards = deck.draw();
      expect(cards.length, 0);
      expect(deck.currentLength, 0);
    });
  });
}
