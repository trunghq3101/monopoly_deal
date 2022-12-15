import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

void main() {
  group('$ZoomOverviewBehavior', () {
    late ZoomOverviewBehavior behavior;

    setUp(() {
      behavior = ZoomOverviewBehavior();
    });

    test('is a Component', () {
      expect(behavior, isA<Component>());
    });

    test('parent is a CameraComponent', () {
      expect(behavior, isA<ParentIsA<CameraComponent>>());
    });

    test('is $Subscriber', () {
      expect(behavior, isA<Subscriber>());
    });

    group('on ${CardDeckEvent.dealStartGame}', () {
      testWithFlameGame(
        'viewFinder visibleGameSize change to overviewGameSize',
        (game) async {
          final p = CameraComponent(world: World());
          p.add(behavior);
          p.viewfinder.visibleGameSize = Vector2.all(10);
          await game.ensureAdd(p);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);
          await game.ready();
          game.update(1);

          expect(
            p.viewfinder.visibleGameSize,
            MainGame2.gameMap.overviewGameVisibleSize,
          );
        },
      );

      testWithFlameGame(
        'viewFinder change position to bottom and change anchor to bottomCenter',
        (game) async {
          final p = CameraComponent(world: World());
          p.add(behavior);
          p.viewfinder.visibleGameSize = Vector2.all(10);
          await game.ensureAdd(p);

          behavior.onNewEvent(CardDeckEvent.dealStartGame);
          await game.ready();
          game.update(1);

          expect(
            p.viewfinder.position,
            Vector2(0, MainGame2.gameMap.overviewGameVisibleSize.y * 0.5),
          );
          expect(p.viewfinder.anchor, Anchor.bottomCenter);
        },
      );
    });
  });
}
