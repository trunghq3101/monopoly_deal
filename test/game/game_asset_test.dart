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

    test('given cardId, return front image', () async {
      await loadTestAssets();

      expect(
        gameAsset.frontImageForCardId(3),
        Flame.images.fromCache('02.png'),
      );
    });
  });
}
