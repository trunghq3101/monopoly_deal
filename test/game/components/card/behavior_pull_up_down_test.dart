import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monopoly_deal/game/game.dart';
import 'package:monopoly_deal/game/lib/lib.dart';

void main() {
  group('$PullUpDownBehavior', () {
    late PullUpDownBehavior behavior;

    setUp(() {
      behavior = PullUpDownBehavior();
    });

    testWithFlameGame(
        'on ${CardStateMachineEvent.pullDown}, change parent position',
        (game) async {
      final p = PositionComponent()..position = Vector2(0, 100);
      p.add(behavior);
      await game.ensureAdd(p);

      behavior.onNewEvent(Event(CardStateMachineEvent.pullDown));
      await game.ready();
      game.update(2);

      expect(p.position.y > 100, true);
    });

    testWithFlameGame(
        'on ${CardStateMachineEvent.pullUp}, change parent position',
        (game) async {
      final p = PositionComponent()..position = Vector2(0, 100);
      p.add(behavior);
      await game.ensureAdd(p);

      behavior.onNewEvent(Event(CardStateMachineEvent.pullUp));
      await game.ready();
      game.update(2);

      expect(p.position.y < 100, true);
    });
  });
}
