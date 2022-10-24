import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/sprite.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/card.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/game_assets.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/game_components/pick_up_region.dart';

import '../utils.dart';

void main() {
  group('PickUpRegion', () {
    testWithGame<StubMainGame>(
      'take and pick up',
      () => StubMainGame(),
      (game) async {
        final cardImg = await generateImage();
        gameAssets.cardSprites = List.generate(106, (_) => Sprite(cardImg));
        final cam = CameraComponent(world: World())..addToParent(game);
        await cam.viewport.ensureAdd(Hand());
        await game.ready();
        final cc = List.generate(
            5, (index) => Card(id: index, sprite: Sprite(cardImg)));
        final c = PickUpRegion()..addToParent(game);
        await c.ensureAddAll(cc);
        c.onTapDown(createTapDownEvents());
        // can only tap once
        c.onTapDown(createTapDownEvents());
        await game.ready();
        expect(cc.every((c) => c.firstChild<Effect>() != null), true);
        final h = cam.viewport.firstChild<Hand>()!;
        expect(
          h.children.toList(),
          cc.map((e) => CardFront(id: e.id)).toList(),
        );
        expect(h.children.every((e) => e.firstChild<Effect>() != null), true);
      },
    );
  });
}
