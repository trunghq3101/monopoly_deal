import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:monopoly_deal/game/components/card/card_publisher.dart';
import 'package:monopoly_deal/game/components/card/card_state_machine.dart';
import 'package:monopoly_deal/game/components/card/toggle_previewing_behavior.dart';
import 'package:monopoly_deal/game/game.dart';

class _MockComponent extends PositionComponent with TapCallbacks {
  @override
  void onTapDown(TapDownEvent event) {
    children.query<CardPublisher>().first.notify(CardEvent.tapped);
  }
}

class _MockGame extends FlameGame with HasTappableComponents {
  @isTest
  static Future<void> test(
    String testName,
    AsyncGameFunction<_MockGame> testBody,
  ) {
    return testWithGame<_MockGame>(testName, _MockGame.new, testBody);
  }
}

void main() {
  group('Card', () {
    late _MockComponent c;

    setUp(() {
      c = _MockComponent();
      final cardPublisher = CardPublisher();
      final cardStateMachine = CardStateMachine();
      final behavior = TogglePreviewingBehavior();
      c
        ..add(cardPublisher)
        ..add(cardStateMachine)
        ..add(behavior);
      cardPublisher.addSubscriber(cardStateMachine);
      cardStateMachine.addSubscriber(behavior);
    });

    _MockGame.test('loaded correctly', (game) async {
      await game.ensureAdd(c);
    });

    group('onTapDown', () {
      _MockGame.test('to previewing position', (game) async {
        await game.ensureAdd(c);
        c.onTapDown(createTapDownEvents());
        game.update(0.2);
        expect(c.position, GamePosition.previewCard.position);
      });

      _MockGame.test('back to hand position', (game) async {
        await game.ensureAdd(c);
        final p = c.position;
        c.onTapDown(createTapDownEvents());
        game.update(0.2);
        c.onTapDown(createTapDownEvents());
        game.update(0.2);
        expect(c.position, p);
      });
    });
  });
}
