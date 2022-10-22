import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/card_front.dart';
import 'package:monopoly_deal/game_components/hand.dart';
import 'package:monopoly_deal/game_components/pick_up_region.dart';

import '../utils.dart';

void main() {
  group('PickUpRegion', () {
    testWithGame<StubMainGame>(
      'take and pick up',
      () => StubMainGame(),
      (game) async {
        final cc = [PositionComponent(), PositionComponent()];
        final c = PickUpRegion()..addToParent(game);
        await c.ensureAddAll(cc);
        c.onTapDown(createTapDownEvents());
        // can only tap once
        c.onTapDown(createTapDownEvents());
        await game.ready();
        expect(cc[0].firstChild<Effect>(), isNotNull);
        expect(cc[1].firstChild<Effect>(), isNotNull);
        game.update(1);
        await game.ready();
        expect(game.firstChild<Hand>()?.children, [CardFront(), CardFront()]);
      },
    );
  });
}
