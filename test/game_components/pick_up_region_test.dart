import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game_components/pick_up_region.dart';

import '../utils.dart';

void main() {
  group('PickUpRegion', () {
    testWithGame<StubMainGame>(
      'run and finish',
      () => StubMainGame(),
      (game) async {
        final cc = [Component(), Component(), Component(), Component()];
        final c = PickUpRegion()..addToParent(game);
        await c.ensureAddAll(cc);
        c.onTapDown(createTapDownEvents());
        // can only tap once
        c.onTapDown(createTapDownEvents());
        await game.ready();
        expect(cc[0].children.length, 1);
        expect(cc[1].children.length, 1);
        expect(cc[0].firstChild<FlyOutEffect>(), isNotNull);
        expect(cc[1].firstChild<FlyOutEffect>(), isNotNull);
        game.update(0.8);
        await game.ready();
        expect(cc[2].firstChild<ShowUpEffect>(), isNotNull);
        expect(cc[3].firstChild<ShowUpEffect>(), isNotNull);
        game.update(0.5);
        await game.ready();
        expect(cc[0].isRemoved, true);
        expect(cc[1].isRemoved, true);
        expect(cc[2].parent, game);
        expect(cc[3].parent, game);
        game.update(0.1);
        await game.ready();
        expect(c.isRemoved, true);
      },
    );
  });
}
