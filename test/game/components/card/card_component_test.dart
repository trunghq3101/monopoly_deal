import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../../../utils.dart';

void main() {
  group('$Card', () {
    late Card card;

    setUp(() async {
      Flame.bundle = MockAssetBundle();
      await Flame.images.load('card.png');
      card = Card();
    });

    test('is PositionComponent', () {
      expect(card, isA<PositionComponent>());
    });

    testWithFlameGame('has SpriteComponent', (game) async {
      await game.ensureAdd(card);

      expect(card.children.whereType<SpriteComponent>(), isNotEmpty);
    });

    testWithFlameGame('has size as $GameMap.cardSize', (game) async {
      await game.ensureAdd(card);

      expect(card.size, MainGame2.gameMap.cardSize);
    });

    testWithFlameGame('has SpriteComponent with the size the same as its size',
        (game) async {
      await game.ensureAdd(card);

      expect(card.children.whereType<SpriteComponent>().first.size, card.size);
    });

    testWithFlameGame('anchor is center', (game) async {
      await game.ensureAdd(card);

      expect(card.anchor, Anchor.center);
    });

    testWithFlameGame('state returns correctly', (game) async {
      card.add(CardStateMachine());
      await game.ensureAdd(card);

      expect(card.state, CardState.inDeck);
    });
  });
}
