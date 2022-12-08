import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

void main() {
  group('$Card', () {
    late Card card;

    setUp(() async {
      final img = await createTestImage();
      card = Card(img);
    });

    test('is PositionComponent', () {
      expect(card, isA<PositionComponent>());
    });

    testWithFlameGame('has SpriteComponent', (game) async {
      await game.ensureAdd(card);

      expect(card.children.whereType<SpriteComponent>(), isNotEmpty);
    });

    testWithFlameGame('has SpriteComponent with the size the same as its size',
        (game) async {
      await game.ensureAdd(card);

      expect(card.children.whereType<SpriteComponent>().first.size, card.size);
    });

    testWithFlameGame('anchor is bottomRight', (game) async {
      await game.ensureAdd(card);

      expect(card.anchor, Anchor.bottomRight);
    });
  });
}
