import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

void main() {
  group('Deck', () {
    late Deck deck;

    setUp(() {
      deck = Deck(
        config: DeckConfig(
          bottomRight: Vector2.zero(),
          step: Vector2.all(-5),
          total: 110,
        ),
      );
    });

    testWithFlameGame('amount changes', (game) async {
      await game.ensureAdd(deck);
      game.update(0.01);
      expect(deck.amount, 1);
      game.update(0.12);
      expect(deck.amount, 13);
      game.update(0.97);
      expect(deck.amount, 110);
      game.update(0.1);
      expect(deck.amount, 110);
    });

    testWithFlameGame('new card at position', (game) async {
      await game.ensureAdd(deck);
      game.update(0.01);
      expect(deck.newCards, [Vector2(0, 0)]);
      game.update(0.02);
      expect(deck.newCards, [Vector2(-5, -5), Vector2(-10, -10)]);
      game.update(1.07);
      game.update(0.5);
      expect(deck.isRemoved, true);
    });

    testWithFlameGame('amount changed listener', (game) async {
      await game.ensureAdd(deck);
      deck.amountNotifier.addListener(expectAsync0(() {}));
      game.update(1.2);
    });
  });
}
