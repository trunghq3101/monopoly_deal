import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../../../utils.dart';

void main() {
  group('GameMapComponent', () {
    late GameMap gameMap;

    setUp(() {
      gameMap = GameMap();
    });

    test('is a Component', () {
      expect(gameMap, isA<Component>());
    });

    group('inDeckPosition', () {
      test(
        'given cardSize, returned position scaled from cardSize',
        () {
          final cardSize = Vector2(10, 20);
          gameMap = GameMap(cardSize: cardSize);

          final inDeckPosition = gameMap.inDeckPosition(2);

          expect(
            inDeckPosition.x / inDeckPosition.y,
            cardSize.x / cardSize.y,
          );
        },
      );

      test(
        'given deckSpacing, returned position distanced by it',
        () {
          const deckSpacing = 0.01;
          final deckBottomRight = Vector2.all(10);
          gameMap = GameMap(
              deckBottomRight: deckBottomRight, deckSpacing: deckSpacing);

          Vector2 inDeckPosition = gameMap.inDeckPosition(1);
          expect(inDeckPosition.distanceTo(deckBottomRight).toFixed(2),
              deckSpacing);

          inDeckPosition = gameMap.inDeckPosition(2);
          expect(inDeckPosition.distanceTo(deckBottomRight).toFixed(2),
              deckSpacing * 2);

          inDeckPosition = gameMap.inDeckPosition(0);
          expect(inDeckPosition.distanceTo(deckBottomRight).toFixed(2), 0);
        },
      );
    });
  });
}
