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
  group('$PickUpBehavior', () {
    late PickUpBehavior behavior;

    setUp(() async {
      await loadTestAssets();
      MainGame.gameAsset = _MockGameAsset();
      behavior = PickUpBehavior();
    });

    group('on ${CardStateMachineEvent.pickUpToHand}', () {
      testWithFlameGame('parent position change to inHandPosition',
          (game) async {
        final inHand = InHandPosition(Vector2.all(100), 0.8);
        final p = Card()..angle = 0.5;
        p.add(behavior);
        await game.ensureAdd(p);

        behavior.onNewEvent(
          Event(CardStateMachineEvent.pickUpToHand)
            ..payload = CardPickUpPayload(0, inHandPosition: inHand)
            ..reverseEvent = 0,
        );
        await game.ready();
        game.update(4);

        expect(p.position, inHand.position);
        expect(p.angle, inHand.angle);
      });
    });
  });
}
