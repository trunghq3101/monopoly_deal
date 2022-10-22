import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/effects/card_fly_out_effect.dart';
import 'package:monopoly_deal/game_components/pick_up_region.dart';

import '../utils.dart';

void main() {
  group('PickUpRegion', () {
    testWithGame<StubMainGame>(
      'run and finish',
      () => StubMainGame(),
      (game) async {
        final cc = [
          PositionComponent(),
          PositionComponent(),
          PositionComponent(),
          PositionComponent()
        ];
        final c = PickUpRegion()..addToParent(game);
        await c.ensureAddAll(cc);
        c.onTapDown(createTapDownEvents());
        // can only tap once
        c.onTapDown(createTapDownEvents());
        await game.ready();
        expect(cc[2].firstChild<CardFlyOutEffect>(), isNotNull);
        expect(cc[3].firstChild<CardFlyOutEffect>(), isNotNull);
        game.update(0.8);
        await game.ready();
        expect(cc[0].firstChild<ShowUpEffect>(), isNotNull);
        expect(cc[1].firstChild<ShowUpEffect>(), isNotNull);
        game.update(0.5);
        await game.ready();
        expect(cc[0].parent, game);
        expect(cc[1].parent, game);
        game.update(0.1);
        await game.ready();
        expect(c.isRemoved, true);
        expect(cc[2].isRemoved, true);
        expect(cc[3].isRemoved, true);
      },
    );
  });
}
