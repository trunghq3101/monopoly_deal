import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../../../utils.dart';

void main() {
  group('$Card', () {
    late Card card;
    late GameMap gameMap;

    setUp(() async {
      Flame.bundle = MockAssetBundle();
      await Flame.images.load('card.png');
      card = Card();
      gameMap = GameMap();
    });

    Future<void> setupCard(FlameGame game) async {
      await game.ensureAdd(gameMap);
      await game.ensureAdd(card);
    }

    test('is PositionComponent', () {
      expect(card, isA<PositionComponent>());
    });

    test('is $HasGameMapRef', () {
      expect(card, isA<HasGameMapRef>());
    });

    testWithFlameGame('has SpriteComponent', (game) async {
      await setupCard(game);

      expect(card.children.whereType<SpriteComponent>(), isNotEmpty);
    });

    testWithFlameGame('has size as $GameMap.cardSize', (game) async {
      await setupCard(game);

      expect(card.size, gameMap.cardSize);
    });

    testWithFlameGame('has SpriteComponent with the size the same as its size',
        (game) async {
      await setupCard(game);

      expect(card.children.whereType<SpriteComponent>().first.size, card.size);
    });

    testWithFlameGame('anchor is bottomRight', (game) async {
      await setupCard(game);

      expect(card.anchor, Anchor.bottomRight);
    });
  });
}
