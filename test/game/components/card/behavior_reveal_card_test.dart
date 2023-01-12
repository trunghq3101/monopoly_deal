import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

class _MockGameAsset extends GameAsset {
  @override
  Image frontImageForCardIndex(int id) => Flame.images.fromCache('01.png');
}

void main() {
  group('$RevealCardBehavior', () {
    late RevealCardBehavior behavior;

    setUp(() async {
      await loadTestAssets();
      MainGame.gameAsset = _MockGameAsset();
      behavior = RevealCardBehavior();
    });

    group('on ${CardEvent.cardRevealed}', () {
      testWithFlameGame('parent change sprite', (game) async {
        final p = Card();
        p.add(behavior);
        await game.ensureAdd(p);
        final oldSprite = p.children.query<SpriteComponent>().first.sprite;

        behavior.onNewEvent(
            Event(CardEvent.cardRevealed)..payload = CardIndexPayload(0));
        await game.ready();
        game.update(2);
        await game.ready();

        expect(
          p.children.query<SpriteComponent>().first.sprite,
          isNot(oldSprite),
        );
      });
    });
  });
}
