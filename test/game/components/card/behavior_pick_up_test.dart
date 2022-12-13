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
      behavior = PickUpBehavior();
    });

    test('is Component', () {
      expect(behavior, isA<Component>());
    });

    test('parent is PositionComponent', () {
      expect(behavior, isA<ParentIsA<Card>>());
    });

    test('is ${Subscriber<CardStateMachineEvent>}', () {
      expect(behavior, isA<Subscriber<CardStateMachineEvent>>());
    });

    testWithFlameGame('on ${CardStateMachineEvent.toHand}', (game) async {
      final p = Card();
      p.add(behavior);
      await game.ensureAdd(p);
      final oldSprite = p.children.query<SpriteComponent>().first.sprite;
      MainGame2.gameAsset = _MockGameAsset();
      await Flame.images.load('01.png');

      behavior.onNewEvent(CardStateMachineEvent.toHand);
      await game.ready();
      game.update(2);

      expect(
        p.children.query<SpriteComponent>().first.sprite,
        isNot(oldSprite),
      );
    });
  });
}
