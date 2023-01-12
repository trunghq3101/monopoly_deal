import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../utils.dart';

void main() {
  group('GameMap', () {
    late GameMap gameMap;

    setUp(() {
      gameMap = GameMap();
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
          const deckSpacing = 10.0;
          final deckCenter = Vector2.zero();
          MainGame.cardTotalAmount = 4;
          gameMap = GameMap(deckSpacing: deckSpacing);

          Vector2 inDeckPosition = gameMap.inDeckPosition(0);
          expect(inDeckPosition.distanceTo(deckCenter).toFixed(2),
              deckSpacing * 1.5);

          inDeckPosition = gameMap.inDeckPosition(1);
          expect(inDeckPosition.distanceTo(deckCenter).toFixed(2),
              deckSpacing * 0.5);

          inDeckPosition = gameMap.inDeckPosition(2);
          expect(inDeckPosition.distanceTo(deckCenter).toFixed(2),
              deckSpacing * 0.5);

          inDeckPosition = gameMap.inDeckPosition(3);
          expect(inDeckPosition.distanceTo(deckCenter).toFixed(2),
              deckSpacing * 1.5);
        },
      );

      test('given player index, return position', () async {
        gameMap = GameMap(
          myIndex: 1,
          playerPositions: [Vector2.all(1), Vector2.all(2), Vector2.all(0)],
        );

        expect(
          gameMap.positionForPlayerIndex(0),
          Vector2.all(0),
        );
        expect(
          gameMap.positionForPlayerIndex(2),
          Vector2.all(2),
        );
      });
    });
  });
}
