import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/components/card/behavior_pick_up.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

import '../../../utils.dart';

class _MockGameAsset extends GameAsset {
  @override
  Image frontImageForCardId(int id) => Flame.images.fromCache('01.png');
}

void main() {
  group('$PickUpBehavior', () {
    late PickUpBehavior behavior;

    setUp(() async {
      await loadTestAssets();
      MainGame2.gameAsset = _MockGameAsset();
      behavior = PickUpBehavior();
    });

    test('is Component', () {
      expect(behavior, isA<Component>());
    });

    test('parent is PositionComponent', () {
      expect(behavior, isA<ParentIsA<Card>>());
    });

    test('is $Subscriber', () {
      expect(behavior, isA<Subscriber>());
    });

    group('on ${CardStateMachineEvent.pickUpToHand}', () {
      testWithFlameGame('parent change sprite', (game) async {
        final p = Card();
        p.add(behavior);
        await game.ensureAdd(p);
        final oldSprite = p.children.query<SpriteComponent>().first.sprite;

        behavior.onNewEvent(
            CardStateMachineEvent.pickUpToHand, CardPickUpPayload(0));
        await game.ready();
        game.update(2);
        await game.ready();

        expect(
          p.children.query<SpriteComponent>().first.sprite,
          isNot(oldSprite),
        );
      });

      testWithFlameGame('parent position change to inHandPosition',
          (game) async {
        final inHand = InHandPosition(Vector2.all(100), 0.8);
        final p = Card()..angle = 0.5;
        p.add(behavior);
        await game.ensureAdd(p);

        behavior.onNewEvent(
          CardStateMachineEvent.pickUpToHand,
          CardPickUpPayload(0, inHandPosition: inHand),
        );
        await game.ready();
        game.update(4);

        expect(p.position, inHand.position);
        expect(p.angle, inHand.angle);
      });
    });
  });
}
