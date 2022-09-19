import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/models/card.dart';
import 'package:monopoly_deal/models/game_round.dart';

void main() {
  group('CardDeck test', () {
    test('Deck must have 110 cards at first', () {
      final deck = CardDeck();
      expect(deck.currentLength, 110);
    });

    test('Draw 2 cards each turn until no card left', () {
      final deck = CardDeck(
        game: GameRound()..started = true,
        fullLength: 4,
      );
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

    test('Not allow to draw if game has not started yet', () {
      final game = GameRound();
      final deck = CardDeck(game: game);
      expect(() => deck.draw(), throwsAssertionError);
      game.started = true;
      deck.draw();
    });
  });
}
