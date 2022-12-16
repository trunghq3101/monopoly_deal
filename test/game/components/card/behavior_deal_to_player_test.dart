import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';
import 'package:monopoly_deal/game/logic/randomize_deal_offset.dart';

class _MockRandomizeDealOffset extends RandomizeDealOffset {
  static final offset = Vector2.all(2);
  @override
  Vector2 generate() => offset;
}

void main() {
  group('$DealToPlayerBehavior', () {
    const delayStep = 0.2;
    late DealToPlayerBehavior behavior;

    setUp(() {
      behavior = DealToPlayerBehavior(
        delayStep: delayStep,
        randomizeDealOffset: _MockRandomizeDealOffset(),
      );
    });

    test('has PositionComponent parent', () {
      expect(behavior, isA<ParentIsA<PositionComponent>>());
    });

    test('is a subscriber of $CardStateMachineEvent', () {
      expect(behavior, isA<Subscriber>());
    });

    group('on ${CardStateMachineEvent.toDealRegion}', () {
      testWithFlameGame(
        'given $CardDealPayload, move parent to playerPosition with offset added',
        (game) async {
          final playerPosition = Vector2.all(20);
          final p = PositionComponent();
          p.add(behavior);
          await game.ensureAdd(p);

          behavior.onNewEvent(
            Event(CardStateMachineEvent.toDealRegion)
              ..payload = CardDealPayload(0, playerPosition),
          );
          await game.ready();
          game.update(0.4);

          expect(p.position, playerPosition + _MockRandomizeDealOffset.offset);
        },
      );
    });
  });
}
