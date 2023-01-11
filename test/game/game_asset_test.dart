import 'package:flame/flame.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';

import '../utils.dart';

void main() {
  group('$GameAsset', () {
    late GameAsset gameAsset;

    setUp(() {
      gameAsset = GameAsset();
    });

    test('given cardIndex, return front image', () async {
      await loadTestAssets();
      gameAsset.onCardRevealed(3, 10);

      expect(
        gameAsset.frontImageForCardIndex(3),
        Flame.images.fromCache('05.png'),
      );
    });
  });
}
