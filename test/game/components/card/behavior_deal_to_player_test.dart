import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

void main() {
  group('$DealToPlayerBehavior', () {
    late DealToPlayerBehavior behavior;

    setUp(() {
      behavior = DealToPlayerBehavior();
    });

    test('has PositionComponent parent', () {
      expect(behavior, isA<ParentIsA<PositionComponent>>());
    });

    test('is a subscriber of $CardStateMachineEvent', () {
      expect(behavior, isA<Subscriber<CardStateMachineEvent>>());
    });

    group('on ${CardStateMachineEvent.toDealRegion}', () {
      testWithFlameGame(
        'given $CardEventDealPayload, move parent to playerPosition',
        (game) async {
          final playerPosition = Vector2.all(20);
          behavior = DealToPlayerBehavior();
          final p = PositionComponent();
          p.add(behavior);
          await game.ensureAdd(p);

          behavior.onNewEvent(CardStateMachineEvent.toDealRegion,
              CardEventDealPayload(0, playerPosition));
          await game.ready();
          game.update(0.4);

          expect(p.position, playerPosition);
        },
      );

      testWithFlameGame(
        'removed from parent once finished',
        (game) async {
          final p = PositionComponent();
          p.add(behavior);
          await game.ensureAdd(p);

          behavior.onNewEvent(
            CardStateMachineEvent.toDealRegion,
            CardEventDealPayload(0, Vector2.all(100)),
          );
          await game.ready();
          game.update(0.4);
          await game.ready();

          expect(p.children.query<DealToPlayerBehavior>(), isEmpty);
        },
      );
    });
  });
}
